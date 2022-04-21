![image](https://user-images.githubusercontent.com/89237203/163974182-7e80fbf2-eb98-4c86-b903-2e33a8c1a195.png)

# Rarity Masterwork
Masterwork is a new crafting level for Rarity players and builders. Like Rarity's first crafting level, masterwork contains a crafting station and a dungeon. Use the masterwork crafting station to create masterwork weapons, armor, and tools. Defeat monsters in the dungeon for loot that enhances your bonus at the crafting station.

Masterwork is an expansion of the original Rarity core created by Andre Cronje, et al in September 2021. It continues the core vision of a free-to-mint, permissionless, d20 implementation in solidity.

### So what?
Masterwork weapons and armor are exceptional. They are made so well that you get a bonus when using them. Masterwork weapons make you more accurate, granting a +1 bonus on all attacks. That is, you get a 10% better chance of hitting an Armor Class of 10, 5% better odds against AC 20, and so on. Masterwork armor fits you perfectly, granting a +1 armor check bonus. This gives you better odds whenever your movement is in check, such as sneaking up on an opponent or climbing out of a trap.

✨🧙‍♂️✨ - Masterwork crafting is also the basis for magic weapons and armor. Magic weapons and armor grant even more bonuses such as extra damage and improved armor class. A Magic Crafting expansion to Rarity core is in the works.

### Now what?
This git repo contains all the dev tooling used to build and test Masterwork. Use it as a reference for integrating masterwork with your projects! 


1. [Getting started](#getting-started)
2. [Rarity Crafting 2 - Masterwork Weapons, Armor, and Tools](#rarity-crafting-2---masterwork-weapons-armor-and-tools)
3. [Rarity Adventure 2 - Monsters in the Barn](#rarity-adventure-2---monsters-in-the-barn)
4. [Rarity Core Library](#rarity-core-library)
5. [How to use masterwork items in your game](#how-to-use-masterwork-items-in-your-game)
6. [More package commands](#more-package-commands)
7. [hardhat.config.ts customizations](#hardhatconfigts-customizations)
8. [Default hardhat commands](#default-hardhat-commands)
9. [Thank You 👹🙏](#thank-you-)


## Getting started
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
Masterwork's crafting and dungeon mechanics are complex. To manage these features we started a [solidity library](https://github.com/murderteeth/rarity-masterwork/tree/main/contracts/library) to abstract everything a builder need to create their own d20 adventures.

### Summoners
### Effects
### Rolls
### Combat
### The Combatant struct
### Etc


## How to use masterwork items in your game


## More package commands
```shell
yarn test
yarn test-fast
yarn report-gas
yarn random-uint265
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
