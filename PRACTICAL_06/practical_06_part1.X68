*-----------------------------------------------------------
* Title      :  PRACTICAL_06
* Written by :  OLEKSANDR STOROZHUK
* Date       :  23/02/2026
* Description:  PART_01
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.B  #2, D0
    TRAP    #15
    
    LEA     MESSAGE,    A1
    MOVE.B  #13,    D0
    TRAP    #15
    
    END_PROG:
    
    MESSAGE:    DC.B    'Trap Task Test',   0

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
