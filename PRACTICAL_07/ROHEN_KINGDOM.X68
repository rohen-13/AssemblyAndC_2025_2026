*-------------------------------------------------------
* Name:        OLEKSANDR STOROZHUK
* Student ID:  C00313344
* Date:        05/03/2026
*
* ASTERIX GUILD - DUNGEON OF THE SHADOW MONARCH
* Alternative Physics Text Adventure - 68000 Assembly
*
* DESCRIPTION:
*   You join the Asterix Guild and enter a dungeon that
*   turns out to be the Shadow Monarch's trap. Seven stages
*   of combat and choices lead to one of two endings.
*-------------------------------------------------------

* ===== WARRIOR CONSTANTS =====
WARRIOR_KNIGHT      EQU 1
WARRIOR_EXPLORER    EQU 2

* ===== WEAPON CONSTANTS =====
WEAPON_SWORD        EQU 1
WEAPON_SHIELD       EQU 2
WEAPON_BOTH         EQU 3

* ===== PLAYER STATS =====
KNIGHT_HP           EQU 100
EXPLORER_HP         EQU 80
HP_PHASE2           EQU 100
START_POTIONS       EQU 3
SWORD_MAX_USES      EQU 99          ; Sword never breaks
HEAL_AMOUNT         EQU 20
HP_CAP              EQU 100

* ===== COMBAT BONUSES =====
KNIGHT_ATK_BONUS    EQU 2
EXPLORER_DEF_REDUCE EQU 2
SWORD_ATK_BONUS     EQU 3
SHIELD_DMG_REDUCE   EQU 5
BOTH_ATK_BONUS      EQU 1
BOTH_DMG_REDUCE     EQU 2
BLACKSTEEL_DMG      EQU 50
BOOST_AMOUNT        EQU 4

* ===== ENEMY STATS =====
B1_HP   EQU 20      ; Boss 1 - very easy tutorial
B1_ATK  EQU 3
B1_DEF  EQU 1

B2_HP   EQU 25      ; Boss 2 - easy, you have 3 potions
B2_ATK  EQU 5
B2_DEF  EQU 2

T_HP    EQU 40      ; Stage 3 thieves (bad choice fight)
T_ATK   EQU 8
T_DEF   EQU 3

B3_HP   EQU 50      ; Boss 3 - needs blacksteel to win 
B3_ATK  EQU 6
B3_DEF  EQU 2

B4_HP   EQU 66      ; Boss 4 - hard, use your potions
B4_ATK  EQU 6
B4_DEF  EQU 2

SM_HP   EQU 60      ; Shadow Monarch - final boss
SM_ATK  EQU 12
SM_DEF  EQU 5

* ===== MEMORY MAP =====
HP          EQU $4000   ; Player HP
WARRIOR     EQU $4001   ; 1=Knight 2=Explorer
WEAPON      EQU $4002   ; 1=Sword 2=Shield 3=Both
POTIONS     EQU $4003   ; Potions remaining
STAGE       EQU $4004   ; Current stage 1-7
ALIVE       EQU $4005   ; 1=alive 0=dead
ENEMY_HP    EQU $4006   ; Enemy HP in combat
ENEMY_ATK   EQU $4007   ; Enemy attack power
ENEMY_DEF   EQU $4008   ; Enemy defence
BLACKSTEEL  EQU $4009   ; 1=have it 0=gone
AMULET      EQU $400A   ; 1=have it 0=traded
GOLD        EQU $400B   ; 1=have it 0=gave away
SCYTHE      EQU $400C   ; 1=have it 0=not yet
TURN_BOOST  EQU $400D   ; 1=boost active
SWORD_USES  EQU $400E   ; Uses left on sword

*=======================================================
    ORG $1000

*=======================================================
* START - Initialise memory then run game
*=======================================================
START:
    MOVEA.L #$4000,A3           ; A3 = permanent HP pointer

    MOVE.B  #100,D0
    MOVE.B  D0,(A3)             ; HP = 100 (set properly after warrior pick)
    CLR.B   $4001               ; WARRIOR = 0
    CLR.B   $4002               ; WEAPON = 0
    MOVE.B  #START_POTIONS,D0
    MOVE.B  D0,$4003            ; POTIONS = 3
    MOVE.B  #1,D0
    MOVE.B  D0,$4004            ; STAGE = 1
    MOVE.B  D0,$4005            ; ALIVE = 1
    CLR.B   $4006               ; ENEMY_HP = 0
    CLR.B   $4007               ; ENEMY_ATK = 0
    CLR.B   $4008               ; ENEMY_DEF = 0
    CLR.B   $4009               ; BLACKSTEEL = 0
    CLR.B   $400A               ; AMULET = 0
    MOVE.B  #1,D0
    MOVE.B  D0,$400B            ; GOLD = 1
    CLR.B   $400C               ; SCYTHE = 0
    CLR.B   $400D               ; TURN_BOOST = 0
    MOVE.B  #SWORD_MAX_USES,D0
    MOVE.B  D0,$400E            ; SWORD_USES = 99

    BSR     SHOW_LOGO
    BSR     SHOW_INTRO
    BSR     SHOW_WARNING
    BSR     PICK_WARRIOR
    BSR     PICK_WEAPON
    BSR     CLEAR_SCREEN
    BSR     STAGE_ROUTER
    SIMHALT

