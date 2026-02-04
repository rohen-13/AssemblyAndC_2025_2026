*-----------------------------------------------------------
* Title      : PRACTICAL_04_PART4
* Written by : OLEKSANDR STOROZHUK
* Date       : 04/02/2026
* Description: Simple Game using Registers, Logic & Branching
*-----------------------------------------------------------

        ORG     $1000
START:


        MOVE.B  #100,   $3000     ; Player Health = 100 ($64)
        MOVE.B  #80,    $3001     ; Boss Health = 80
        MOVE.B  #$34,   $3002     ; Player Position (X=3, Y=4)
        MOVE.B  #$78,   $3003     ; Boss Position (X=7, Y=8)
        MOVE.B  #0,     $3004     ; Player Score

        LEA     $3000,  A0        ; A0 -> Player Health
        LEA     $3001,  A1        ; A1 -> Boss Health
        LEA     $3002,  A2        ; A2 -> Player Position
        LEA     $3003,  A3        ; A3 -> Boss Position
        LEA     $3004,  A4        ; A4 -> Player Score

GAME_LOOP:
        BSR     PLAYER_ATTACK
        BSR     CHECK_BOSS_DEAD
        BSR     BOSS_ATTACK
        BSR     CHECK_PLAYER_DEAD
        
        BRA     GAME_LOOP

PLAYER_ATTACK:
        SUB.B   #15,    (A1)      ; Boss loses 15 health
        ADD.B   #10,    (A4)      ; Player gains score

        MOVE.B  (A2),   D0        ; Load Player position
        MOVE.B  (A3),   D1        ; Load Boss position
        EOR.B   D0,     D1        ; Toggle bits (hit effect)

        RTS


BOSS_ATTACK:
        SUB.B   #20,    (A0)      ; Player loses 20 health
        RTS

CHECK_BOSS_DEAD:
        MOVE.B  (A1),   D2
        BEQ     BOSS_DEAD         ; If health = 0
        RTS
        
        
CHECK_PLAYER_DEAD:
        MOVE.B  (A0),   D3
        BEQ     PLAYER_DEAD       ; If health = 0
        RTS

PLAYER_DEAD:
        MOVE.B  #0,     (A0)      ; Ensure health = 0
        SIMHALT
        
BOSS_DEAD:
        MOVE.B  #0,     (A1)      ; Ensure health = 0
        SIMHALT
        
    END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
