.model small
.data
    fullNumber db 6 DUP('*'),"$"     
    firstNum db 2 DUP(?),"$"      
    lastNum db 2 DUP(?),"$"      
    lengthFirst db 0            
    lengthLast db 0             
    msg db "Enter two number: $"
    newline db 0dh,0ah, "$" 
    fnum db ?
    Lnum db ? 
    
.code
main proc 
    
    mov ax, @data               
    mov ds, ax
     
    lea BP, msg
    CALL PRINT 
    
    lea dx, fullNumber
    mov ah, 0Ah                 
    int 21h

    lea si, fullNumber + 2        
    lea di, firstNum
    xor ax , ax         
getFirstNumber:
    mov al, [si]                
    cmp al, ' '                 
    je storeLastNumber            
    mov [di], al               
    inc si                      
    inc di                     
    inc lengthFirst             
    jmp getFirstNumber   


storeLastNumber: 
        inc si
        lea di, lastNum            

getLastNumber:
    mov al, [si]                
    cmp al, 0DH                    
    je NewL         
    mov [di], al               
    inc si                     
    inc di                      
    inc lengthLast              
    jmp getLastNumber
    
NewL: 

    lea BP, newline
    call PRINT        

    lea si, firstNum
    xor ax, ax        
    xor cx, cx                        
    mov Cl ,lengthFirst  
      
convert_loop:
    mov bl, [si]        
    cmp Cl , 0           
    je UpdateSI   
    sub bl, '0' ; convert Char to Number         
    mov bh, 0    
    mov dl , 10
    mul dl 
    add al , bl
    dec Cl                
    inc si
    mov fnum , al               
    jmp convert_loop  

UpdateSI:    
    lea si, lastNum 
    xor ax, ax         
    xor cx, cx 
    mov Cl ,lengthLast                        
      
convert_loop2:
    mov bl, [si]        
    cmp Cl , 0         
    je Begin   
    sub bl, '0' ; convert Char to Number         
    mov bh, 0    
    mov dl , 10
    mul dl 
    add al , bl            
    dec Cl    
    inc si
    mov Lnum , al             
    jmp convert_loop2    

Begin:    
    lea si , firstNum 
    mov cl , 0 
    mov Al , lengthLast
    mov ah , lengthFirst

CheckFinal:
    Mov al , fnum     
    Mov ah , Lnum  
    Cmp al , AH 
    jae  ExitProgram
    MOV al, [si]       
Check:  
    inc fnum                  
    cmp byte ptr [si] , '4'
    je LOOP_DIGITS              
    cmp byte ptr [si] , '7'
    je LOOP_DIGITS
    jne NextNumber    
                
LOOP_DIGITS:   
    inc cl 
    cmp cl , lengthFirst
    jne NotEqual
    je Lucky
    
NextNumber:
    mov Cl , 0 
    inc byte ptr [si] 
    Cmp byte ptr [si] , 3AH
    je Update
    jne CheckFinal
    
 
    NotEqual:
    lea si , firstNum[1]
    jmp CheckFinal
    
Update:
    cmp lengthFirst , 1 
    jne   Check2
    
    LengthEqulOne:
    mov byte ptr [si] , 49 
    mov byte ptr [si+ 1] , 48 
    inc lengthFirst
    add fnum , 23
    jmp CheckFinal
    
    Check2:
    cmp lengthFirst , 2
    jne Check3
    cmp AL , 39H
    jne Check3 
    add fnum , 12
    lea si , firstNum
    inc byte ptr [Si]
    Mov byte ptr [Si+1] , 48
    jmp CheckFinal          
     
    Check3:
    jmp ExitProgram
    
Lucky:

    lea BP, firstNum
    CALL PRINT
    
    lea BP, newline
    CALL PRINT

    jmp NextNumber  
        
ExitProgram:
    mov ah, 4Ch
    int 21h 
    
main endp 

PRINT PROC NEAR
    MOV AH,09H
    MOV DX , BP
    INT 21H
    RET
PRINT ENDP
               
end main