*=======================================================
* STAGE_ROUTER - Jump to current stage
*=======================================================
STAGE_ROUTER:
    MOVE.B  STAGE,D4
    CMP.B   #1,D4
    BEQ     SR1
    CMP.B   #2,D4
    BEQ     SR2
    CMP.B   #3,D4
    BEQ     SR3
    CMP.B   #4,D4
    BEQ     SR4
    CMP.B   #5,D4
    BEQ     SR5
    CMP.B   #6,D4
    BEQ     SR6
    BRA     SR7
SR1:
    BSR     STAGE1
    RTS
SR2:
    BSR     STAGE2
    RTS
SR3:
    BSR     STAGE3
    RTS
SR4:
    BSR     STAGE4
    RTS
SR5:
    BSR     STAGE5
    RTS
SR6:
    BSR     STAGE6
    RTS
SR7:
    BSR     STAGE7
    RTS

*=======================================================
* ADVANCE_STAGE - Increment stage and continue
*=======================================================
ADVANCE_STAGE:
    MOVE.B  STAGE,D0
    ADDQ.B  #1,D0
    MOVE.B  D0,STAGE
    BSR     CLEAR_SCREEN
    BRA     STAGE_ROUTER

*=======================================================
* MAIN MENU SCREENS
*=======================================================
SHOW_LOGO:
    BSR     CLEAR_SCREEN
    LEA     LOGO_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS

SHOW_INTRO:
    BSR     CLEAR_SCREEN
    LEA     INTRO_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS

SHOW_WARNING:
    BSR     CLEAR_SCREEN
    LEA     WARNING_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS

*=======================================================
* PICK_WARRIOR
*=======================================================
PICK_WARRIOR:
    BSR     CLEAR_SCREEN
PW_LOOP:
    LEA     WARRIOR_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; D5 = save input NOW before any TRAP corrupts D1
    CMP.B   #1,D5
    BLT     PW_ERR
    CMP.B   #2,D5
    BGT     PW_ERR
    MOVE.B  D5,D0
    MOVE.B  D0,WARRIOR
    CMP.B   #WARRIOR_KNIGHT,D5
    BEQ     PW_KNIGHT
PW_EXPLORER:
    MOVE.B  #EXPLORER_HP,D0
    MOVE.B  D0,(A3)
    BSR     CLEAR_SCREEN
    LEA     EXPLORER_OK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS
PW_KNIGHT:
    MOVE.B  #KNIGHT_HP,D0
    MOVE.B  D0,(A3)
    BSR     CLEAR_SCREEN
    LEA     KNIGHT_OK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS
PW_ERR:
    BSR     CLEAR_SCREEN
    LEA     ERR_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     PW_LOOP

*=======================================================
* PICK_WEAPON
*=======================================================
PICK_WEAPON:
    BSR     CLEAR_SCREEN
PKW_LOOP:
    LEA     WEAPON_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; D5 = save input immediately
    CMP.B   #1,D5
    BLT     PKW_ERR
    CMP.B   #3,D5
    BGT     PKW_ERR
    MOVE.B  D5,D0
    MOVE.B  D0,WEAPON
    CMP.B   #WEAPON_SWORD,D5
    BEQ     PKW_SWORD
    CMP.B   #WEAPON_SHIELD,D5
    BEQ     PKW_SHIELD
PKW_BOTH:
    BSR     CLEAR_SCREEN
    LEA     BOTH_OK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS
PKW_SWORD:
    BSR     CLEAR_SCREEN
    LEA     SWORD_OK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS
PKW_SHIELD:
    BSR     CLEAR_SCREEN
    LEA     SHIELD_OK,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    RTS
PKW_ERR:
    BSR     CLEAR_SCREEN
    LEA     ERR_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     PKW_LOOP

*=======================================================
* STAGE 1 - DUNGEON GUARDIAN
*=======================================================
STAGE1:
    BSR     CLEAR_SCREEN
    LEA     S1_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    BSR     CLEAR_SCREEN
    LEA     S1_MSG2,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Load Boss 1
    MOVE.B  #B1_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #B1_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #B1_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP
    BSR     CHECK_ALIVE

    BSR     CLEAR_SCREEN
    LEA     S1_WIN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 2 - BLACKSTEEL WARDEN
*=======================================================
STAGE2:
    BSR     CLEAR_SCREEN
    LEA     S2_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Load Boss 2
    MOVE.B  #B2_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #B2_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #B2_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP
    BSR     CHECK_ALIVE

    * Victory - give rewards
    BSR     CLEAR_SCREEN
    LEA     S2_WIN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Give 9 potions and blacksteel sword
    MOVE.B  #9,D0
    MOVE.B  D0,POTIONS
    MOVE.B  #1,D0
    MOVE.B  D0,BLACKSTEEL

    BSR     CLEAR_SCREEN
    LEA     S2_REWARD,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 3 - THIEVES AMBUSH
*=======================================================
STAGE3:
    BSR     CLEAR_SCREEN
    LEA     S3_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

