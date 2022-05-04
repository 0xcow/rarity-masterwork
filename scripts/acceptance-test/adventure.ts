import { ethers } from 'hardhat'
import { equipmentType, getDamageType } from '../../test/util'
import monsterCodex from '../../test/util/monster-codex.json'
import { jumpOneDay, jumpOneMinute } from "../../test/util/jump"
import party from './party.json'

const samples = 10
const gasLimit = 2_000_000

async function getTurnOrder(contracts: any, adventureToken: any) {
  const turnOrder = []
  const adventure = await contracts.adventure2.adventures(adventureToken)
  for(let i = 0; i < adventure.monster_count + 1; i++) {
    turnOrder.push(await contracts.adventure2.turn_orders(adventureToken, i))
  }
  return { adventure, turnOrder }
}

async function getMonster(contracts: any, combatantToken: any) {
  const monsterId = await contracts.adventure2.monster_spawn(combatantToken)
  return monsterCodex.find((monster: any) => monster.id === monsterId)?.name
}

async function getInititalTurnOrder(contracts: any, initialSummoner: any, adventureToken: any) {
  const { adventure, turnOrder } = await getTurnOrder(contracts, adventureToken)
  const index = turnOrder.findIndex((combatant: any) => combatant.token.eq(initialSummoner.token))
  turnOrder[index] = { ...initialSummoner, initiative_roll: turnOrder[index]['initiative_roll'], initiative_score: turnOrder[index]['initiative_score'] }
  return turnOrder
}

async function logTurnOrder(contracts: any, turnOrder: any) {
  console.log('\n-- status')
  for(let i = 0; i < turnOrder.length; i++) {
    const combatant = turnOrder[i]
    const type = combatant['origin'] === contracts.rarity.address ? 'Summoner' : await getMonster(contracts, combatant['token'])
    console.log(type, 'hp', combatant['hit_points'], 'ac', combatant['armor_class'], 'initiative', combatant['initiative_score'])
  }  
}

async function logAttacks(contracts: any, adventureToken: any, tx: any) {
  const { adventure, turnOrder } = await getTurnOrder(contracts, adventureToken)
  const summonersTurn = await contracts.adventure2.summoners_turns(adventureToken)
  for(let i = 0; i < tx.events.length; i++) {
    if(tx.events[i].event === 'Attack') {
      const args = tx.events[i].args
      const attacker = turnOrder[args['attacker'].toNumber()]
      const defender = turnOrder[args['defender'].toNumber()]
      const attacker_name = args['attacker'].eq(summonersTurn) ? 'Summoner' : await getMonster(contracts, attacker.token)
      const defender_name = args['defender'].eq(summonersTurn) ? 'Summoner' : await getMonster(contracts, defender.token)

      if(args['hit']) {
        const critical = args['critical_confirmation'] >= defender.armor_class
        console.log(
          'round', args['round'],
          critical ? `🎆 ${attacker_name} crits ${defender_name} for` : `💥 ${attacker_name} hits ${defender_name} for`, 
          args['damage'], 'points of', getDamageType(args['damage_type']), 'damage',
          '::', args['roll'], args['score'], args['critical_confirmation']
        )
      } else {
        console.log(
          'round', args['round'], `🤡 ${attacker_name} misses ${defender_name}`, '::', args['roll'], args['score'], args['critical_confirmation']
        )
      }

    } else if(tx.events[i].event === 'Dying') {
      const args = tx.events[i].args
      const combatant = turnOrder[args['combatant']]
      const combatant_name = args['combatant'].eq(summonersTurn) ? 'Summoner' : await getMonster(contracts, combatant.token)
      console.log('round', args['round'], '💀', combatant_name, 'is no longer')

    }
  }
}

