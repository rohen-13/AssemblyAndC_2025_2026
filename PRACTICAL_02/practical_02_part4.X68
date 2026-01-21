*-----------------------------------------------------------
* Title      :  PRACTICAL_02
* Written by :  Oleksandr Storozhuk
* Date       :  19/01/2026 
* Description:  PART4
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #100,   D0      ;moving long value (32bit) 100 in decimal to data register 0
    MOVE.W  #$1234, D1      ;moving word value (16bit) 1234 in hexadecimal to data register 1
    MOVE.B  #%10001011, D2  ;moving byte value (8bit) 10001011 in binary to data register 2
    
    MOVE.L  D0, D3          ;moving long value (32bit) from data register 0 to data register 3
    MOVE.W  D1, D4          ;moving word value (16bit) from data register 1 to data register 4
    MOVE.B  D2, D5          ;moving byte value (8bit) from data register 2 to data register 5
    
    MOVE.L  D0, $3000       ;moving long value (32bit) from data register 0 to memory location 3000
    MOVE.W  D1, $4000       ;moving word value (16bit) from data register 1 to memory location 4000
    MOVE.B  D2, $4020       ;moving byte value (8bit) from data register 2 to memory location 4020
    
    MOVE.L  #$AABBCCDD, $3010 ;moving long value (32bit) AABBCCDD in hexadecimal to memory location 3010
    MOVE.W  #$55AA,     $3020 ;moving word value (16bit) 55AA in hexadecimal to memory location 3020
    MOVE.B  #$FF,       $3020 ;moving byte value (8bit) FF in hexadecimal to memory location 3020
    
    MOVE.L  $3000,  D6      ;moving long value (32bit) from memory location 3000 to data register 6
    MOVE.W  $4000,  D7      ;moving word value (16bit) from memory location 4000 to data register 7  
    MOVE.B  $4020,  D0      ;moving byte value (8bit) from memory location 4020 to data register 0
    
    MOVE.L  #11223344,  D1  ;moving long value (32bit) 11223344 in decimal to data register 1
    MOVE.W  D1, $3020       ;moving word value (16bit) from data register 1 to memory location 3020  
    MOVE.B  D2, $3022       ;moving byte value (8bit) from data register 2 to memory location 3022





    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