S3_CHOICE:
    BSR     CLEAR_SCREEN
    LEA     S3_CHOICE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; Save choice immediately
    CMP.B   #1,D5
    BEQ     S3_FIGHT
    CMP.B   #2,D5
    BEQ     S3_GIVE
    BSR     CLEAR_SCREEN
    LEA     ERR_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     S3_CHOICE

S3_FIGHT:
    * Wrong choice - fight thieves but lose blacksteel
    BSR     CLEAR_SCREEN
    LEA     S3_FIGHT_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    MOVE.B  #T_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #T_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #T_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP
    BSR     CHECK_ALIVE

    * Used/lost blacksteel in fight
    CLR.B   BLACKSTEEL
    CLR.B   GOLD

    BSR     CLEAR_SCREEN
    LEA     S3_FIGHT_AFTER,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    BRA     S3_DONE

S3_GIVE:
    * Correct choice - give gold, keep blacksteel
    CLR.B   GOLD
    BSR     CLEAR_SCREEN
    LEA     S3_GIVE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

S3_DONE:
    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 4 - LORD OF LIFE
*=======================================================
STAGE4:
    BSR     CLEAR_SCREEN
    LEA     S4_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Load Boss 3
    MOVE.B  #B3_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #B3_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #B3_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP_LORD
    BSR     CHECK_ALIVE

    * Victory - give amulet and increase max HP
    BSR     CLEAR_SCREEN
    LEA     S4_WIN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    MOVE.B  #1,D0
    MOVE.B  D0,AMULET
    MOVE.B  #HP_PHASE2,D0
    MOVE.B  D0,(A3)             ; HP now 200

    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 5 - THE MERCHANT
*=======================================================
STAGE5:
    BSR     CLEAR_SCREEN
    LEA     S5_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

S5_CHOICE:
    BSR     CLEAR_SCREEN
    LEA     S5_CHOICE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; Save choice immediately
    CMP.B   #1,D5
    BEQ     S5_TRADE
    CMP.B   #2,D5
    BEQ     S5_KEEP
    BSR     CLEAR_SCREEN
    LEA     ERR_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     S5_CHOICE

S5_TRADE:
    CLR.B   AMULET
    BSR     CLEAR_SCREEN
    LEA     S5_TRADE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    BRA     S5_DONE

S5_KEEP:
    BSR     CLEAR_SCREEN
    LEA     S5_KEEP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

S5_DONE:
    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 6 - THE REAPER
*=======================================================
STAGE6:
    BSR     CLEAR_SCREEN
    LEA     S6_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Load Boss 4
    MOVE.B  #B4_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #B4_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #B4_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP
    BSR     CHECK_ALIVE

    BSR     CLEAR_SCREEN
    LEA     S6_WIN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    MOVE.B  #1,D0
    MOVE.B  D0,SCYTHE

    BSR     ADVANCE_STAGE
    RTS

*=======================================================
* STAGE 7 - SHADOW MONARCH
*=======================================================
STAGE7:
    BSR     CLEAR_SCREEN
    LEA     S7_MSG1,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    BSR     CLEAR_SCREEN
    LEA     S7_MSG2,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Shadow loop - fight 4 respawning shadows
    MOVE.B  #B1_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #B1_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #B1_DEF,D0
    MOVE.B  D0,ENEMY_DEF
    BSR     FIGHT_LOOP
    BSR     CHECK_ALIVE

    BSR     CLEAR_SCREEN
    LEA     S7_SHADOW_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Escape to cave - plan sneak attack
    BSR     CLEAR_SCREEN
    LEA     S7_CAVE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Sneak attack - fight monarch
    BSR     CLEAR_SCREEN
    LEA     S7_SNEAK_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Load Shadow Monarch
    MOVE.B  #SM_HP,D0
    MOVE.B  D0,ENEMY_HP
    MOVE.B  #SM_ATK,D0
    MOVE.B  D0,ENEMY_ATK
    MOVE.B  #SM_DEF,D0
    MOVE.B  D0,ENEMY_DEF

    BSR     FIGHT_LOOP
    * Player will die from curse - check amulet

    * Curse kills player
    BSR     CLEAR_SCREEN
    LEA     S7_CURSE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY

    * Check amulet for revive
    CMP.B   #1,AMULET
    BEQ     TRUE_END
    BRA     BAD_END

*=======================================================
* ENDINGS
*=======================================================
TRUE_END:
    BSR     CLEAR_SCREEN
    LEA     TRUE_END_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ANYKEY
    BSR     CLEAR_SCREEN
    LEA     TRUE_END2_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    SIMHALT

BAD_END:
    BSR     CLEAR_SCREEN
    LEA     BAD_END_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    SIMHALT

*=======================================================
* FIGHT_LOOP - Standard turn-based combat
*=======================================================
FIGHT_LOOP:
    BSR     SHOW_STATUS

    BSR     ACTION_MENU
    CMP.B   #0,ENEMY_HP
    BEQ     FIGHT_WIN

    BSR     ENEMY_ATTACKS
    CMP.B   #0,ALIVE
    BEQ     FIGHT_DEAD

    BRA     FIGHT_LOOP

