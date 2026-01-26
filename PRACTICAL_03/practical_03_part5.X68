*-----------------------------------------------------------
* Title      :  PRACTICAL_03
* Written by :  Oleksandr Storozhuk
* Date       :  26/01/2026
* Description:  PART 5
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

        MOVEA.L    #ACHIEVEMENT_POINTS, A1  
        MOVE.L     #0, D0                   

        MOVE.L     (A1)+, D2               
        ADD.L      D2, D0

        MOVE.L     (A1)+, D2                
        ADD.L      D2, D0

        MOVE.L     (A1)+, D2                 
        ADD.L      D2, D0

        MOVE.L     (A1)+, D2         
        ADD.L      D2, D0
        
        MOVE.L     (A1)+, D2         
        ADD.L      D2, D0

    SIMHALT             ; halt simulator

* Put variables and constants here

ACHIEVEMENT_POINTS  dc.l    5, 10, 15, 20, 30

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
