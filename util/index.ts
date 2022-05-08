import { BigNumber } from 'ethers'
import { ethers } from 'hardhat'

const usedIds:number[] = [0]
export function randomId() {
  let result = Math.floor(Math.random() * 1_000_000)
  while(usedIds.includes(result)) {
    result = Math.floor(Math.random() * 1_000_000)
  }
  return result
}

export function humanEther(wei: BigNumber) {
  return parseFloat(ethers.utils.formatEther(wei))
}

export function clean(object: any) {
  Object.keys(object).forEach(key => {
    if (isNumber(key)) delete object[key]
  })
  return object
}

export function isNumber(value: string | number): boolean
{
  return ((value != null)
    && (value !== '') 
    && !isNaN(Number(value.toString())))
}

export const equipmentSlot = {
  weapon1: 0,
  armor: 1,
  shield: 2,
  weapon2: 3,
  hands: 4,
  ring1: 5,
  ring2: 6,
  head: 7,
  headband: 8,
  eyes: 9,
  neck: 10,
  shoulders: 11,
  chest: 12,
  belt: 13,
  body: 14,
  arms: 15,
  feet: 16
}

export const enumberance = {
  unarmed: 1,
  lightMelee: 2,
  oneHanded: 3,
  twoHanded: 4,
  ranged: 5
}

export const damageType = {
  bludgeoning: 1,
  piercing: 2,
  slashing: 3
}

export function getDamageType(id: number) {
  return Object.keys(damageType)[id - 1]
}

export function unpackAttacks(attacksPack: number[]) {
  const result = []
  for(let i = 0; i < 4; i ++) {
    if(attacksPack[7 * (i + 1) - 1] > 0) {
      result.push({
        attack_bonus: attacksPack[7 * i + 0],
        critical_modifier: attacksPack[7 * i + 1],
        critical_multiplier: attacksPack[7 * i + 2],
        damage_dice_count: attacksPack[7 * i + 3],
        damage_dice_sides: attacksPack[7 * i + 4],
        damage_modifier: attacksPack[7 * i + 5],
        damage_type: attacksPack[7 * i + 6]
      })
    }
  }
  return result
} 