FIGHT_WIN:
    BSR     ENDL
    LEA     ENEMY_DEAD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

FIGHT_DEAD:
    RTS

*=======================================================
* FIGHT_LOOP_LORD - Lord of Life special fight
* Blacksteel auto-triggers at HP <= 30
* Without blacksteel: Lord heals and fight is unwinnable
*=======================================================
FIGHT_LOOP_LORD:
    BSR     SHOW_STATUS

    * Check if no blacksteel - warn player
    CMP.B   #1,BLACKSTEEL
    BEQ     FLL_CONTINUE
    LEA     NO_BS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL

FLL_CONTINUE:
    BSR     ACTION_MENU

FLL_CHECK_WIN:
    CMP.B   #0,ENEMY_HP
    BEQ     FIGHT_WIN

    BSR     ENEMY_ATTACKS
    CMP.B   #0,ALIVE
    BEQ     FIGHT_DEAD

    BRA     FIGHT_LOOP_LORD

*=======================================================
* ACTION_MENU - Player chooses attack/potion/flee
*=======================================================
ACTION_MENU:
    BSR     ENDL
    * Show correct menu based on whether player has blacksteel
    CMP.B   #1,BLACKSTEEL
    BEQ     AM_SHOW_BS
    LEA     ACTION_MSG,A1       ; No blacksteel - 3 options only
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; Save input immediately
    CMP.B   #1,D5
    BEQ     AM_ATTACK
    CMP.B   #2,D5
    BEQ     AM_POTION
    CMP.B   #3,D5
    BEQ     AM_FLEE
    BRA     ACTION_MENU
AM_SHOW_BS:
    LEA     ACTION_MSG_BS,A1    ; Has blacksteel - 4 options
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    MOVE.B  D1,D5               ; Save input immediately
    CMP.B   #1,D5
    BEQ     AM_ATTACK
    CMP.B   #2,D5
    BEQ     AM_POTION
    CMP.B   #3,D5
    BEQ     AM_FLEE
    CMP.B   #4,D5
    BEQ     AM_BLACKSTEEL
    BRA     ACTION_MENU
AM_ATTACK:
    BSR     PLAYER_ATTACKS
    RTS
AM_POTION:
    BSR     USE_POTION
    RTS
AM_FLEE:
    BSR     ATTEMPT_FLEE
    RTS
AM_BLACKSTEEL:
    BSR     USE_BLACKSTEEL
    RTS

*=======================================================
* PLAYER_ATTACKS
* Roll 1-10, apply bonuses, compare vs enemy defence
* Hit: damage = (roll+bonuses) - defence, min 1
* Miss: (roll+bonuses) <= defence
*=======================================================
PLAYER_ATTACKS:
    * Roll 1-10
    MOVE.B  #20,D0
    TRAP    #15
    MOVE.L  D1,D6
    AND.L   #$0000FFFF,D6
    DIVU    #10,D6
    SWAP    D6
    AND.L   #$0000FFFF,D6
    ADDQ.B  #1,D6
    MOVE.B  D6,D4               ; D4 = base roll

    * Knight bonus
    MOVE.B  WARRIOR,D1
    CMP.B   #WARRIOR_KNIGHT,D1
    BNE     PA_NOT_KNIGHT
    ADD.B   #KNIGHT_ATK_BONUS,D4
PA_NOT_KNIGHT:

    * Weapon bonus
    MOVE.B  WEAPON,D1
    CMP.B   #WEAPON_SWORD,D1
    BEQ     PA_SWORD
    CMP.B   #WEAPON_BOTH,D1
    BEQ     PA_BOTH
    BRA     PA_DEFENCE

PA_SWORD:
    CMP.B   #0,SWORD_USES
    BEQ     PA_DEFENCE
    ADD.B   #SWORD_ATK_BONUS,D4
    MOVE.B  SWORD_USES,D1
    SUBQ.B  #1,D1
    MOVE.B  D1,SWORD_USES
    BRA     PA_DEFENCE

PA_BOTH:
    ADD.B   #BOTH_ATK_BONUS,D4

PA_DEFENCE:
    MOVE.B  ENEMY_DEF,D3
    * Explorer reduces enemy defence
    MOVE.B  WARRIOR,D1
    CMP.B   #WARRIOR_EXPLORER,D1
    BNE     PA_NO_EXPLORER
    SUB.B   #EXPLORER_DEF_REDUCE,D3
PA_NO_EXPLORER:
    * Scythe bonus
    CMP.B   #1,SCYTHE
    BNE     PA_COMPARE
    ADD.B   #5,D4

PA_COMPARE:
    CMP.B   D3,D4
    BHI     PA_HIT
    LEA     MISS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

PA_HIT:
    MOVE.B  D4,D1
    SUB.B   D3,D1               ; damage = attack - defence
    CMP.B   #1,D1
    BGE     PA_DEAL
    MOVE.B  #1,D1
PA_DEAL:
    MOVE.B  D1,D4               ; D4 = final damage
    LEA     HIT_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    MOVE.B  ENEMY_HP,D1
    SUB.B   D4,D1
    BLE     PA_KILL
    MOVE.B  D1,ENEMY_HP
    RTS
