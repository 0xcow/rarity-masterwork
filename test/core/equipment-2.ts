import chai, { expect } from 'chai'
import { smock } from '@defi-wonderland/smock'
import { ethers } from 'hardhat'
import { fakeCommonCraftingWrapper, fakeFullPlateArmor, fakeGreatsword, fakeHeavyCrossbow, fakeHeavyWoodShield, fakeLongsword, fakeMasterwork, fakeRarity, fakeSummoner } from '../../util/fakes'
import { RarityEquipment2__factory } from '../../typechain/core'
import { Crafting__factory, Feats__factory, Proficiency__factory, Rarity__factory } from '../../typechain/library'
import { equipmentSlot } from '../../util'
import devAddresses from '../../dev-addresses.json'
import { armorType, baseType, weaponType } from '../../util/crafting'
import { armors, weapons } from '../../util/equipment'

chai.use(smock.matchers)

describe('Core: Equipment II', function () {
  before(async function () {
    this.signers = await ethers.getSigners()
    this.signer = this.signers[0]
    this.rando = this.signers[1]

    this.rarity = await fakeRarity()

    this.codex = {
      common: {
        armor: await smock.fake('contracts/codex/codex-items-armor-2.sol:codex', { address: devAddresses.codex_armor_2 }),
        weapons: await smock.fake('contracts/codex/codex-items-weapons-2.sol:codex', { address: devAddresses.codex_weapons_2 })
      },
      masterwork: {
        armor: await smock.fake('contracts/codex/codex-items-armor-masterwork.sol:codex', { address: devAddresses.codex_armor_masterwork }),
        weapons: await smock.fake('contracts/codex/codex-items-weapons-masterwork.sol:codex', { address: devAddresses.codex_weapons_masterwork })
      }
    }

    this.crafting = {
      commonWrapper: await fakeCommonCraftingWrapper(),
      masterwork: await fakeMasterwork()
    }

    this.codex.common.weapons.item_by_id
    .whenCalledWith(weaponType.greatsword)
    .returns(weapons('greatsword'))

    this.codex.common.weapons.item_by_id
    .whenCalledWith(weaponType.longsword)
    .returns(weapons('longsword'))

    this.codex.common.weapons.item_by_id
    .whenCalledWith(weaponType.heavyCrossbow)
    .returns(weapons('crossbow, heavy'))

    this.codex.common.armor.item_by_id
    .whenCalledWith(armorType.fullPlate)
    .returns(armors('full plate'))

    this.codex.common.armor.item_by_id
    .whenCalledWith(armorType.heavyWoodShield)
    .returns(armors('shield, heavy wooden'))

    this.mockEquipment = async () => 
    await(await smock.mock<RarityEquipment2__factory>('contracts/core/rarity_equipment_2.sol:rarity_equipment_2', {
      libraries: {
        Crafting: (await (await smock.mock<Crafting__factory>('contracts/library/Crafting.sol:Crafting')).deploy()).address,
        Rarity: (await(await smock.mock<Rarity__factory>('contracts/library/Rarity.sol:Rarity')).deploy()).address
      }
    })).deploy()

    this.equipment = await this.mockEquipment()

    this.setWhitelist = async function (equipment: any) {
      await equipment.set_mint_whitelist(
        this.crafting.commonWrapper.address,
        this.codex.common.armor.address,
        this.codex.common.weapons.address,
        this.crafting.masterwork.address,
        this.codex.masterwork.armor.address,
        this.codex.masterwork.weapons.address,
      )    
    }

    await this.setWhitelist(this.equipment)
  })

  beforeEach(async function() {
    this.summoner = fakeSummoner(this.rarity, this.signer)
  })

  it('sets mint whitelist only once', async function () {
    const equipment = await this.mockEquipment()
    await this.setWhitelist(equipment)
    await expect(this.setWhitelist(equipment))
    .to.be.revertedWith('already set')
  })

  it('equips weapons', async function() {
    const weapon = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, weapon)
    expect(this.crafting.commonWrapper['safeTransferFrom(address,address,uint256)']).to.have.been.calledWith(
      this.signer.address,
      this.equipment.address,
      weapon
    )

    const slot = await this.equipment.slots(this.summoner, equipmentSlot.weapon1)
    expect(slot.mint).to.eq(this.crafting.commonWrapper.address)
    expect(slot.token).to.eq(weapon)
  })

  it('equips armor', async function() {
    const armor = fakeFullPlateArmor(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.armor, this.crafting.commonWrapper.address, armor)
    expect(this.crafting.commonWrapper['safeTransferFrom(address,address,uint256)']).to.have.been.calledWith(
      this.signer.address,
      this.equipment.address,
      armor
    )

    const slot = await this.equipment.slots(this.summoner, equipmentSlot.armor)
    expect(slot.mint).to.eq(this.crafting.commonWrapper.address)
    expect(slot.token).to.eq(armor)
  })

  it('equips shields', async function() {
    const shield = fakeHeavyWoodShield(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.shield, this.crafting.commonWrapper.address, shield)
    expect(this.crafting.commonWrapper['safeTransferFrom(address,address,uint256)']).to.have.been.calledWith(
      this.signer.address,
      this.equipment.address,
      shield
    )

    const slot = await this.equipment.slots(this.summoner, equipmentSlot.shield)
    expect(slot.mint).to.eq(this.crafting.commonWrapper.address)
    expect(slot.token).to.eq(shield)
  })

  it('tracks encumberance', async function() {
    expect(await this.equipment.encumberance(this.summoner)).to.eq(0)

    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword)
    expect(await this.equipment.encumberance(this.summoner)).to.eq(4)

    const fullplate = fakeFullPlateArmor(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.armor, this.crafting.commonWrapper.address, fullplate)
    expect(await this.equipment.encumberance(this.summoner)).to.eq(54)

    await this.equipment.unequip(this.summoner, equipmentSlot.armor)
    expect(await this.equipment.encumberance(this.summoner)).to.eq(4)

    await this.equipment.unequip(this.summoner, equipmentSlot.weapon1)
    expect(await this.equipment.encumberance(this.summoner)).to.eq(0)
  })

  it('unequips slots', async function() {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword)
    await this.equipment.unequip(this.summoner, equipmentSlot.weapon1)
    expect(this.crafting.commonWrapper['safeTransferFrom(address,address,uint256)']).to.have.been.calledWith(
      this.equipment.address,
      this.signer.address,
      longsword
    )

    const slot = await this.equipment.slots(this.summoner, equipmentSlot.weapon1)
    expect(slot.mint).to.eq(ethers.constants.AddressZero)
    expect(slot.token).to.eq(0)
  })

  it('can\'t equip items in the wrong slots', async function() {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.armor, this.crafting.commonWrapper.address, longsword))
    .to.be.revertedWith('!armor')

    const fullplate = fakeFullPlateArmor(this.crafting.commonWrapper, this.summoner, this.signer)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, fullplate))
    .to.be.revertedWith('!weapon')

    await expect(this.equipment.equip(this.summoner, equipmentSlot.shield, this.crafting.commonWrapper.address, fullplate))
    .to.be.revertedWith('!shield')
  })

  it('can\'t equip two-hand weapons and shields at the same time', async function() {
    const greatsword = fakeGreatsword(this.crafting.commonWrapper, this.summoner, this.signer)
    const shield = fakeHeavyWoodShield(this.crafting.commonWrapper, this.summoner, this.signer)

    this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, greatsword)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.shield, this.crafting.commonWrapper.address, shield))
    .to.be.revertedWith('two-handed or ranged weapon equipped')

    this.equipment.unequip(this.summoner, equipmentSlot.weapon1)
    this.equipment.equip(this.summoner, equipmentSlot.shield, this.crafting.commonWrapper.address, shield)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, greatsword))
    .to.be.revertedWith('shield equipped')
  })

  it('can\'t equip ranged weapons', async function() {
    const crossbow = fakeHeavyCrossbow(this.crafting.commonWrapper, this.summoner, this.signer)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, crossbow))
    .to.be.revertedWith('ranged weapon')
  })

  it('doesn\'t support slots greater than shield', async function() {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon2, this.crafting.commonWrapper.address, longsword))
    .to.be.revertedWith('!supported')
  })

  it('equips items only once', async function() {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword)
    this.crafting.commonWrapper.ownerOf
    .whenCalledWith(longsword)
    .returns(this.equipment.address)

    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword))
    .to.be.revertedWith('!approvedForItem')
  })

  it('equips slots only once', async function() {
    const longsword1 = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    const longsword2 = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)
    await this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword1)
    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, this.crafting.commonWrapper.address, longsword2))
    .to.be.revertedWith('!slotAvailable')
  })

  it('only supports whitelisted mints', async function() {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)

    const randocraftinc = await smock.fake(
      'contracts/core/rarity_crafting_common_wrapper.sol:rarity_crafting_wrapper'
    )

    randocraftinc.ownerOf
    .whenCalledWith(longsword)
    .returns(this.signer.address)

    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, randocraftinc.address, longsword))
    .to.be.revertedWith('!whitelisted')
  })

  it('supports original common craftng contract', async function () {
    const longsword = fakeLongsword(this.crafting.commonWrapper, this.summoner, this.signer)

    const common = await smock.fake(
      'contracts/core/rarity_crafting_common.sol:rarity_crafting', 
      { address: '0xf41270836dF4Db1D28F7fd0935270e3A603e78cC' }
    )

    common.items
    .whenCalledWith(longsword)
    .returns([baseType.weapon, weaponType.longsword, 0, 0])

    common.ownerOf
    .whenCalledWith(longsword)
    .returns(this.signer.address)

    await expect(this.equipment.equip(this.summoner, equipmentSlot.weapon1, common.address, longsword))
    .to.not.be.reverted
  })
})