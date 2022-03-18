// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract codex {
    string constant public index = "Items";
    string constant public class = "Tools";
    uint8 constant public base_type = 4;

    struct effects_struct {
        int[36] skill_bonus;
    }

    function item_by_id(uint _id) public pure returns(
        uint8 id,
        uint cost,
        uint weight,
        string memory name,
        string memory description,
        effects_struct memory effects
    ) {
        if (_id == 2) {
            return artisans_tools();
        }
    }

    function artisans_tools() public pure returns (
        uint8 id,
        uint cost,
        uint weight,
        string memory name,
        string memory description,
        effects_struct memory effects
    ) {
        id = 2;
        name = "Artisan's Tools";
        cost = 5e18;
        weight = 5;
        description = "These special tools include the items needed to pursue any craft. Without them, you have to use improvised tools (-2 penalty on Craft checks), if you can do the job at all.";
        effects.skill_bonus[6] = 0;
    }
}