PA_KILL:
    CLR.B   ENEMY_HP
    RTS

*=======================================================
* ENEMY_ATTACKS
*=======================================================
ENEMY_ATTACKS:
    BSR     ENDL
    LEA     ENEMY_ATK_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    * Roll 1-10
    MOVE.B  #20,D0
    TRAP    #15
    MOVE.L  D1,D6
    AND.L   #$0000FFFF,D6
    DIVU    #10,D6
    SWAP    D6
    AND.L   #$0000FFFF,D6
    ADDQ.B  #1,D6
    MOVE.B  D6,D4
    ADD.B   ENEMY_ATK,D4        ; D4 = roll + enemy ATK

    * Explorer reduces enemy attack
    MOVE.B  WARRIOR,D1
    CMP.B   #WARRIOR_EXPLORER,D1
    BNE     EA_NO_EXPLORER
    SUB.B   #EXPLORER_DEF_REDUCE,D4
EA_NO_EXPLORER:

    * Shield reduction
    MOVE.B  WEAPON,D1
    CMP.B   #WEAPON_SHIELD,D1
    BEQ     EA_SHIELD
    CMP.B   #WEAPON_BOTH,D1
    BEQ     EA_BOTH
    BRA     EA_APPLY

EA_SHIELD:
    SUB.B   #SHIELD_DMG_REDUCE,D4
    CMP.B   #1,D4
    BGE     EA_SHIELD_OK
    MOVE.B  #1,D4
EA_SHIELD_OK:
    BRA     EA_APPLY

EA_BOTH:
    SUB.B   #BOTH_DMG_REDUCE,D4
    CMP.B   #1,D4
    BGE     EA_APPLY
    MOVE.B  #1,D4

EA_APPLY:
    LEA     ENEMY_HIT_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL

    MOVE.B  (A3),D1
    SUB.B   D4,D1
    BLE     EA_DEAD
    MOVE.B  D1,(A3)
    RTS

EA_DEAD:
    CLR.B   (A3)
    CLR.B   ALIVE
    RTS

*=======================================================
* USE_POTION
*=======================================================
USE_POTION:
    CMP.B   #0,POTIONS
    BNE     UP_OK
    LEA     NO_POTIONS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS
UP_OK:
    CLR.W   D1
    MOVE.B  (A3),D1             ; zero-extend HP into word
    ADD.W   #HEAL_AMOUNT,D1     ; add heal as word - no byte overflow
    CMP.W   #HP_CAP,D1          ; compare as word - 100 fits fine
    BLE     UP_STORE
    MOVE.W  #HP_CAP,D1
UP_STORE:
    MOVE.B  D1,(A3)             ; store low byte back
    MOVE.B  POTIONS,D1
    SUBQ.B  #1,D1
    MOVE.B  D1,POTIONS
    LEA     HEAL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

*=======================================================
* ATTEMPT_FLEE - 50/50 chance
*=======================================================
ATTEMPT_FLEE:
    LEA     FLEE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    MOVE.B  #20,D0
    TRAP    #15
    AND.B   #1,D1
    BEQ     FLEE_FAIL
    LEA     FLEE_OK_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    * Force enemy HP to 0 to exit fight loop
    CLR.B   ENEMY_HP
    RTS
FLEE_FAIL:
    LEA     FLEE_FAIL_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    BSR     ENEMY_ATTACKS
    RTS

*=======================================================
* USE_BLACKSTEEL - Player chooses to use the sword
*=======================================================
USE_BLACKSTEEL:
    * Check if player has it
    CMP.B   #1,BLACKSTEEL
    BEQ     UB_HAVE
    LEA     NO_BS_ITEM_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

UB_HAVE:
    * Deal 50 damage ignoring all defence
    LEA     BS_TRIGGER_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    CLR.B   BLACKSTEEL          ; Used up - gone
    MOVE.B  ENEMY_HP,D1
    CMP.B   #BLACKSTEEL_DMG,D1
    BLE     UB_KILL
    SUB.B   #BLACKSTEEL_DMG,D1
    MOVE.B  D1,ENEMY_HP
    RTS
UB_KILL:
    CLR.B   ENEMY_HP
    RTS

*=======================================================
* SHOW_STATUS - HUD during combat
*=======================================================
SHOW_STATUS:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     STATUS_HDR,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL

    LEA     YOUR_HP_LBL,A1
    MOVE.B  #14,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  (A3),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL

    LEA     ENEMY_HP_LBL,A1
    MOVE.B  #14,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  ENEMY_HP,D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL

    LEA     POTIONS_LBL,A1
    MOVE.B  #14,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  POTIONS,D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     ENDL

    BSR     ENDL
    RTS

*=======================================================
* CHECK_ALIVE - Go to game over if dead
*=======================================================
CHECK_ALIVE:
    CMP.B   #0,ALIVE
    BNE     CA_OK
    BSR     GAME_OVER
CA_OK:
    RTS

