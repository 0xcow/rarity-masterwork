// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.2. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

interface IRarityCodexConditions {
    function advantage_by_id(uint256 _id)
        external
        pure
        returns (string memory advantage);

    function blinded()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function charmed()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function class() external view returns (string memory);

    function deafened()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function frightened()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function get_attribute(uint256 id)
        external
        pure
        returns (string memory attribute);

    function get_condition(uint256 _id)
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function grappled()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function incapacitated()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function index() external view returns (string memory);

    function invisible()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function normal()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function paralyzed()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function petrified()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function poisoned()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function prone()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function restrained()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function stunned()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );

    function unconscious()
        external
        pure
        returns (
            uint256 id,
            string memory name,
            uint256 attribute_id,
            uint256 advantage_ability_check,
            uint256 advantage_attack_for,
            uint256 advantage_attack_against,
            string memory description
        );
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"inputs":[{"internalType":"uint256","name":"_id","type":"uint256"}],"name":"advantage_by_id","outputs":[{"internalType":"string","name":"advantage","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"blinded","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"charmed","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"class","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"deafened","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"frightened","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"id","type":"uint256"}],"name":"get_attribute","outputs":[{"internalType":"string","name":"attribute","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"_id","type":"uint256"}],"name":"get_condition","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"grappled","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"incapacitated","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"index","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"invisible","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"normal","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"paralyzed","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"petrified","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"poisoned","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"prone","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"restrained","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"stunned","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"unconscious","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"name","type":"string"},{"internalType":"uint256","name":"attribute_id","type":"uint256"},{"internalType":"uint256","name":"advantage_ability_check","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_for","type":"uint256"},{"internalType":"uint256","name":"advantage_attack_against","type":"uint256"},{"internalType":"string","name":"description","type":"string"}],"stateMutability":"pure","type":"function"}]
*/