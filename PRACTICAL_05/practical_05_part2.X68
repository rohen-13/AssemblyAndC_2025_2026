*-----------------------------------------------------------
* Title      :  PRACTICAL_05
* Written by :  Oleksandr Storozhuk
* Date       :  09/02/2026
* Description:  PART 2
*-----------------------------------------------------------        
    ORG    $1000
START:
        LEA     PLAYER_POSITION, A1
        LEA     ENEMY_POSITION,  A2

        ; Load initial Player X and Y
        MOVE.B  (A1),   D1       ; Player X
        MOVE.B  1(A1),  D3       ; Player Y

        ; Load initial Enemy X and Y
        MOVE.B  (A2),   D2       ; Enemy X
        MOVE.B  1(A2),  D4       ; Enemy Y

COLLISION_CHECK:
        ; Check X coordinates equal
        CMP.B   D2, D1
        BNE     NEXT_MOVE

        ; Check Y coordinates equal
        CMP.B   D4, D3
        BNE     NEXT_MOVE

        ; Check X == 55
        CMP.B   #55, D1
        BNE     NEXT_MOVE

        ; Check Y == 55
        CMP.B   #55, D3
        BNE     NEXT_MOVE

        BRA     COLLISION

NEXT_MOVE:
        ; Increment positions, but stop at 55
        CMP.B   #55, D1
        BGE     SKIP_PLAYER_X
        ADD.B   #1, D1
SKIP_PLAYER_X:
        CMP.B   #55, D3
        BGE     SKIP_PLAYER_Y
        ADD.B   #1, D3
SKIP_PLAYER_Y:
        CMP.B   #55, D2
        BGE     SKIP_ENEMY_X
        ADD.B   #1, D2
SKIP_ENEMY_X:
        CMP.B   #55, D4
        BGE     SKIP_ENEMY_Y
        ADD.B   #1, D4
SKIP_ENEMY_Y:

        BRA     COLLISION_CHECK

COLLISION:
        ; Collision detected at (55,55)
        BRA     GAME_OVER

GAME_OVER:
        SIMHALT

PLAYER_POSITION:  DC.B    10, 15
ENEMY_POSITION:   DC.B    50, 55

        END     START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