*=======================================================
* GAME_OVER
*=======================================================
GAME_OVER:
    BSR     CLEAR_SCREEN
    LEA     DEAD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.B  STAGE,D1
    CMP.B   #4,D1
    BNE     GO_GENERIC
    CMP.B   #0,BLACKSTEEL
    BNE     GO_GENERIC
    LEA     NO_BS_DEAD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    SIMHALT

GO_GENERIC:
    LEA     GENERIC_DEAD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    SIMHALT

*=======================================================
* UTILITIES
*=======================================================
ANYKEY:
    BSR     ENDL
    LEA     ANYKEY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #5,D0               ; Read single char - silent, no echo
    TRAP    #15
    RTS

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE.B  #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS

CLEAR_SCREEN:
    MOVE.B  #11,D0
    MOVE.L  #$FF00,D1
    TRAP    #15
    RTS

*=======================================================
* DATA SECTION
*=======================================================

CRLF:       DC.B $0D,$0A,0
ANYKEY_MSG: DC.B '[ Press any key to continue... ]',0
ERR_MSG:    DC.B 'Invalid input. Try again: ',0

* ===== MAIN MENU =====
LOGO_MSG:
        DC.B '               __                  __   _                 __              ',13,10
        DC.B '   _________  / /_  ___  ____     / /__(_)___  ____ _____/ /___  ____ ___ ',13,10
        DC.B '  / ___/ __ \/ __ \/ _ \/ __ \   / //_/ / __ \/ __ `/ __  / __ \/ __ `__ \',13,10
        DC.B ' / /  / /_/ / / / /  __/ / / /  / ,< / / / / / /_/ / /_/ / /_/ / / / / / /',13,10
        DC.B '/_/   \____/_/ /_/\___/_/ /_/  /_/|_/_/_/ /_/\__, /\__,_/\____/_/ /_/ /_/ ',13,10
        DC.B '                                            /____/                        ',13,10
        DC.B 0



INTRO_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '  DUNGEON OF THE SHADOW MONARCH',$0D,$0A
    DC.B '  Alternative Physics Text Adventure',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  In this world, physics works differently.',$0D,$0A
    DC.B '  The smaller the warrior, the greater their strength.',$0D,$0A
    DC.B '  Concentrated mass. Impossible force.',0

WARNING_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '  !! YOUR CHOICES MATTER !!',$0D,$0A
    DC.B '',$0D,$0A
    DC.B '  Some doors, once closed, never reopen.',$0D,$0A
    DC.B '============================================================',0

* ===== WARRIOR SELECT =====
WARRIOR_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHOOSE YOUR WARRIOR',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  1.  MINI KNIGHT',$0D,$0A
    DC.B '      HP: 100   Attack bonus: +2 every roll',$0D,$0A
    DC.B $0D,$0A
    DC.B '  2.  TINY EXPLORER',$0D,$0A
    DC.B '      HP: 80    Enemy attack reduced by 2',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Enter 1 or 2: ',0

KNIGHT_OK:
    DC.B '  >> MINI KNIGHT selected.',$0D,$0A
    DC.B '     100 HP. Your rolls get +2 attack every turn.',0

EXPLORER_OK:
    DC.B '  >> TINY EXPLORER selected.',$0D,$0A
    DC.B '     80 HP. Enemy attacks are reduced by 2 every turn.',0

* ===== WEAPON SELECT =====
WEAPON_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHOOSE YOUR WEAPON',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  1.  IRON SWORD     Attack +3,  no defence bonus',$0D,$0A
    DC.B '  2.  OAK SHIELD     No attack,  incoming damage -5',$0D,$0A
    DC.B '  3.  SWORD+SHIELD   Attack +1,  incoming damage -2',$0D,$0A
    DC.B $0D,$0A
    DC.B '  All weapons last the whole game. None break.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Enter 1, 2 or 3: ',0

SWORD_OK:
    DC.B '  >> IRON SWORD equipped. +3 attack every roll.',0

SHIELD_OK:
    DC.B '  >> OAK SHIELD equipped. Incoming damage -5 every hit.',0

BOTH_OK:
    DC.B '  >> SWORD AND SHIELD equipped. Balanced attack and defence.',0

* ===== STAGE 1 =====
S1_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 1: THE DUNGEON GUARDIAN',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The guild sent you to explore the Sunken Dungeon.',$0D,$0A
    DC.B '  It was supposed to be empty. A simple first job.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The dungeon has no monsters. No traps.',$0D,$0A
    DC.B '  Something cleared them all out. Recently.',0

S1_MSG2:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  BOSS 1: DUNGEON GUARDIAN',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  A stone figure in ancient armour blocks your path.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "You may pass if you can make me fall."',$0D,$0A
    DC.B '  "None have. But you may try."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 20   ATK: 3   DEF: 1 ]',$0D,$0A
    DC.B '  You have 3 potions. This is an easy fight.',0

S1_WIN:
    DC.B '  >> GUARDIAN DEFEATED',$0D,$0A
    DC.B $0D,$0A
    DC.B '  He laughs. "Not bad."',$0D,$0A
    DC.B '  He slides a better sword across the floor.',$0D,$0A
    DC.B '  You take it and press on.',0

