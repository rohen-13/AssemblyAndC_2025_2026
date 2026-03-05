*-----------------------------------------------------------
* Title      :  PRACTICAL_06
* Written by :  OLEKSANDR STOROZHUK
* Date       :  05/03/2026
* Description:  PART_02
*-----------------------------------------------------------

    ORG     $1000


START:


    LEA     MSG1,A1
    MOVE.W  #13,D1
    MOVE.B  #0,D0
    TRAP    #15

    LEA     MSG2,A1
    MOVE.W  #22,D1
    MOVE.B  #1,D0
    TRAP    #15

    MOVE.L  #12345,D1
    MOVE.B  #3,D0
    TRAP    #15

    LEA     MSG3,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.B  #4,D0
    TRAP    #15

    MOVE.B  #5,D0
    TRAP    #15

    MOVE.B  #'A',D1
    MOVE.B  #6,D0
    TRAP    #15

    MOVE.B  #7,D0
    TRAP    #15

    MOVE.B  #8,D0
    TRAP    #15

    MOVE.W  #$050A,D1
    MOVE.B  #11,D0
    TRAP    #15

    MOVE.B  #0,D1
    MOVE.B  #12,D0
    TRAP    #15

    LEA     MSG4,A1
    MOVE.B  #13,D0
    TRAP    #15

    LEA     MSG5,A1
    MOVE.B  #14,D0
    TRAP    #15

    LEA     MSG6,A1
    MOVE.L  #555,D1
    MOVE.B  #17,D0
    TRAP    #15

    LEA     MSG7,A1
    MOVE.B  #18,D0
    TRAP    #15

    MOVE.B  #9,D0
    TRAP    #15

    SIMHALT


MSG1    DC.B 'Task 0 Example',0
MSG2    DC.B 'Task 1 Example ',0
MSG3    DC.B 'Enter a number:',0
MSG4    DC.B 'Task 13 message',0
MSG5    DC.B 'Task 14 message',0
MSG6    DC.B 'Number = ',0
MSG7    DC.B 'Input number: ',0


    END START
```


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
