*-----------------------------------------------------------
* Title      :  PRACTICAL_04
* Written by :  OLEKSANDR STOROZHUK
* Date       :  04/02/2026
* Description:  PART2
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    
    MOVE.B  #$12,   D2
    MOVE.B  #$22,   D3
    AND.B   D2, D3
    
    MOVE.B  #$12,   D0
    MOVE.B  #$22,   D1
    OR.B   D0, D1

    MOVE.B  #$0F, D4  
    NOT.B   D4
    
    MOVE.B  #$12, D5   
    MOVE.B  #$22, D6         
    EOR.B   D5, D6

    
    
    MOVE.B #100,    $3000
    LEA    $3000,   A1
    SUB.B   #20,    (A1)
    ADD.B   #10,    (A1)

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
