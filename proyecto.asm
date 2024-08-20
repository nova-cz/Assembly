ORG 0100H                    ; Establece la direcci�n de origen del programa

mov ax, 0600h                ; Configura el modo de gr�fico(640x200 en color)
MOV bh, 3Fh                  ; Configura el color del fondo de pantalla
mov cx, 0h                   ; Inicializa CX en 0 para comenzar a escribir en esa posicion de la pantalla.
mov dh, 25                   ; Configura el n�mero de filas de la pantalla
mov dl, 80                   ; Configura el n�mero de columnas de la pantalla
int 10h                      ; Llama a la interrupci�n del BIOS para establecer el modo de video

MOV SI, 0                    ; Inicializa SI a 0 (�ndice de la cadena)

MOV DX, 2070h                ; Carga la direcci�n del puerto en DX
MOV Cx, 0xff                 ; Carga el valor que quieres enviar al puerto en cx
MOV AX, Cx                   ; Mueve el valor de Cx a AX
OUT DX, Ax                   ; Env�a el valor de AX al puerto especificado en DX

MOV DX, OFFSET titulo        ; Carga la direcci�n de memoria de 'titulo' en DX
MOV AH, 9                    ; Funci�n de impresi�n de cadena
INT 21H                      ; Llama a la interrupci�n del BIOS para imprimir la cadena

MOV DX, OFFSET msj_inicio    ; Carga la direcci�n de memoria de 'msj_inicio' en DX

MOV ES, CX                   ; Carga CX en el segmento extra (ES)
MOV DI, SI                   ; Carga SI en el �ndice de destino (DI)
JMP carfeliz                 ; Salta a la etiqueta 'carfeliz'

pedir_caracter:              ; Etiqueta para pedir un car�cter
    MOV DX, OFFSET clave1    ; Carga la direcci�n de memoria de 'clave1' en DX
    MOV AH, 9                ; Funci�n de impresi�n de cadena
    INT 21H                  ; Llama a la interrupci�n del BIOS para imprimir la cadena

    MOV DX, OFFSET msj_pedir_letra  ; Carga la direcci�n de memoria de 'msj_pedir_letra' en DX
    MOV AH, 9                ; Funci�n de impresi�n de cadena
    INT 21H                  ; Llama a la interrupci�n del BIOS para imprimir la cadena

    MOV AH, 1                ; Lee un car�cter
    INT 21H                  ; Llama a la interrupci�n del BIOS para leer un car�cter
    MOV BL, AL               ; Guarda el car�cter en BL
    JMP bucle_busqueda       ; Salta al bucle de b�squeda

bucle_busqueda:              ; Bucle para buscar caracteres
    MOV AL, clave1[SI]       ; Carga el caracter actual de la cadena en AL
    CMP AL, '_'              ; Compara si es un guion bajo
    JE encontrado_guion      ; Si es un guion bajo, salta a 'encontrado_guion'
    INC SI                    ; Incrementa SI para avanzar al siguiente car�cter
    CMP AL, '$'               ; Comprueba si es el final de la cadena
    JE fin_de_cadena          ; Si es el final de la cadena, salta a 'fin_de_cadena'
    JMP bucle_busqueda        ; Si no, vuelve al bucle de b�squeda

encontrado_guion:             ; Etiqueta para cuando se encuentra un guion bajo
    MOV clave1[SI], BL        ; Reemplaza el guion bajo con el car�cter le�do
    MOV AL, clave1_com[SI] 

    CMP BL, AL
    JE  buscar_fin_linea      ; Si son iguales, salta a 'buscar_fin_linea'
    JMP error_letra           ; Si no, salta a 'error_letra'

buscar_fin_linea:             ; Etiqueta para buscar el final de la l�nea
    MOV ES, CX
    MOV DI, SI
    JMP carfeliz              ; Salta a 'carfeliz'

    INC SI
    CMP clave1[SI], '$'
    JE fin_del_programa

    CMP clave1[SI], '_'
    JE pedir_caracter

    JMP buscar_fin_linea


error_letra:                  ; Etiqueta para manejar un error de letra
    shr CX, 1                 ; Desplaza a la derecha CX
    mov ax, cx                ; Mueve CX a AX
    mov dx, 2070h             ; Carga la direcci�n del puerto en DX
    out dx, ax                ; Env�a el valor de AX al puerto especificado en DX

    MOV DX, OFFSET error
    MOV AH, 9h                ; Funci�n de impresi�n de cadena
    INT 21h                   ; Llama a la interrupci�n del BIOS para imprimir la cadena

    MOV clave1[SI], '_'       ; Reemplaza el car�cter incorrecto con un guion bajo
    cmp cx, 0                 ; Compara si CX es igual a 0
    JE vidas_acabadas         ; Si es igual a 0, salta a 'vidas_acabadas'

    MOV ES, CX
    MOV DI, SI
    JMP cartriste             ; Salta a 'cartriste'

vidas_acabadas:               ; Etiqueta para cuando se acaban las vidas
    MOV DX, OFFSET msj_perdiste_vidas
    MOV AH, 9h                ; Funci�n de impresi�n de cadena
    INT 21h                   ; Llama a la interrupci�n del BIOS para imprimir la cadena
    RET                        ; Retorna al punto de llamada

