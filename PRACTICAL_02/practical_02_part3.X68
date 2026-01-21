*-----------------------------------------------------------
* Title      :  PRACTICAL_02
* Written by :  Oleksandr Storozhuk
* Date       :  19/01/2026 
* Description:  PART3
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L #%100,   D0  ;moving long value (32bit) 4 in binary to data register 0
    MOVE.L #$100,   D1  ;moving long value (32bit) 100 in hexadecimal to data register 1
    MOVE.L #100,    D2  ;moving long value (32bit) 100 in decimal to data register 2
    
    MOVE.L  D0,     $3000   ;moving long value (32bit) from data register 0 to memory location 3000
    MOVE.L  D1,     $3010   ;moving long value (32bit) from data register 1 to memory location 3010
    MOVE.L  D2,     $3020   ;moving long value (32bit) from data register 2 to memory location 3020
    
    MOVE.W  #100,   $3020   ;moving word value (16bit) 100 in decimal to memory location 3020  
    MOVE.W  #$100,  $3010   ;moving word value (16bit) 100 in hexadecimal to memory location 3010 
    MOVE.W  #%100,  $3000   ;moving word value (16bit) 4 in binary to memory location 3000 

    MOVE.B  #100,   $3020   ;moving byte valye (8bit) 100 in decimal to memory location 3020
    MOVE.B  #$64,   $3010   ;moving byte valye (8bit) 64 in hexadecimal to memory location 3010
    MOVE.B  #%10001111, $3000   ;moving byte valye (8bit) 143 in binary to memory location 3000


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
