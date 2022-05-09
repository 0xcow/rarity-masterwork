// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

interface IRarityAdventure2 {
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event Attack(
        address indexed owner,
        uint256 indexed token,
        uint256 attacker,
        uint256 defender,
        uint8 round,
        bool hit,
        uint8 roll,
        int8 score,
        uint8 critical_confirmation,
        uint8 damage,
        uint8 damage_type
    );
    event Dying(
        address indexed owner,
        uint256 indexed token,
        uint8 round,
        uint256 combatant
    );
    event RollInitiative(
        address indexed owner,
        uint256 indexed token,
        uint8 roll,
        int8 score
    );
    event SearchCheck(
        address indexed owner,
        uint256 indexed token,
        uint8 roll,
        int8 score
    );
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    function MONSTERS(uint256) external view returns (uint8);

    function MONSTERS_BY_LEVEL(uint256) external view returns (uint8);

    function MONSTER_BONUS_INDEX_BY_LEVEL(uint256)
        external
        view
        returns (uint8);

    function SEARCH_DC() external view returns (uint8);

    function adventures(uint256)
        external
        view
        returns (
            bool dungeon_entered,
            bool combat_ended,
            bool search_check_rolled,
            bool search_check_succeeded,
            bool search_check_critical,
            uint8 monster_count,
            uint8 monsters_defeated,
            uint8 combat_round,
            uint64 started,
            uint64 ended,
            uint256 summoner
        );

    function approve(address to, uint256 tokenId) external;

    function attack(uint256 token, uint256 target) external;

    function attack_counters(uint256) external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function count_loot(uint256 token) external view returns (uint256);

    function current_turns(uint256) external view returns (uint256);

    function end(uint256 token) external;

    function enter_dungeon(uint256 token) external;

    function flee(uint256 token) external;

    function getApproved(uint256 tokenId) external view returns (address);

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

    function isApprovedOrOwnerOfAdventure(uint256 token)
        external
        view
        returns (bool);

    function is_combat_over(uint256 token) external view returns (bool);

    function is_en_combat(uint256 token) external view returns (bool);

    function is_ended(uint256 token) external view returns (bool);

    function is_outside_dungeon(uint256 token) external view returns (bool);

    function is_victory(uint256 token) external view returns (bool);

    function latest_adventures(uint256) external view returns (uint256);

    function monster_spawn(uint256) external view returns (uint8);

    function name() external view returns (string memory);

    function next_able_monster(uint256 token)
        external
        view
        returns (uint256 monsters_turn_order);

    function next_monster() external view returns (uint256);

    function next_token() external view returns (uint256);

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external returns (bytes4);

    function ownerOf(uint256 tokenId) external view returns (address);

    function roll_monsters(uint256 token, uint256 level)
        external
        view
        returns (uint8 monster_count, uint8[3] memory monsters);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) external;

    function search(uint256 token) external;

    function setApprovalForAll(address operator, bool approved) external;

    function start(uint256 summoner) external;

    function summoners_turns(uint256) external view returns (uint256);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function symbol() external view returns (string memory);

    function time_to_next_adventure(uint256 summoner)
        external
        view
        returns (uint256 time);

    function tokenByIndex(uint256 index) external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);

    function tokenURI(uint256 token) external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function turn_orders(uint256, uint256)
        external
        view
        returns (
            uint8 initiative_roll,
            int8 initiative_score,
            uint8 armor_class,
            int16 hit_points,
            address mint,
            uint256 token
        );

    function was_fled(uint256 token) external view returns (bool);
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"uint256","name":"token","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"attacker","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"defender","type":"uint256"},{"indexed":false,"internalType":"uint8","name":"round","type":"uint8"},{"indexed":false,"internalType":"bool","name":"hit","type":"bool"},{"indexed":false,"internalType":"uint8","name":"roll","type":"uint8"},{"indexed":false,"internalType":"int8","name":"score","type":"int8"},{"indexed":false,"internalType":"uint8","name":"critical_confirmation","type":"uint8"},{"indexed":false,"internalType":"uint8","name":"damage","type":"uint8"},{"indexed":false,"internalType":"uint8","name":"damage_type","type":"uint8"}],"name":"Attack","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"uint256","name":"token","type":"uint256"},{"indexed":false,"internalType":"uint8","name":"round","type":"uint8"},{"indexed":false,"internalType":"uint256","name":"combatant","type":"uint256"}],"name":"Dying","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"uint256","name":"token","type":"uint256"},{"indexed":false,"internalType":"uint8","name":"roll","type":"uint8"},{"indexed":false,"internalType":"int8","name":"score","type":"int8"}],"name":"RollInitiative","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"uint256","name":"token","type":"uint256"},{"indexed":false,"internalType":"uint8","name":"roll","type":"uint8"},{"indexed":false,"internalType":"int8","name":"score","type":"int8"}],"name":"SearchCheck","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"MONSTERS","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"MONSTERS_BY_LEVEL","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"MONSTER_BONUS_INDEX_BY_LEVEL","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"SEARCH_DC","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"adventures","outputs":[{"internalType":"bool","name":"dungeon_entered","type":"bool"},{"internalType":"bool","name":"combat_ended","type":"bool"},{"internalType":"bool","name":"search_check_rolled","type":"bool"},{"internalType":"bool","name":"search_check_succeeded","type":"bool"},{"internalType":"bool","name":"search_check_critical","type":"bool"},{"internalType":"uint8","name":"monster_count","type":"uint8"},{"internalType":"uint8","name":"monsters_defeated","type":"uint8"},{"internalType":"uint8","name":"combat_round","type":"uint8"},{"internalType":"uint64","name":"started","type":"uint64"},{"internalType":"uint64","name":"ended","type":"uint64"},{"internalType":"uint256","name":"summoner","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"},{"internalType":"uint256","name":"target","type":"uint256"}],"name":"attack","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"attack_counters","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"count_loot","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"current_turns","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"end","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"enter_dungeon","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"flee","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"isApprovedOrOwnerOfAdventure","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"is_combat_over","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"is_en_combat","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"is_ended","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"is_outside_dungeon","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"is_victory","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"latest_adventures","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"monster_spawn","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"next_able_monster","outputs":[{"internalType":"uint256","name":"monsters_turn_order","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"next_monster","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"next_token","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"bytes","name":"","type":"bytes"}],"name":"onERC721Received","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"},{"internalType":"uint256","name":"level","type":"uint256"}],"name":"roll_monsters","outputs":[{"internalType":"uint8","name":"monster_count","type":"uint8"},{"internalType":"uint8[3]","name":"monsters","type":"uint8[3]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"search","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"summoner","type":"uint256"}],"name":"start","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"summoners_turns","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"summoner","type":"uint256"}],"name":"time_to_next_adventure","outputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"turn_orders","outputs":[{"internalType":"uint8","name":"initiative_roll","type":"uint8"},{"internalType":"int8","name":"initiative_score","type":"int8"},{"internalType":"uint8","name":"armor_class","type":"uint8"},{"internalType":"int16","name":"hit_points","type":"int16"},{"internalType":"address","name":"mint","type":"address"},{"internalType":"uint256","name":"token","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"token","type":"uint256"}],"name":"was_fled","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"}]
*/
