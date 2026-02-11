*-----------------------------------------------------------
* Title      :  PRACTICAL_05
* Written by :  Oleksandr Storozhuk
* Date       :  09/02/2026
* Description:  PART 5
*-----------------------------------------------------------
        ORG     $1000

DAMAGE          EQU     10
HEALTH_BOOST    EQU     20

START:
        BRA     GAME_LOOP

GAME_LOOP:
        BSR     COUNT_ENEMIES
        MOVE.B  D0, D4

        LEA     MSG_GAMELOOP, A1
        BSR     DRAW

        BSR     UPDATE
        BRA     GAME_LOOP

UPDATE:
        MOVE.B  PLAYER_HEALTH, D1

        LEA     MSG_HEALTH, A1
        BSR     DRAW

        MOVE.B  #3, D0
        TRAP    #15

        LEA     CRLF, A1
        BSR     DRAW

        CMP     #0, D1
        BLE     GAME_OVER

        ADD.L   #1, PLAYER_X

        BSR     COLLISION
        BSR     CHECK_POWERUPS

        RTS

DRAW:
        MOVE.B  #13, D0
        TRAP    #15
        RTS

COLLISION:
        MOVE.B  #1, D5
        LEA     ENEMY_POSITIONS, A3

COLLISION_LOOP:
        CMP     D5, D4
        BEQ     END_COLLISION

        MOVE.L  (A3)+, D2
        MOVE.L  PLAYER_X, D3

        CMP.L   D2, D3
        BEQ     REDUCE_HEALTH

        ADD.B   #1, D5
        BRA     COLLISION_LOOP

END_COLLISION:
        RTS

REDUCE_HEALTH:
        LEA     MSG_COLLISION, A1
        BSR     DRAW

        SUB.B   #DAMAGE, PLAYER_HEALTH

        LEA     MSG_DAMAGE, A1
        BSR     DRAW

        BRA     GAME_LOOP

CHECK_POWERUPS:
        LEA     POWER_UPS, A4

POWER_LOOP:
        TST.L   (A4)
        BEQ     END_POWER

        MOVE.L  (A4)+, D2
        MOVE.L  PLAYER_X, D3

        CMP.L   D2, D3
        BEQ     GIVE_HEALTH

        BRA     POWER_LOOP

GIVE_HEALTH:
        ADD.B   #HEALTH_BOOST, PLAYER_HEALTH

        LEA     MSG_POWERUP, A1
        BSR     DRAW

END_POWER:
        RTS

GAME_OVER:
        LEA     MSG_GAMEOVER, A1
        BSR     DRAW
        SIMHALT

COUNT_ENEMIES:
        MOVE.B  #0, D0
        LEA     ENEMY_POSITIONS, A0

COUNT_LOOP:
        TST.L   (A0)+
        BEQ     END_COUNT
        ADD.B   #1, D0
        BRA     COUNT_LOOP

END_COUNT:
        RTS

PLAYER_X        DC.L    1
PLAYER_HEALTH   DC.B    100

MSG_HEALTH      DC.B    'Health : ',0
MSG_GAMELOOP    DC.B    'Game Loop',0
MSG_COLLISION   DC.B    'Collision',0
MSG_GAMEOVER    DC.B    'Game Over',0
MSG_DAMAGE      DC.B    'Taking Damage',0
MSG_POWERUP     DC.B    'Health Boost!',0
CRLF            DC.B    $0D,$0A,0

ENEMY_POSITIONS DC.L    20,30,40,50,60,70,80,90,200,300,500,0
POWER_UPS       DC.L    10,55,220,0

        END     START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