async function adventure(
  contracts: any, 
  logging: boolean, 
  adventureToken: any, 
  adventurer: any, 
  level: number, 
  loadout: number, 
  equipment: any, 
  equipmentAddress: any
) {
  if(logging) console.log()

  if(logging) console.log(`-- Adventure ${adventureToken.toString()} ---------------- }~-`)
  if(logging) console.log(`-- Level ${level} Fighter`)

  const masterwork = isMasterwork(contracts, equipmentAddress)
  let summonerPreview = null
  switch(loadout) {
    case 0: {
      await contracts.adventure2.equip(adventureToken, equipmentType.weapon, equipment.longsword, equipmentAddress, { gasLimit })
      await contracts.adventure2.equip(adventureToken, equipmentType.armor, equipment.armor, equipmentAddress, { gasLimit })
      await contracts.adventure2.equip(adventureToken, equipmentType.shield, equipment.shield, equipmentAddress, { gasLimit })
      summonerPreview = await contracts.adventure2.preview(adventurer, equipment.longsword, equipmentAddress, equipment.armor, equipmentAddress, equipment.shield, equipmentAddress)
      if(logging) console.log(`-- Armed with ${masterwork?'masterwork ':''}longsword, big wood shield, and full plate armor`)
      break
    } case 1: {
      await contracts.adventure2.equip(adventureToken, equipmentType.weapon, equipment.greatsword, equipmentAddress, { gasLimit })
      await contracts.adventure2.equip(adventureToken, equipmentType.armor, equipment.armor, equipmentAddress, { gasLimit })
      summonerPreview = await contracts.adventure2.preview(adventurer, equipment.greatsword, equipmentAddress, equipment.armor, equipmentAddress, 0, ethers.constants.AddressZero)
      if(logging) console.log(`-- Armed with ${masterwork?'masterwork ':''} greatsword and full plate armor`)
      break
    } default: {
      summonerPreview = await contracts.adventure2.preview(adventurer, 0, ethers.constants.AddressZero, 0, ethers.constants.AddressZero, 0, ethers.constants.AddressZero)
      if(logging) console.log('-- Unarmed')
    }
  }

  const enterTx = await(await contracts.adventure2.enter_dungeon(adventureToken, { gasLimit })).wait()
  const initialTurnOrder = await getInititalTurnOrder(contracts, summonerPreview, adventureToken)
  if(logging) await logTurnOrder(contracts, initialTurnOrder)
  if(logging) console.log()
  if(logging) await logAttacks(contracts, adventureToken, enterTx)

  while(!(await contracts.adventure2.adventures(adventureToken)).combat_ended) {
    const target = await contracts.adventure2.next_able_monster(adventureToken)
    const attackTx = await(await contracts.adventure2.attack(adventureToken, target, { gasLimit })).wait()
    if(logging) await logAttacks(contracts, adventureToken, attackTx)
    await jumpOneMinute()
  }

  if(logging) await logTurnOrder(contracts, (await getTurnOrder(contracts, adventureToken)).turnOrder)

  const adventure = await contracts.adventure2.adventures(adventureToken)
  if(adventure.monsters_defeated === adventure.monster_count) {
    if(logging) console.log('VICTORY!')

    const searchTx = await(await contracts.adventure2.search(adventureToken)).wait()
    const searchArgs = searchTx.events[0].args
    const searchSuccess = searchArgs['score'] >= 20
    const searchCrit = searchArgs['roll'] == 20
    if(searchSuccess) {
      if(searchCrit) {
        if(logging) console.log('\n🎇 20% more loot found!', '::', searchArgs['roll'], searchArgs['score'])
      } else {
        if(logging) console.log('\n🔍 15% more loot found!', '::', searchArgs['roll'], searchArgs['score'])
      }
    } else {
      if(logging) console.log('\n💔 no more loot found', '::', searchArgs['roll'], searchArgs['score'])
    }

    if(logging) console.log('-- end adventure')
    await contracts.adventure2.end(adventureToken)
    const claimTx = await(await contracts.mats2.claim(adventureToken)).wait()
    const transferArgs = claimTx.events.find((e: any) => e.event === 'Transfer').args
    if(logging) console.log('💰', ethers.utils.formatEther(transferArgs['value']), 'mats claimed')
  } else {
    if(logging) console.log('-- end adventure')
    await contracts.adventure2.end(adventureToken)
  }

  if(logging) console.log()
  return adventure.monsters_defeated === adventure.monster_count
}

function isMasterwork(contracts: any, address: any) {
  return address === contracts.crafting.masterwork.address
}

export async function winRates(contracts: any, equipmentApprovals: any, equipment: any, equipmentAddress: any) {
  // const loadout = 0
  // const loadoutDescription = masterwork ? 'masterwork longsword/full plate/sheild' : 'longsword/full plate/sheild'
  const loadout = 1
  const loadoutDescription = isMasterwork(contracts, equipmentAddress) ? 'masterwork greatsword/full plate' : 'greatsword/full plate'

  const levels = party.fighters.length
  console.log('🤺 Monsters in the Barn levels: 1 -', levels.toString(), ' loadout:', loadoutDescription, 'samples:', samples)
  const results = Array(levels).fill([]).map(r => Array(2).fill(0))
  for(let i = 0; i < levels; i++) {
    const fighter = party.fighters[i]
    const level = i + 1
    process.stdout.write((level > 1 ? '\n' : '') + 'level ' + level + ' ')
    for(let j = 0; j < samples; j++) {
      await jumpOneDay()
      await contracts.rarity.approve(contracts.adventure2.address, fighter)
      await equipmentApprovals()
      const startTx = await(await contracts.adventure2.start(fighter, { gasLimit })).wait()
      const adventureToken = startTx.events[3].args.tokenId
      try {
        const result = await adventure(contracts, false, adventureToken, fighter, level, loadout, equipment, equipmentAddress)
        results[i][result ? 1 : 0]++
        process.stdout.write(result ? '🏆' : '👹')
      } catch(error) {
        console.log(error)
        console.log('\n-- end adventure!')
        await contracts.adventure2.end(adventureToken)
      }
    }
    process.stdout.write(' win rate ' + (100 * results[i][1] / samples).toFixed(2) + '%')
  }
  process.stdout.write('\n')
}

export async function logAdventures(contracts: any, equipmentApprovals: any, equipment: any, equipmentAddress: any) {
  for(let i = 0; i < party.fighters.length; i++) {
    const fighter = party.fighters[i]
    for(let j = 0; j < 2; j++) {
      await jumpOneDay()
      await contracts.rarity.approve(contracts.adventure2.address, fighter)
      const startTx = await(await contracts.adventure2.start(fighter, { gasLimit })).wait()
      const adventureToken = startTx.events[3].args.tokenId
      try {
        await equipmentApprovals()
        await adventure(contracts, true, adventureToken, fighter, i + 1, j, equipment, equipmentAddress)
      } catch(error) {
        console.log(error)
        console.log('\n-- end adventure!')
        await contracts.adventure2.end(adventureToken)
      }
    }
  }
}