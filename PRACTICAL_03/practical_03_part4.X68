*-----------------------------------------------------------
* Title      :  PRACTICAL_03
* Written by :  Oleksandr Storozhuk
* Date       :  26/01/2026
* Description:  PART 4
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    LEA PlayerHEALTH,   A0
    MOVE.B  (A0),   D0
    
    SUB.B   #10,    D0
    MOVE.B  D0, (A0)
    
    LEA LIVES,  A1
    MOVE.W  (A1),   D1
    
    SUB.W   #1, D1
    MOVE.W  D1, (A1)
    
    LEA SCORE,  A2
    MOVE.L  (A2),   D2
    
    ADD.L   #500,   D2
    MOVE.L  D2, (A2)
    
    LEA PlayerX,    A3
    MOVE.W  (A3),   D3
    
    ADD.W   #5, D3
    MOVE.W  D3, (A3)
    
    LEA PlayerY,    A4
    MOVE.W  (A4),   D4
    
    ADD.W   #10, D4
    MOVE.W  D4, (A4)
    
    LEA BossHEALTH, A5
    MOVE.W  (A5),   D5
    
    SUB.W   #500,   D5
    MOVE.W  D5, (A5)
    

    SIMHALT             ; halt simulator

* Put variables and constants here

PlayerHEALTH    dc.b    $64
LIVES           dc.w    3
SCORE           dc.l    1000

PlayerX         dc.w    120
PlayerY         dc.w    80

BossHEALTH      dc.w    500



    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
