
JMP show
;int arreglo
numeros db 3Fh ;0

db 06h ;1

db 5Bh ;2
 
db 4Fh ;3
 
db 66h ;4

db 6Dh ;5
 
db 7Dh ;6

db 07h ;7
 
db 7Fh ;8

db 6Fh ;9


show:

MOV Bx, offset numeros 
MOV SI,0
MOV CX, 10 ;no. de iteraciones del contador i=10;
MOV Dx, 2030h


ciclo:  MOV AL, [Bx][SI] ;al=lo que marque el indice, SI= indice 
        OUT Dx, AL
        INC SI ;INC Dx ;mueve la direccion del puerto, i++
        ;ADD Dx,02h  ;i++ en de 2 en 2
        LOOP ciclo ; instruccion para ciclar  
        
        
                                              