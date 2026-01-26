*-----------------------------------------------------------
* Title      :  PRACTICAL_03
* Written by :  Oleksandr Storozhuk
* Date       :  26/01/2026
* Description:  PART 3
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    LEA HEALTH,     A3
    SUB.B   #10,    (A3)

    SIMHALT             ; halt simulator

* Put variables and constants here
HEALTH  dc.b    $64
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
