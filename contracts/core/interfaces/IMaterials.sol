// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.2. SEE SOURCE BELOW. !!
pragma solidity 0.8.7;

interface IMaterials {
    event Approval(uint256 indexed from, uint256 indexed to, uint256 amount);
    event Transfer(uint256 indexed from, uint256 indexed to, uint256 amount);

    function adventure(uint256 _summoner) external returns (uint256 reward);

    function adventurers_log(uint256) external view returns (uint256);

    function allowance(uint256, uint256) external view returns (uint256);

    function approve(
        uint256 from,
        uint256 spender,
        uint256 amount
    ) external returns (bool);

    function armor_class(uint256 _dex) external pure returns (int256);

    function attack_bonus(
        uint256 _class,
        uint256 _str,
        uint256 _level
    ) external pure returns (int256);

    function balanceOf(uint256) external view returns (uint256);

    function base_attack_bonus_by_class(uint256 _class)
        external
        pure
        returns (uint256 attack);

    function base_attack_bonus_by_class_and_level(
        uint256 _class,
        uint256 _level
    ) external pure returns (uint256);

    function damage(uint256 _str) external pure returns (uint256);

    function decimals() external view returns (uint8);

    function dungeon_armor_class() external view returns (int256);

    function dungeon_damage() external view returns (int256);

    function dungeon_health() external view returns (int256);

    function dungeon_to_hit() external view returns (int256);

    function health_by_class(uint256 _class)
        external
        pure
        returns (uint256 health);

    function health_by_class_and_level(
        uint256 _class,
        uint256 _level,
        uint32 _const
    ) external pure returns (uint256 health);

    function modifier_for_attribute(uint256 _attribute)
        external
        pure
        returns (int256 _modifier);

    function name() external view returns (string memory);

    function scout(uint256 _summoner) external view returns (uint256 reward);

    function symbol() external view returns (string memory);

    function to_hit_ac(int256 _attack_bonus) external pure returns (bool);

    function totalSupply() external view returns (uint256);

    function transfer(
        uint256 from,
        uint256 to,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        uint256 executor,
        uint256 from,
        uint256 to,
        uint256 amount
    ) external returns (bool);
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"from","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"to","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"from","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"to","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"uint256","name":"_summoner","type":"uint256"}],"name":"adventure","outputs":[{"internalType":"uint256","name":"reward","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"adventurers_log","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"from","type":"uint256"},{"internalType":"uint256","name":"spender","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_dex","type":"uint256"}],"name":"armor_class","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_class","type":"uint256"},{"internalType":"uint256","name":"_str","type":"uint256"},{"internalType":"uint256","name":"_level","type":"uint256"}],"name":"attack_bonus","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_class","type":"uint256"}],"name":"base_attack_bonus_by_class","outputs":[{"internalType":"uint256","name":"attack","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_class","type":"uint256"},{"internalType":"uint256","name":"_level","type":"uint256"}],"name":"base_attack_bonus_by_class_and_level","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_str","type":"uint256"}],"name":"damage","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"dungeon_armor_class","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"dungeon_damage","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"dungeon_health","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"dungeon_to_hit","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_class","type":"uint256"}],"name":"health_by_class","outputs":[{"internalType":"uint256","name":"health","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_class","type":"uint256"},{"internalType":"uint256","name":"_level","type":"uint256"},{"internalType":"uint32","name":"_const","type":"uint32"}],"name":"health_by_class_and_level","outputs":[{"internalType":"uint256","name":"health","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_attribute","type":"uint256"}],"name":"modifier_for_attribute","outputs":[{"internalType":"int256","name":"_modifier","type":"int256"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_summoner","type":"uint256"}],"name":"scout","outputs":[{"internalType":"uint256","name":"reward","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"int256","name":"_attack_bonus","type":"int256"}],"name":"to_hit_ac","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"from","type":"uint256"},{"internalType":"uint256","name":"to","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"executor","type":"uint256"},{"internalType":"uint256","name":"from","type":"uint256"},{"internalType":"uint256","name":"to","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]
*/
