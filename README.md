![image](https://user-images.githubusercontent.com/89237203/164444719-88a514ba-962c-44b8-8693-dd947d660e65.png)


# Rarity Masterwork
Masterwork is a new crafting level for Rarity players and builders. Like Rarity's first crafting level, masterwork contains a crafting station and a dungeon. Use the masterwork crafting station to create masterwork weapons, armor, and tools. Defeat monsters in the dungeon for loot that enhances your bonus at the crafting station.

Masterwork is an expansion of the original Rarity core created by Andre Cronje, et al in September 2021. It continues the core vision of a free-to-mint, permissionless, d20 implementation in solidity.

### So what?
Masterwork weapons and armor are exceptional. They are made so well that you get a bonus when using them. Masterwork weapons make you more accurate, granting a +1 bonus on all attacks. That is, you get a 10% better chance of hitting an Armor Class of 10, 5% better odds against AC 20, and so on. Masterwork armor fits you perfectly, granting a +1 armor check bonus. This gives you better odds whenever your movement is in check, such as sneaking up on an opponent or climbing out of a trap.

✨🧙‍♂️✨ - Masterwork crafting is also the basis for magic weapons and armor. Magic weapons and armor grant even more bonuses such as extra damage and improved armor class. A Magic Crafting expansion to Rarity core is in the works.

### Now what?
This git repo contains all the dev tooling used to build and test Masterwork. Use it as a reference for integrating masterwork with your projects! 

## Contents
- [Get started](#get-started)
- [Rarity Crafting 2 - Masterwork Weapons, Armor, and Tools](#rarity-crafting-2---masterwork-weapons-armor-and-tools)
- [Rarity Adventure 2 - Monsters in the Barn](#rarity-adventure-2---monsters-in-the-barn)
- [Rarity Core Library](#rarity-core-library)
- [How to use masterwork items in your game](#how-to-use-masterwork-items-in-your-game)
- [More package commands](#more-package-commands)
- [hardhat.config.ts customizations](#hardhatconfigts-customizations)
- [Default hardhat commands](#default-hardhat-commands)
- [Thank You 👹🙏](#thank-you-)


## Get started
```shell
git clone git@github.com:murderteeth/rarity-masterwork.git
cd rarity-masterwork
yarn
npx hardhat compile
yarn test
```

## Rarity Crafting 2 - Masterwork Weapons, Armor, and Tools
Masterwork items, like common items, are minted to your wallet as standard ERC721 tokens. Creating a masterwork item consists of starting a masterwork project, making craft checks until the item is finished, then completing the project and configuring the official masterwork item. The mechanic allows multiple summoners to participate in the crafting of the same item. For example, you can have one summoner pay for the project's raw materials, have many different summoners make craft checks, then choose a totally different summoner to complete the project and have the new item minted in their name.

### Walkthru
1. Starting a new masterwork project requires an upfront payment for raw materials. Approve the contract's apprentice to receive the fees like this:
```ts
const cost = await masterwork.raw_materials_cost(baseType.weapon, weaponType.longsword)
await gold.approve(summoner, await masterwork.APPRENTICE(), cost)
```
Masterwork crafting also requires artisan's tools. You can use the masterwork crafting station to craft masterwork artisan's tools for a +2 bonus on craft checks. But until then, pay an extra 5gp to "rent" a set of common artisan tools:
```ts
let cost = await masterwork.raw_materials_cost(baseType.weapon, weaponType.longsword)
cost += await masterwork.COMMON_ARTISANS_TOOLS_RENTAL()
await gold.approve(summoner, await masterwork.APPRENTICE(), cost)
```

2. Once your gold is approved start a new project like this if you don't have masterwork artisan's tools:
```ts
await masterwork.start(summoner, baseType.weapon, weaponType.longsword, 0, ethers.constants.AddressZero)
```
If you have masterwork artisan's tools:
```ts
await masterwork.start(summoner, baseType.weapon, weaponType.longsword, <masterwork artisans tools tokenId>, masterwork.address)
```

Calling `start` does this
- Transfer appropriate project costs, in gold, from `summoner` to `masterwork.APPRENTICE()`
- If supplied, transfer your masterwork artisan's tools to the contract
- Mints a new masterwork ERC721 token to your wallet representing the project and, eventually, the masterwork item

At anytime, get status on a project like this:
```ts
const project = await this.masterwork.projects(masterworkToken)
console.log('project', project)
```

At anytime, before the masterwork item is complete, you can cancel a project and reclaim your masterwork artisan's tools (if supplied):
```ts
await masterwork.cancel(masterworkToken)
```

3. After the project is started, select summoners and make craft checks:
```ts
await masterwork.craft(masterworkToken, summoner, 0)
```
For a bonus on craft checks, specify bonus materials, +1 for every 20 mats:
```ts
await masterwork.craft(masterworkToken, summoner, ethers.utils.parseEther('80')) //for a +4 bonus
```
Calling `craft` does this
- Compute a craft check for `summoner`
  - roll 1 d20
  - add `summoner` intelligence modifier
  - add `summoner` specialty crafting ranks appropriate for weapons or armor
  - or if crafting masterwork tools, add `summoner` base crafting skill ranks (no specialty required)
- If the score is equal or higher the item's DC (difficulty class), the check succeeds and the score is applied to the project's progress in exchange for `summoner`'s experience points. If your score is high enough to complete the project, `summoner` pays a prorated amount of XP. The XP cost of making a craft check is otherwise one day's XP, or 250 XP.
- If the craft check score is less than the item's DC, the check fails, no progress is made, and one day's XP is burned (250 XP)

Check the progress of a project:
```ts
const [progress, masterworkItemCostInSilver] = await masterwork.get_progress(masterworkToken)
const percentDone = progress.div(masterworkItemCostInSilver)
```
Estimate a project's remaining XP cost:
```ts
const estimate = await masterwork.estimate_remaining_xp_cost(masterworkToken)
console.log('estimate', ethers.utils.formatEther(estimate))
```
Get a summoner's odds of succeeding a craft check:
```ts
const [averageCraftCheck, itemDC] = await masterwork.craft_check_odds(masterworkToken, summoner, bonusMats)
console.log('odds', averageCraftCheck / itemDC)
```

4. When crafting is done (progress >= masterworkItemCostInSilver), complete the project:
```ts
await masterwork.complete(masterworkToken, summoner)
```
Calling `complete` does this
- Configures your token's masterwork item properties making the item useable in rarity games
- Transfer your masterwork artisan's tools back to your wallet (if specified during project start)
- Marks the project complete

### Tracking craft events
Each craft attempt emits a `Craft` event containing the craft check result, spent mats, spent xp, and crafting progress. Handy for showing a crafting log.

### Crafting Specializations
Masterwork weapons and armor require summoner's to take up specialized crafting skills. Specialization ranks are redeemable 1:1 for core skill ranks in crafting. The following specializations are available:
- Alchemy (for future expansion, spellcasters only)
- Armorsmithing
- Bowmaking
- Trapmaking (for future expansion)
- Weaponsmithing

Specialized skills are managed with the `rarity_crafting_skills` contract. This was designed to work just like the existing core skills contract. For example, raise a summoner's weaponsmithing specialization like this:
```ts
const craftingSkills = await craftingSkills.get_skills(summoner)
craftingSkills[4] += 1
await craftingSkills.set_skills(summoner, craftingSkills)
```

### Codex
You can craft masterwork versions of all the items found in the core weapons and armor codexes.

You can also craft the following masterwork tools, found in the [masterwork tools codex](contracts/codex/codex-items-tools-masterwork.sol):

**Masterwork Artisan's Tools** - These tools serve the same purpose as artisan's tools, but masterwork artisan's tools are the perfect tools for the job, so you get a +2 circumstance bonus on Craft checks made with them.

**Masterwork Musical Instrument** - A masterwork instrument grants a +2 circumstance bonus on Perform checks involving its use.

**Masterwork Thieves Tools** - This kit contains extra tools and tools of better make, which grant a +2 circumstance bonus on Disable Device and Open Lock checks.

**Masterwork Multitool** - This well-made item is the perfect tool for the job. It grants a +2 circumstance bonus on a related skill check (if any). Bonuses provided by multiple masterwork items used toward the same skill check do not stack.

A codex for common tools, [codex-items-tools.sol](/contracts/codex/codex-items-tools.sol) has also been provided for future expansion

### Mechanics theory
Masterwork adapted its mechanics from the following d20 rules while also continuing ideas from the core common crafting contract. The mechanics have been tuned such that a level 5 crafter with maxed craft skills can complete a masterwork longsword in exchange for 1 week of XP, without supplying any bonus crafting mats.

[from d20, _under Check_](https://www.d20srd.org/srd/skills/craft.htm)
> All crafts require artisan's tools to give the best chance of success. If improvised tools are used, the check is made with a -2 circumstance penalty. On the other hand, masterwork artisan's tools provide a +2 circumstance bonus on the check.

> To determine how much time and money it takes to make an item, follow these steps.
> - Find the item's price. Put the price in silver pieces (1 gp = 10 sp).
> - Find the DC from the table below.
> - Pay one-third of the item's price for the cost of raw materials.
> - Make an appropriate Craft check representing one week's work. If the check succeeds, multiply your check result by the DC. If the result × the DC equals the price of the item in sp, then you have completed the item. (If the result × the DC equals double or triple the price of the item in silver pieces, then you've completed the task in one-half or one-third of the time. Other multiples of the DC reduce the time in the same manner.) If the result × the DC doesn't equal the price, then it represents the progress you've made this week. Record the result and make a new Craft check for the next week. Each week, you make more progress until your total reaches the price of the item in silver pieces.

[from d20, _under Creating Masterwork Items_](https://www.d20srd.org/srd/skills/craft.htm)
> You can make a masterwork item—a weapon, suit of armor, shield, or tool that conveys a bonus on its use through its exceptional craftsmanship, not through being magical. To create a masterwork item, you create the masterwork component as if it were a separate item in addition to the standard item. The masterwork component has its own price (300 gp for a weapon or 150 gp for a suit of armor or a shield) and a Craft DC of 20. Once both the standard component and the masterwork component are completed, the masterwork item is finished.


## Rarity Adventure 2 - Monsters in the Barn
Monsters in the Barn is a single player, turn-based combat encounter. The adventure begins outside a barn where monsters have been hording salvage. Choose a summoner, equip them with weapons and armor, enter the barn.. If you defeat the monsters, claim their salvage and use it for a bonus on crafting checks at the masterwork crafting station. If you loose, try again tomorrow. This adventure is minted to your wallet as a standard ERC721 token. 

### Leveling logic
Monsters in the Barn is designed to be challenging for summoners level 1 through 8. Entering the barn initiaties combat with up to 3 monsters. Summoners are matched against monsters having a CR (challenge rating) equal to their level or lower.

### Rarity Crafting Materials 2 - Barn salvage
Claim barn salvage mats for victory in the barn. These mats are redeemable at 10:1 against each monster's CR. That is, slaying a monster with CR 4 awards 40 mats. These mats are minted to your wallet as standard ERC20 tokens.

### Walkthru
1. Start a new Monsters in the Barn adventure by selecting a summoner and calling `start` on the [adventure 2](contracts/core/rarity_adventure-2.sol) contract:
```ts
await barnAdventure.start(summoner)
```
Calling `start` does this
- Transfer `summoner` to the adventure contract
- Mints a new ERC721 token to your wallet representing the adventure

At anytime, get status on an adventure like this:
```ts
const adventure = await barnAdventure.adventures(adventureToken)
console.log('adventure', adventure)
```
At anytime you can end the adventure and reclaim your summoner:
```ts
await barnAdventure.end(adventureToken)
```

2. Your summoner is now standing outside the barn. Before they enter, equip them with weapons and armor like this:
```ts
// equipment slots: 0 = weapons, 1 = armor, 2 = shields
await barnAdventure.equip(adventureToken, 0, longswordToken, longswordContractAddress)
await barnAdventure.equip(adventureToken, 1, armorToken, armorContractAddress)
await barnAdventure.equip(adventureToken, 2, shieldToken, shieldContractAddress)
```
Note that the last parameter is the address of the crafting contract that issues a given item token. Monsters in the Barn accepts weapons and armor from these two contracts: 
- [common items wrapper](contracts/core/rarity_crafting_common_wrapper.sol)
- [masterwork items](contracts/core/rarity_crafting_masterwork.sol)

The common items wrapper makes is easy for the adventure contract, and its underlying combat system, to handle common and masterwork items through the same interfaces.

Players may also choose to fight unarmed and/or unarmored. This is only recommended for Monks, however, who receive attack and armor bonuses [as outlined here](https://www.d20srd.org/srd/classes/monk.htm).

3. Enter the barn..
```ts
await barnAdventure.enter_dungeon(adventureToken)
```
Calling `enter_dungeon` does this
- Randomly "mints" up to 3 monsters
- Rolls [initiative](https://www.d20srd.org/srd/combat/initiative.htm) for the summoner and each monster
- Orders the combatants by their initiative scores into a Turn Order
- Starting at the top of the Turn Order, combatants take their turns until it's the summoner's turn

Get the current turn order like this:
```ts
const turnOrder = await barnAdventure.turn_orders(adventureToken)
```
Where `turnOrder` is an array containing tokenIds for summoners and monsters. Monster tokenIds are internal to the adventure contract.

Get the combat's current turn index like this:
```ts
const currentTurn = await barnAdventure.current_turns(adventureToken)
```

Get the summoner's turn order index like this:
```ts
const summonersTurn = await barnAdventure.summoners_turns(adventureToken)
```

4. Attack! When it's your summoner's turn you can `attack` or `flee`. To attack, chose a target by their turn order index. For convenience, you can "auto target" monsters using a call to `next_able_monster`.
```ts
const target = await barnAdventure.next_able_monster(adventureToken)
await barnAdventure.attack(adventureToken, target)
```
Calling `attack` does this
- Roll attack for the adventure's `summoner`
- If the attack score is equal or higher the target monster's AC (armor class), the attack hits, and a damage roll is made
- If the attack roll is a natural 20 (or within the equipped weapon's critical range), the attack is critical, and extra damage is rolled according to the weapon's critical multiplier
- If the attack score is less than the monster's AC, the attack is a miss
- If the target's hit points (HP) are brought below zero, the monster is dying and considered slain
- If the summoner has no more attacks for the round, monsters take their turns until it's the summoner's next turn

Some monsters get more than one attack per round. The good news. Barbarians, fighters, paladins, and rangers also get extra attacks per round starting at level 6! The adventure contract keeps track of these attacks for you. To get the current attack number:
```ts
const attackCounter = await barnAdventure.attack_counters(adventureToken)
```

But generally, while combat is ongoing, it will always be the summoner's turn from the perspective of a contract client (as the monsters' moves are played automatically between summoner moves). So you can just call `attack` until combat is over:
```ts
await barnAdventure.is_combat_over(adventureToken)
```

5. Ending combat - Combat ends automatically when either the summoner or all the monsters are below 0 hit points. Alternatively, you can also chose to flee:
```ts
await barnAdventure.flee(adventureToken)
```
Fleeing doesn't do anything special beside set the combat to over. It's provided more for narrative "flavor". You can also simply `end` the entire adventure whenever you like.

6. Victory !!
To win the dungeon your summoner must defeat all the monsters. If you are victorious, run an optional search check for a loot bonus on the monsters' salvage:
```ts
await barnAdventure.search(adventureToken)
```
The search check goes like this
- Roll 1 d20
- Add `summoner` search skill ranks
- +2 if the `summoner` has the investigator feat

If the score is higher than the adventure's search DC you get a 15% bonus. If you roll a natural 20, you get a 20% bonus. Nice! Now you can end the adventure and claim your loot:
```ts
await barnAdventure.end(adventureToken)
await crafingMaterials2.claim(adventureToken)
```
Mat rewards are minted to your wallet as standard ERC20 tokens.

### Tracking combat events
Each attack emits an `Attack` event containing attacker, defender, and attack results. Handy for showing a combat log.

### Combat mechanics
The mechanics of Monsters in the Barn follow d20 combat closely, but only cover the very basics. Future expansions will cover more advanced mechanics like movement, ranged weapons, spells, saving throws, conditions, and buffs. For full details check out [d20 Combat](https://www.d20srd.org/indexes/combat.htm).

### Tired of killing rats?? Meet the monsters from the barn
The following d20 monsters were chosen for their CRs and relatively simple attack and damage properties.
- [**Kobold (CR 1/4)**](https://www.d20srd.org/srd/monsters/kobold.htm)
- [**Goblin (CR 1/3)**](https://www.d20srd.org/srd/monsters/goblin.htm)
- [**Gnoll (CR 1)**](https://www.d20srd.org/srd/monsters/gnoll.htm)
- [**Black Bear (CR 2)**](https://www.d20srd.org/srd/monsters/bearBlack.htm)
- [**Ogre (CR 3)**](https://www.d20srd.org/srd/monsters/ogre.htm)
- [**Dire Wolverine (CR 4)**](https://www.d20srd.org/srd/monsters/direWolverine.htm)
- [**Troll (CR 5)**](https://www.d20srd.org/srd/monsters/troll.htm)
- [**Ettin (CR 6)**](https://www.d20srd.org/srd/monsters/ettin.htm)
- [**Hill Giant (CR 7)**](https://www.d20srd.org/srd/monsters/giant.htm#hillGiant)
- [**Stone Giant (CR 8)**](https://www.d20srd.org/srd/monsters/giant.htm#stoneGiant)


## Rarity Core Library
Masterwork's crafting and dungeon mechanics are complex. For sanity's sake we started the [rarity core solidity library](https://github.com/murderteeth/rarity-masterwork/tree/main/contracts/library) to abstract everything a builder needs to create their own d20 adventures. 

The library is extensive and growing. Documentation will come in a future iteration. For now, lets look at how combat is implemented. The library lets you have any character attack any other character using d20 rules to govern the outcome. It does this by first requiring that each fighter be adapted to a standard `Combatant` struct. This allows the combat system to run d20 combat rules against a common interface and enables summoner vs monster and summoner vs summoner combat.. it also enables monster vs monster and, in theory, any nft against any nft.

Check out the current `Combatant` stuct:
```solidity
struct Combatant {
  uint8 initiative_roll;
  int8 initiative_score;
  uint8 armor_class;
  int16 hit_points;
  address origin;
  uint token;
  int8[28] attacks;
}
```
- **initiative_roll/score** - Determines turn order
- **armor_class** - How difficult it is to hit this combatant
- **hit_points** - How much damage can be taken
- **origin** - Contract address that issues this combatant's underlying token
- **token** - This combatant's underlying nft (eg, a Summoner Id)
- **attacks** - An array containing all the combatant's attacks per round

The current `attacks` array can contain up to 4 attacks. Each attack has these properties:
- attack_bonus
- critical_modifier
- critical_multiplier
- damage_dice_count
- damage_dice_sides
- damage_modifier
- damage_type

Helper functions for packing and unpacking the `attacks` array live in the [Combat library](https://github.com/murderteeth/rarity-masterwork/blob/main/contracts/library/Combat.sol).

Monsters in the Barn implements summoner vs monster combat. To adapt summoners and monsters to the `Combatant` struct it uses these two functions:

```solidity
function summoner_combatant(uint token, uint summoner) internal returns(Combat.Combatant memory combatant) {
  (uint8 initiative_roll, int8 initiative_score) = Roll.initiative(summoner);
  emit RollInitiative(_msgSender(), token, initiative_roll, initiative_score);

  Combat.EquipmentSlot memory weapon_slot = equipment_slots[token][EQUIPMENT_TYPE_WEAPON];
  Combat.EquipmentSlot memory armor_slot = equipment_slots[token][EQUIPMENT_TYPE_ARMOR];
  Combat.EquipmentSlot memory shield_slot = equipment_slots[token][EQUIPMENT_TYPE_SHIELD];

  combatant.origin = address(RARITY);
  combatant.token = summoner;
  combatant.initiative_roll = initiative_roll;
  combatant.initiative_score = initiative_score;
  combatant.hit_points = int16(uint16(Summoner.hit_points(summoner)));
  combatant.armor_class = Summoner.armor_class(summoner, armor_slot, shield_slot);
  combatant.attacks = Summoner.attacks(summoner, weapon_slot, armor_slot, shield_slot);
}

function monster_combatant(Monster.MonsterCodex memory monster_codex) internal returns(Combat.Combatant memory combatant) {
  monster_spawn[next_monster] = monster_codex.id;

  (uint8 initiative_roll, int8 initiative_score) = Roll.initiative(
    next_monster, 
    Attributes.compute_modifier(monster_codex.abilities[1]), 
    monster_codex.initiative_bonus
  );

  combatant.origin = address(this);
  combatant.token = next_monster;
  combatant.initiative_roll = initiative_roll;
  combatant.initiative_score = initiative_score;
  combatant.hit_points = Monster.hit_points(monster_codex, next_monster);
  combatant.armor_class = monster_codex.armor_class;
  combatant.attacks = monster_codex.attacks;

  next_monster += 1;
}
```

Note the use of another struct from the `Combat` library, `EquipmentSlot`, and several other functions from the `Roll` and `Summoner` libraries to make adapting to the Combatant struct easy. With those adapters in place Monsters in the Barn can run an attack like this:

```solidity
(bool hit, uint8 roll, int8 score, uint8 critical_confirmation, uint8 damage, uint8 damage_type) 
    = Combat.attack_combatant(attacker, defender, attack_number);
```

## How to use masterwork items in your game
The key feature of a masterwork longsword is the +1 attack bonus it grants its wielder. The masterwork contract exposes these special features through the `IEffects` interface found in the [Effects library](contracts/library/Effects.sol). In the case of a longsword, query its attack bonus like this:

```solidity
int8 attack_bonus = masterwork.attack_bonus(longswordToken);
```

In your game you probably want to support masterwork and common items at the same time. But the common items contract doesn't support `IEffects` and reverts if you try to call any IEffects functions. You could use branching logic, but that won't scale as you consider new item contracts in the future. Monsters in the Barn had this problem. So the library was updated to use both common and masterwork items by talking to the common items contract through a [wrapper contract](contracts/core/rarity_crafting_common_wrapper.sol) that adds the same `IEffects` interface used by masterwork.

Going back to the masterwork longsword, if you want to compute the correct attack bonus for your summoner you now have two options:
- Call `masterwork.attack_bonus(longswordToken)` directly (and add some branching logic for common longswords)
- Use the common item contract wrapper so that you can call `IEffects` functions on either contract

Another option is to let the library do it for you by using its `EquipmentSlot` and `Combatant` structs. This is how Monsters in the Barn is implemented, so that's the best reference. For now consider this code snip:

```solidity
import "../library/Combat.sol";

Combat.EquipmentSlot memory weapon_slot = Combat.EquipmentSlot(masterwork_address, longsword_id);
Combat.EquipmentSlot memory armor_slot = Combat.EquipmentSlot(common_wrapper_address, full_plate_id);
Combat.EquipmentSlot memory shield_slot = Combat.EquipmentSlot(address(0), 0);
int8[28] attacks = Summoner.attacks(summoner, weapon_slot, armor_slot, shield_slot);

Combat.Attack memory primary_attack = Combat.unpack_attack(attacks, 0);
```
In this example we get a summoner's primary attack with all weapon and armor bonuses/penalties applied as if they equiped a masterwork longsword, a common suite of full plate armor, and no shield. The `Attack` struct contains things like full attack bonus and damage dice.


## More package commands
```shell
yarn test
yarn test-fast
yarn report-gas
yarn random-uint256   # handy for generating random seeds
```


## hardhat.config.ts customizations
### typechain
### interfaces
```shell
npx hardhat rarity-interfaces
```

## default hardhat commands
```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```


# Thank You 👹🙏
Please join me and say thanks to these great folks:

### [zgohr](https://github.com/zgohr), creator of [Rarity Homestead](https://rarityhomestead.com/)
Homestead wrote the first draft of the masterwork dungeon and core library. This was a challenging task and Homestead delivered, contributing direction and insights in addition to code. Thank you friend!

### [RarityExtended](https://rarityextended.com/)
The Extended team kindly reviewed and gave feedback to masterwork. Masterwork has also borrowed some great ideas from their [Rarity Extended Lib](https://github.com/Rarity-Extended/rarity_extended_lib). Thank you friends!

### [CryptoShuraba](https://www.metaland.game/)
The Shuraba team also gave their time to a review of masterwork. In addtion, they generously granted the project 1300 MST. Thank you friends!