* ===== STAGE 2 =====
S2_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 2: THE BLACKSTEEL WARDEN',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Black iron walls. The air smells like a forge.',$0D,$0A
    DC.B '  A figure twice your height blocks the corridor.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "The chest was a test. You passed it."',$0D,$0A
    DC.B '  "Now pass me."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 25   ATK: 5   DEF: 2 ]',$0D,$0A
    DC.B '  Use a potion if your HP gets low.',0

S2_WIN:
    DC.B '  >> BLACKSTEEL WARDEN DEFEATED',$0D,$0A
    DC.B $0D,$0A
    DC.B '  A crate of healing potions at your feet.',$0D,$0A
    DC.B '  And a sword. Blacksteel. It hums when you touch it.',0

S2_REWARD:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  ITEMS RECEIVED',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  + 9 HEALING POTIONS',$0D,$0A
    DC.B '  + BLACKSTEEL SWORD (press 4 in battle to use it)',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The Blacksteel Sword deals 50 damage, ignores defence.',$0D,$0A
    DC.B '  One use only. It is destroyed after use.',0

* ===== STAGE 3 =====
S3_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 3: THIEVES IN THE DARK',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The torches go out. Figures drop from above.',$0D,$0A
    DC.B '  Eight of them. Knives at your throat.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "Simple deal. Give us the gold from the chest."',$0D,$0A
    DC.B '  "You keep your life and whatever else you carry."',0

S3_CHOICE_MSG:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  WHAT DO YOU DO?',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  1.  Fight them',$0D,$0A
    DC.B '      You win, but the Blacksteel sword is destroyed.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  2.  Give them the gold',$0D,$0A
    DC.B '      You keep the Blacksteel sword.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Enter 1 or 2: ',0

S3_FIGHT_MSG:
    DC.B '  You draw the Blacksteel sword. It blazes.',$0D,$0A
    DC.B '  The thieves charge.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 40   ATK: 8   DEF: 3 ]',0

S3_FIGHT_AFTER:
    DC.B '  The Blacksteel sword shattered in the fight.',$0D,$0A
    DC.B '  The gold scattered. You press on.',0

S3_GIVE_MSG:
    DC.B '  You drop the gold. They take it and vanish.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You still have the Blacksteel sword.',0

* ===== STAGE 4 =====
S4_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 4: LORD OF LIFE',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Green walls. Plants through the stone. Warm air.',$0D,$0A
    DC.B '  A figure of vines and bone stands at the centre.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "Life does not give passage freely."',$0D,$0A
    DC.B '  "Take it from me."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 70   ATK: 9   DEF: 5 ]',$0D,$0A
    DC.B '  HINT: Press 4 to use your Blacksteel Sword (50 dmg).',0

S4_WIN:
    DC.B '  >> LORD OF LIFE DEFEATED',$0D,$0A
    DC.B $0D,$0A
    DC.B '  An amulet falls from his chest. Warm metal.',$0D,$0A
    DC.B '  The moment you hold it, wounds close.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  + AMULET OF LIFE received. HP restored to full.',0

* ===== STAGE 5 =====
S5_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 5: THE MERCHANT',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  A merchant. In a dungeon. Sitting at a folding table.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "I will trade you a fine sword and potions..."',$0D,$0A
    DC.B '  "...for that amulet you are carrying."',$0D,$0A
    DC.B '  "Funny little thing. Probably useless."',0

S5_CHOICE_MSG:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  THE MERCHANT OFFERS',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  He wants your AMULET in exchange for a sword + potions.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  1.  Accept the trade (you lose the amulet FOREVER)',$0D,$0A
    DC.B '  2.  Decline and keep the amulet',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Enter 1 or 2: ',0

S5_TRADE_MSG:
    DC.B '  You hand over the amulet. He takes it quickly.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Something feels wrong. You cannot say what.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  - AMULET lost.',0

S5_KEEP_MSG:
    DC.B '  "No deal."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The merchant shrugs and disappears into the dark.',$0D,$0A
    DC.B '  You keep the amulet. Good.',0

* ===== STAGE 6 =====
S6_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 6: THE REAPER',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Cold. Not the cold of stone. The cold of absence.',$0D,$0A
    DC.B '  A shape in a cloak raises a scythe.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 55   ATK: 9   DEF: 4 ]',$0D,$0A
    DC.B '  This is a hard fight. Use your potions freely.',0

S6_WIN:
    DC.B '  >> THE REAPER FALLS',$0D,$0A
    DC.B $0D,$0A
    DC.B '  It dissolves. Its scythe clatters to the floor.',$0D,$0A
    DC.B '  You pick it up.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  + REAPER''S SCYTHE received.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Then the curse hits. Cold spreading from your chest.',$0D,$0A
    DC.B '  The dungeon is draining you. Move. Now.',0

* ===== STAGE 7 =====
S7_MSG1:
    DC.B '============================================================',$0D,$0A
    DC.B '  CHAPTER 7: THE SHADOW MONARCH',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  A throne room. On a black iron throne, a figure.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "You made it. I watched you from the first level."',$0D,$0A
    DC.B '  "I cleared the dungeon so you could reach me."',$0D,$0A
    DC.B '  "All of this was a test."',0

