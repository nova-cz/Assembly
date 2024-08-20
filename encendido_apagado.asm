       
       
palabra db 69, 78, 67, 69, 78, 68, 73, 68, 79
palabra2 db 65, 80, 65, 71, 65, 68, 79, 160, 160


Inicio:

MOV DX, 2084h
IN AL, DX
AND AL, 01

CMP AL, 0
JE imprimir_apagado

CMP AL, 1
JE imprimir_encendido
 
imprimir_encendido:
    MOV BX, offset palabra
    MOV SI, 0
    MOV CX, 9
    MOV DX, 2040h
    JMP ciclo  
    
imprimir_apagado:
    MOV BX, offset palabra2
    MOV SI, 0
    MOV CX, 9
    MOV DX, 2040h
    JMP ciclo  

ciclo: MOV al, [BX][SI]
       OUT DX, AL
       INC SI    
       ADD DX, 1  
       LOOP CICLO
       JMP Inicio
       