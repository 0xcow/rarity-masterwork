//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../core/interfaces/IRarity.sol";
import "../core/interfaces/IMaterials.sol";
import "../core/interfaces/ICodexItemsWeapons.sol";
import "../core/interfaces/ICrafting.sol";
import "./Attributes.sol";
import "./Random.sol";

library Combat {
    IRarity public constant RM =
        IRarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    codex_items_weapons internal constant WEAPON_CODEX =
        codex_items_weapons(0xeE1a2EA55945223404d73C0BbE57f540BBAAD0D8);

    function initiative(uint256 summonerId, int8 bonus)
        public
        view
        returns (int8)
    {
        int8 dMod = Attributes.dexterityModifier(summonerId);
        uint8 roll = Random.dn(8, 8, 20);
        return int8(roll) + int8(dMod) + bonus;
    }

    function basicFullAttack(
        uint256 summonerId,
        uint256 weaponId,
        ICrafting weaponContract,
        uint8 targetAC
    )
        public
        view
        returns (
            uint8 attackRoll,
            uint8 attackScore,
            uint8 damage,
            uint8 criticalRoll,
            uint8 criticalDamage
        )
    {
        attackRoll = Random.dn(targetAC, 1, 20);
        if (attackRoll == 1) {
            return (1, 0, 0, 0, 0);
        }
        uint8 _baseAttack = baseAttack(summonerId);
        attackScore = _baseAttack + attackRoll;
        if (attackRoll == 20 || attackScore >= targetAC) {
            int8 strModifier = Attributes.strengthModifier(summonerId);
            int8 weaponDamage = strModifier;
            uint256 weaponBaseDamage = 0;
            uint256 weaponCritical = 0;
            if (weaponId > 0) {
                (, uint256 itemType, , ) = weaponContract.items(weaponId);
                codex_items_weapons.weapon memory _weapon = WEAPON_CODEX
                    .item_by_id(itemType);
                weaponBaseDamage = _weapon.damage;
                weaponCritical = _weapon.critical;
                weaponDamage += int8(
                    Random.dn(_weapon.damage, 2, uint8(_weapon.damage))
                );
            }
            if (weaponDamage < 0) {
                damage = 0;
            } else {
                damage = uint8(weaponDamage);
            }
            if (attackRoll == 20) {
                // Critical?
                criticalRoll = Random.dn(20, 1, 20) + _baseAttack;
                if (criticalRoll >= targetAC) {
                    for (uint8 i = 0; i < weaponCritical; i++) {
                        weaponDamage =
                            int8(Random.dn(1, i, uint8(weaponBaseDamage))) +
                            strModifier;
                        if (weaponDamage > 0) {
                            criticalDamage += uint8(weaponDamage);
                        }
                    }
                }
            }
        }
    }

    function summonerHp(uint256 summonerId) public view returns (uint8) {
        uint256 _level = level(summonerId);
        uint256 _class = class(summonerId);
        Attributes.Abilities memory abilities = Attributes.abilityScores(
            summonerId
        );
        return
            uint8(
                healthByClassAndLevel(
                    _class,
                    _level,
                    uint32(abilities.constitution)
                )
            );
    }

    function level(uint256 summonerId) internal view returns (uint256) {
        return RM.level(summonerId);
    }

    function class(uint256 summonerId) internal view returns (uint256) {
        return RM.class(summonerId);
    }

    function healthByClass(uint256 _class)
        internal
        pure
        returns (uint256 health)
    {
        if (_class == 1) {
            health = 12;
        } else if (_class == 2) {
            health = 6;
        } else if (_class == 3) {
            health = 8;
        } else if (_class == 4) {
            health = 8;
        } else if (_class == 5) {
            health = 10;
        } else if (_class == 6) {
            health = 8;
        } else if (_class == 7) {
            health = 10;
        } else if (_class == 8) {
            health = 8;
        } else if (_class == 9) {
            health = 6;
        } else if (_class == 10) {
            health = 4;
        } else if (_class == 11) {
            health = 4;
        }
    }

    function baseAttack(uint256 summonerId) internal view returns (uint8) {
        uint256 _level = level(summonerId);
        uint256 _class = class(summonerId);
        return uint8(baseAttackBonusByClassAndLevel(_class, _level));
    }

    function healthByClassAndLevel(
        uint256 _class,
        uint256 _level,
        uint32 _const
    ) internal pure returns (uint256 health) {
        int256 _mod = computeModifier(_const);
        int256 _base_health = int256(healthByClass(_class)) + _mod;
        if (_base_health <= 0) {
            _base_health = 1;
        }
        health = uint256(_base_health) * _level;
    }

    function baseAttackBonusByClass(uint256 _class)
        public
        pure
        returns (uint256 attack)
    {
        if (_class == 1) {
            attack = 4;
        } else if (_class == 2) {
            attack = 3;
        } else if (_class == 3) {
            attack = 3;
        } else if (_class == 4) {
            attack = 3;
        } else if (_class == 5) {
            attack = 4;
        } else if (_class == 6) {
            attack = 3;
        } else if (_class == 7) {
            attack = 4;
        } else if (_class == 8) {
            attack = 4;
        } else if (_class == 9) {
            attack = 3;
        } else if (_class == 10) {
            attack = 2;
        } else if (_class == 11) {
            attack = 2;
        }
    }

    function baseAttackBonusByClassAndLevel(uint256 _class, uint256 _level)
        public
        pure
        returns (uint256)
    {
        return (_level * baseAttackBonusByClass(_class)) / 4;
    }

    function computeModifier(uint256 ability) internal pure returns (int256) {
        if (ability < 10) return -1;
        return (int256(ability) - 10) / 2;
    }
}