S7_MSG2:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  THE SHADOWS RETURN',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  Four shapes pull from the dark:',$0D,$0A
    DC.B '  The Guardian. The Warden. Lord of Life. The Reaper.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "Every soul that falls here serves me now."',$0D,$0A
    DC.B '  "Let us see how long you survive."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You fight. You win. They come back. Over and over.',0

S7_SHADOW_MSG:
    DC.B '  You cannot win by fighting the shadows.',$0D,$0A
    DC.B '  Every one you kill comes back.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The Monarch sits still on his throne.',$0D,$0A
    DC.B '  Not even watching you.',0

S7_CAVE_MSG:
    DC.B '  You break away and find a crack in the wall.',$0D,$0A
    DC.B '  The curse is running. Minutes left.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The Monarch watches his shadows. Not the room.',$0D,$0A
    DC.B '  There is a corridor behind the throne.',0

S7_SNEAK_MSG:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  THE SNEAK ATTACK',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You move behind the throne. Slow. Silent.',$0D,$0A
    DC.B '  You raise the Scythe and swing with everything.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "That... actually hurt."',$0D,$0A
    DC.B '  "No one has done that in three hundred years."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The shadows all stop.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  [ HP: 60   ATK: 12   DEF: 5 ]  -- FINAL BOSS',0

S7_CURSE_MSG:
    DC.B '  "The curse will finish you in minutes."',$0D,$0A
    DC.B '  "I will just watch."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The cold reaches your chest. Your heart.',$0D,$0A
    DC.B '  You fall.',0

* ===== ENDINGS =====
TRUE_END_MSG:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  THE AMULET AWAKENS',$0D,$0A
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The amulet glows. Warm. Then blinding.',$0D,$0A
    DC.B '  The curse shatters. Wounds close.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You stand up. You should be dead. You are not.',0

TRUE_END2_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '                    ** YOU WIN **',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The Monarch kneels.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  "I have waited three hundred years for someone worthy."',$0D,$0A
    DC.B '  "This dungeon. These shadows. This throne."',$0D,$0A
    DC.B '  "They are yours now."',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You walk to the throne. You sit down.',$0D,$0A
    DC.B '  You are the Shadow Monarch now.',0

BAD_END_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '                  ** YOU HAVE FALLEN **',$0D,$0A
    DC.B '============================================================',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The amulet that could have saved you is gone.',$0D,$0A
    DC.B '  You traded it away in Chapter 5.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  The dungeon claims you. You join the shadows.',0

* ===== GAME OVER =====
DEAD_MSG:
    DC.B '============================================================',$0D,$0A
    DC.B '                  ** YOU HAVE FALLEN **',$0D,$0A
    DC.B '============================================================',$0D,$0A,0

NO_BS_DEAD_MSG:
    DC.B '  The Lord of Life healed himself every time.',$0D,$0A
    DC.B '  You needed the Blacksteel Sword to win.',$0D,$0A
    DC.B $0D,$0A
    DC.B '  You used it on the thieves in Chapter 3.',$0D,$0A
    DC.B '  Try again. In Chapter 3: choose option 2.',0

GENERIC_DEAD_MSG:
    DC.B '  The dungeon claims another adventurer.',0

* ===== COMBAT MESSAGES =====
ENEMY_DEAD_MSG: DC.B '  >> ENEMY DEFEATED!',0
STATUS_HDR:     DC.B '----[ BATTLE ]----------------------------------------------',0
YOUR_HP_LBL:    DC.B '  Your HP   : ',0
ENEMY_HP_LBL:   DC.B '  Enemy HP  : ',0
POTIONS_LBL:    DC.B '  Potions   : ',0

ACTION_MSG:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  1=ATTACK   2=POTION (+20hp)   3=FLEE',$0D,$0A
    DC.B '  Choose: ',0

ACTION_MSG_BS:
    DC.B '------------------------------------------------------------',$0D,$0A
    DC.B '  1=ATTACK   2=POTION (+20hp)   3=FLEE   4=BLACKSTEEL',$0D,$0A
    DC.B '  Choose: ',0

HIT_MSG:    DC.B '  >> HIT!',0
MISS_MSG:   DC.B '  >> MISS! Attack glances off.',0

ENEMY_ATK_MSG:      DC.B '  >> Enemy strikes!',0
ENEMY_HIT_MSG:      DC.B '  You take damage.',0

HEAL_MSG:           DC.B '  Potion used. HP +20.',0
NO_POTIONS_MSG:     DC.B '  No potions left!',0

FLEE_MSG:           DC.B '  Attempting to flee...',0
FLEE_OK_MSG:        DC.B '  You slip away into the dark.',0
FLEE_FAIL_MSG:      DC.B '  Escape failed! Enemy gets a free hit!',0

BS_TRIGGER_MSG:
    DC.B '  !! BLACKSTEEL SWORD STRIKES !!',$0D,$0A
    DC.B '  50 damage, ignores all defence.',$0D,$0A
    DC.B '  The sword shatters. One use only.',0

NO_BS_MSG:
    DC.B '  (No Blacksteel Sword - option 4 unavailable)',0

NO_BS_ITEM_MSG:
    DC.B '  You do not have the Blacksteel Sword.',0

    END START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
