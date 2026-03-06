# ROHEN KINGDOM
### Dungeon of the Shadow Monarch
**68000 Assembly Language — Alternative Physics Text Adventure**

> *In this world, physics works differently. The smaller the warrior, the greater their strength. Concentrated mass. Impossible force.*

---

**Student:** Oleksandr Storozhuk  
**ID:** C00313344  
**Date:** 05/03/2026  
**Module:** Assembly Language Programming  
**Theme:** Games Fleadh — Alternative Physics

---

## What is this game?

A seven-chapter text-based dungeon crawler written entirely in 68000 assembly and run in Easy68k. You join the Asterix Guild on a routine scouting mission that turns out to be a trap set by the Shadow Monarch — an ancient ruler looking for a worthy successor. Every fight and every choice determines whether you take the throne or become another shadow.

---

## How to run

1. Open **Easy68k**
2. File → Open → `ROHEN_KINGDOM.x68`
3. Assemble (F2)
4. Run (F5)

---

## Gameplay

### Character select
Choose your warrior at the start:

| Warrior | HP | Bonus |
|---|---|---|
| Mini Knight | 100 | +2 attack every roll |
| Tiny Explorer | 80 | Enemy attacks reduced by 2 |

Then choose your weapon:

| Weapon | Attack | Defence |
|---|---|---|
| Iron Sword | +3 | none |
| Oak Shield | none | -5 incoming |
| Sword + Shield | +1 | -2 incoming |

### Combat
Each turn you pick from the action menu:
- `1` — Attack (random roll 1–10 + your bonuses vs enemy defence)
- `2` — Use potion (+20 HP, capped at your max)
- `3` — Flee (50/50 chance; fail means the enemy gets a free hit)
- `4` — Use Blacksteel Sword (only appears when you have it — 50 damage, ignores all defence, one use only)

The battle HUD shows your HP, enemy HP, and potions remaining before every turn.

---

## The Seven Chapters

| Chapter | Enemy | HP | Notes |
|---|---|---|---|
| 1 — Dungeon Guardian | Stone guardian | 20 | Tutorial fight. 3 potions. |
| 2 — Blacksteel Warden | Iron warden | 25 | Win to get 9 potions + Blacksteel Sword |
| 3 — Thieves | Eight thieves | 40 | **Choice: fight or give gold** |
| 4 — Lord of Life | Vine creature | 50 | Use Blacksteel Sword here |
| 5 — The Merchant | (no fight) | — | **Choice: keep or trade your Amulet** |
| 6 — The Reaper | Cloaked figure | 66 | Hard fight. Win to get Reaper's Scythe |
| 7 — Shadow Monarch | The Monarch | 60 | Final boss. Scythe gives +5 attack |

---

## The Choices That Matter

### Chapter 3 — Thieves in the Dark
Eight thieves surround you and demand the gold.

- **Fight them (1):** You win the fight, but the Blacksteel Sword shatters in the process. You will not be able to defeat the Lord of Life in Chapter 4 without it.
- **Give them the gold (2):** You lose the gold but keep the Blacksteel Sword. This is the correct path.

### Chapter 5 — The Merchant
A merchant offers a sword and potions in exchange for your Amulet.

- **Accept the trade (1):** You lose the Amulet permanently. The true ending becomes unreachable.
- **Decline (2):** You keep the Amulet. It will save your life at the very end.

---

## Endings

**True Ending (WIN)**  
Keep the Amulet through to Chapter 7. After defeating the Shadow Monarch, the Reaper's curse kills you — but the Amulet revives you. The Monarch kneels and names you his successor. You become the new Shadow Monarch.

**Bad Ending**  
Trade the Amulet in Chapter 5. The curse at the end of Chapter 7 kills you permanently. You join the shadows.

**Death in combat**  
HP reaches 0 in any fight. A specific message appears if you die in Chapter 4 without the Blacksteel Sword, explaining what went wrong.

---

## Memory Map

| Address | Name | Purpose |
|---|---|---|
| $4000 | HP | Player health |
| $4001 | WARRIOR | 1 = Knight, 2 = Explorer |
| $4002 | WEAPON | 1 = Sword, 2 = Shield, 3 = Both |
| $4003 | POTIONS | Potions remaining |
| $4004 | STAGE | Current chapter (1–7) |
| $4005 | ALIVE | 1 = alive, 0 = dead |
| $4006 | ENEMY_HP | Enemy health in combat |
| $4007 | ENEMY_ATK | Enemy attack value |
| $4008 | ENEMY_DEF | Enemy defence value |
| $4009 | BLACKSTEEL | 1 = held, 0 = used/lost |
| $400A | AMULET | 1 = held, 0 = traded |
| $400B | GOLD | 1 = held, 0 = spent |
| $400C | SCYTHE | 1 = held (after Ch.6, +5 attack) |
| $400E | SWORD_USES | Starting weapon durability (99) |

---

## Known issues

- The Chapter 4 intro text shows HP 70 / ATK 9 / DEF 5 but the actual enemy values are HP 50 / ATK 6 / DEF 2. Does not affect gameplay.
- `TURN_BOOST` ($400D) is defined in the memory map but not used in the final build.
