*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #100,   D0
    MOVE.W  #$1234, D1
    MOVE.B  #%10001011, D2
    
    MOVE.L  D0, D3
    MOVE.W  D1, D4
    MOVE.B  D2, D5
    
    MOVE.L  D0, $3000
    MOVE.W  D1, $4000
    MOVE.B  D2, $4020
    
    MOVE.L  #$AABBCCDD, $3010
    MOVE.W  #$55AA,     $3020
    MOVE.B  #$FF,       $3020
    
    MOVE.L  $3000,  D6
    MOVE.W  $4000,  D7  
    MOVE.B  $4020,  D0
    
    MOVE.L  #11223344,  D1
    MOVE.W  D1, $3020  
    MOVE.B  D2, $3022




    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
