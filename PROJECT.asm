;	PROJECT#3 : SCRAMBLING ENCRYPTION
include emu8086.inc 

;INITALIZING SOME REGISTERS 

#DS=3000h#
#ES=4000h#                  
#AX=0002h#;                 TO START WITH PRINTING TEXT MESSAGE
#CX=0001h#;                 TO START A LOOP

.CODE
       
         PRINT 'PLEASE ENTER A STRING & HIT ENTER TO CONTINUE :' 
         MOV DL,0DH;
         INT 21H;
         MOV DL,0AH;
         INT 21H; 
         
;ENTERING THE MESSAGE 
         
LOOP1:         
        MOV AH,1;           ENTER EACH LETTER & STORE IT IN SOURCE ARRAY 
        INT 21H;                            
        MOV [SI],AL;                              
        INC SI; 
        INC CL;
        CMP AL,0DH;
        LOOPNE LOOP1;  
        
;TO WORK ON 16 LETTERS MAX < CL CAN BE CHANGED>        
        
        MOV SI,0;
        MOV CL,16;

;NEW LINE AND CARRIAGE RETURN 
                              
        MOV AH,2
        MOV DL,0AH;
        INT 21H;
        MOV DL,0DH;
        INT 21H;
                

LOOP2:  MOV BP,CX;          TO STORE MAIN CURRENT ITERATION 
                            
        MOV AL,16;          TO MAKE AN ASCENDING LOOP
        SUB AL,CL;
        XCHG AL,CL;         
        
        MOV AL,0;           TO SHUFFLE INDEX USING AL AND DL 
        MOV DL,CL;                           
        MOV CX,4;           16 CHARACHTERS MAX. <CAN BE CHANGED>
        MOV SP,SI;          TO STORE CURRENT LETTER INDEX OF ORIGINAL STRING (LOOKUP TABLE)
        
;LOOP TO REVERSE BITS OF CURRNT INDEX        
        
RLOOP:
          
        RCR DL,1;           
        RCL AL,1;               
        MOV AH,0;                            
        MOV SI,AX;
        LOOP RLOOP;
         
        MOV CX,BP;          RETURN TO CURRENT ITERATION 
        
        MOV AL,[SI;         MOV CURRENT INDEX LETTER TO DESTINATION ARRAY IN ES 
        STOSB ;                                       
        
        MOV SI,SP;          RETURN TO CURRENT INDEX IN LOOKUP TABLE
        INC SI;             GO TO CURRENT INDEX IN LOOKUP TABLE
        LOOP LOOP2;
        
        MOV DI,0;
        MOV CX,16;
        
        PRINT 'THE SCRAMBLED STRING IS:' 
        MOV AH,2;
        MOV DL,0DH;
        INT 21H;
        MOV DL,0AH;
        INT 21H; 
        
;PRINTING THE SCRAMBLED STRING
        
LOOP3:  MOV AH,2
        CMP ES:[DI],0DH;     CHANGE THE 'ENTER' CHARACHTER '0DH' TO NULL CHARACTER'00H'
        JE TO_NULL;          TO AVOID CARRIAGE RETURN AND OVERWRITTING FIRST LETTERS
        JNE DONE;
        
          
TO_NULL:MOV ES:[DI],0;

DONE:   MOV DL,ES:[DI];
        INT 21H;
        INC DI;
        LOOP LOOP3; 
        
;--------------------------------------------------------------------------------------------------
;RESTORE THE ORIGINAL STRING:

        MOV CL,16;
        MOV SI,0  
        
;DELETE SOURCE ARRAY        
        
        
DEL_SRC:MOV [SI],0; 
        INC SI;
        LOOP DEL_SRC;
        
        MOV AH,2;           NEW LINE AND CARRIAGE RETURN 
        MOV DL,0AH;
        INT 21H;
        MOV DL,0DH;
        INT 21H;
        
        MOV SI,0; 
        MOV DI,0;
        MOV CL,16;
        
LOOP4:  MOV BP,CX;          STORE MAIN CURRENT ITERATION 

        MOV AL,16;          MAKE AN ASCENDING LOOP
        SUB AL,CL;
        XCHG AL,CL;         
        
        MOV AL,0;           SHUFFLE INDEX USING AL AND DL 
        MOV DL,CL;                           
        MOV CX,4;           16 CHARACHTERS MAX. <CAN BE CHANGED>
        MOV SP,DI;          STORE CURRENT LETTER INDEX IN DESTINATION ARRAY  
        
;LOOP TO REVERSE BITS OF CURRNT INDEX        
        
RLOOP_2:
          
        RCR DL,1 
        RCL AL,1;               
        MOV AH,0;                            
        MOV DI,AX;
        LOOP RLOOP_2;
         
        MOV CX,BP;          RETURN TO MAIN CURRENT ITERATION 
        
        MOV AL,ES:[DI;      MOV CURRENT INDEX LETTER TO SOURCE ARRAY IN DS 
        MOV [SI],AL;
        MOV DI,SP;          RETURN TO CURRENT INDEX IN DEST. TABLE
        INC DI;             GO TO CURRENT INDEX IN DEST. TABLE
        INC SI;
        LOOP LOOP4;
        
        MOV SI,0;
        MOV CX,16;
        
        PRINT 'YOUR ORIGIONAL STRING IS:' 
        MOV AH,2;
        MOV DL,0DH;
        INT 21H;
        MOV DL,0AH;
        INT 21H;
         
;OUTPUT ORIGINAL STRING 
       
        LOOP5:  MOV AH,2;----------- 
        MOV DL,[SI];
        INT 21H;
        INC SI;
        LOOP LOOP5;         
HLT       