carfeliz:                     ; Etiqueta para la cara feliz
    MOV Dx,2023h               ; Configura el puerto para la cara feliz
    MOV SI,0                   ; Inicializa SI a 0
    MOV CX,5                   ; Configura CX a 5 (tama�o de la cara feliz)
    MOV BX, OFFSET caritaF     ; Carga la direcci�n de memoria de 'caritaF' en BX

ciclo:                        ; Bucle para imprimir la cara feliz
    MOV Al, caritaF[SI]        ; Carga el valor de caritaF en AL
    OUT DX, Al                 ; Env�a el valor de AL al puerto DX
    INC SI                     ; Incrementa SI para avanzar al siguiente car�cter
    INC DX                     ; Incrementa DX para avanzar al siguiente puerto
    LOOP ciclo                 ; Repite el ciclo hasta que CX sea 0

    MOV CX, ES                 ; Restaura el valor de CX desde ES
    MOV SI, DI                 ; Restaura el valor de SI desde DI

    fin_linea:                    ; Etiqueta para el final de la l�nea
    INC SI                    ; Incrementa SI para avanzar al siguiente car�cter
    CMP clave1[SI], '$'       ; Compara si el caracter actual es el final de la cadena
    JE fin_del_programa       ; Si es el final de la cadena, salta a 'fin_del_programa'

    CMP clave1[SI], '_'       ; Compara si el caracter actual es un guion bajo
    JE pedir_caracter         ; Si es un guion bajo, vuelve a pedir un car�cter

    JMP fin_linea             ; Si no, contin�a buscando el final de la l�nea

    JMP pedir_caracter        ; Salta a 'pedir_caracter'

cartriste:                    ; Etiqueta para la cara triste
    MOV Dx,2023h               ; Configura el puerto para la cara triste
    MOV SI,0                   ; Inicializa SI a 0
    MOV CX,5                   ; Configura CX a 5 (tama�o de la cara triste)
    MOV BX, OFFSET caritaT     ; Carga la direcci�n de memoria de 'caritaT' en BX

ciclo2:                       ; Bucle para imprimir la cara triste
    MOV Al, caritaT[SI]        ; Carga el valor de caritaT en AL
    OUT DX, Al                 ; Env�a el valor de AL al puerto DX
    INC SI                     ; Incrementa SI para avanzar al siguiente car�cter
    INC DX                     ; Incrementa DX para avanzar al siguiente puerto
    LOOP ciclo2                ; Repite el ciclo hasta que CX sea 0

    MOV CX, ES                 ; Restaura el valor de CX desde ES
    MOV SI, DI                 ; Restaura el valor de SI desde DI

    JMP pedir_caracter         ; Vuelve a pedir un car�cter

fin_de_cadena:                ; Etiqueta para el final de la cadena
    CMP BL, AL                 ; Compara el �ltimo car�cter le�do con el esperado
    JE  fin_del_programa       ; Si son iguales, muestra el mensaje de finalizaci�n

    CMP clave1[SI], '$'        ; Compara si se lleg� al final de la cadena
    JNE error_letra            ; Si no es el final, hay un error de letra

    JMP fin_del_programa       ; Si no hay error, muestra el mensaje de finalizaci�n

fin_del_programa:             ; Etiqueta para el final del programa
    MOV DX, OFFSET clave1      ; Carga la direcci�n de memoria de 'clave1' en DX
    MOV AH, 9                  ; Funci�n de impresi�n de cadena
    INT 21H                    ; Llama a la interrupci�n del BIOS para imprimir la cadena

    MOV DX, OFFSET fin         ; Carga la direcci�n de memoria de 'fin' en DX
    MOV AH, 9                  ; Funci�n de impresi�n de cadena
    INT 21H                    ; Llama a la interrupci�n del BIOS para imprimir la cadena

RET                            ; Retorna al punto de llamada

titulo db 13,10, "ADIVINA LA PALABRA"      ; Define la cadena de t�tulo
msj_inicio db 13,10, "INGRESE LAS LETRAS CORRECTAS:$"  ; Define el mensaje de inicio
msj_pedir_letra db 13,10, "INGRESE UN CARACTER: $"     ; Define el mensaje para pedir una letra
msj_perdiste_vidas db 13,10, "PERDISTE! TE ACABASTE TUS VIDAS :')"  ; Define el mensaje de p�rdida de vidas
clave1_com db 13,10, "OTORRINOLARINGOLOGO$"    ; Define la palabra a adivinar
clave1 db 13,10, "O__RR__OL_RI__OL_G_$"        ; Define la palabra con los espacios a adivinar
error db 13,10, "LETRA INCORRECTA!$"           ; Define el mensaje de letra incorrecta
fin db 13,10, "FELICIDADES!$"                  ; Define el mensaje de finalizaci�n
caritaF db 0x10,                               ; Define la cara feliz en ASCII
       db 0x24, 
       db 0x20, 
       db 0x24, 
       db 0x10
       
caritaT db 0x20                                ; Define la cara triste en ASCII
        db 0x14,
        db 0x10,
        db 0x14,
        db 0x20  
;OTORRINOLARINGOLOGO
;O__RR__OL_RI__OL_G_