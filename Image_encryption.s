@ Submitted By 
@  Rohit Gupta (160102056)
@  Archana     (160102014)
@  Nagireddy Pravardhan (160102045)




@@@ takes an image as input, performs Sobel operation, and returns resultant image matrix
    .equ SWI_Open, 0x66            @ open a file
    .equ SWI_Close, 0x68           @ close a file
    .equ SWI_PrChr, 0x00           @ Write an ASCII char to Stdout
    .equ SWI_PrStr, 0x69           @ Write a null-ending string
    @.equ SWI_PrStr, 0x69          @ Write a null-ending string
    .equ SWI_PrInt,0x6b            @ Write an Integer
    .equ SWI_RdInt,0x6c            @ Read an Integer from a file
    .equ Stdout, 1                 @ Set output target to be Stdout
    .equ SWI_Exit, 0x11            @ Stop execution
    

.global _start
.text

_start:
@ indicate that the program is started
mov r9,#3

    mov R0,#Stdout                     @ print an initial message
    ldr R1, =Message1                  @ load address of Message1 label
    swi SWI_PrStr                      @ display message to Stdout

@ == Open an input file for reading =============================
@ if problems, print message to Stdout and exit
TakeInput:
        ldr r0,=InFileName                 @ set Name for input file
        mov r1,#0                          @ mode is input
        swi SWI_Open                       @ open file for input
        bcs InFileError                    @ Check Carry-Bit (C): if= 1 then ERROR

    @ Save the file handle in memory:
        ldr r1,=InputFileHandle            @ if OK, load input file handle
        str r0,[r1]                        @ save the file handle

    @ == Read size of matrix =============================
        ldr r9,=InputFileHandle
        ldr r9,[r9]
        mov r0, r9                         @ load input file handle
        swi SWI_RdInt                      @ read the integer into R0
        bcs CloseInputFile                 @ Check Carry-Bit (C): if= 1 then EOF reached

        ldr r1,=Row                        @ load Row of matrix
        str r0,[r1]                        @ save the Row

        mov r0, r9                         @ load input file handle
        swi SWI_RdInt                      @ read the integer into R0
        bcs CloseInputFile                 @ Check Carry-Bit (C): if= 1 then EOF reached

        ldr r1,=Col                        @ load Col of matrix
        str r0,[r1]                        @ save the Col


    @ == Read the matrix ==========================================
        ldr r5,=Row
        ldr r5,[r5]                        @ [r5] = Row
        ldr r6,=Col                    @ [r6] = Col
        ldr r6,[r6]
        ldr r8,=Mat
        mov r3, #0                         @ [r3] = i = 0

        LoopOuter:
            cmp r3, r5                         @ compare r3 with Row
            beq CloseInputFile                 @ if r3 equal to 0, jump to EofReached
            mov r4, #0                         @ [r4] = j = 0

        LoopInner:
            cmp r4, r6                         @ compare r4 with Col
            beq LoopInnerEnd                   @ if r4 equal to 0, jump to LoopInnerEnd
            mul r7, r3, r6                     @ [r7] = i*Col
            add r7, r7, r4                     @ [r7] = i*Col + j
            lsl r7, r7, #2                     @ [r7] = shift

            mov r0, r9
            swi SWI_RdInt                      @ [r0] = mat[i][j]
            add r7, r8, r7
            str r0, [r7]                       @ store r0 into mat[i][j]

            add r4, r4, #1                     @ j++


            b LoopInner

        LoopInnerEnd:

            add r4,r4,#0
            add r3, r3, #1                     @ i++
            b LoopOuter

    @ == Close a file ===============================================
    CloseInputFile:
        ldr R0, =InputFileHandle           @ get address of file handle
        ldr R0, [R0]                       @ get value at address
        swi SWI_Close


@====Open key file============================================

TakeInputkey:
        ldr r0,=InFileNamekey              @ set Name for input file
        mov r1,#0                          @ mode is input
        swi SWI_Open                       @ open file for input
        bcs InFileError                    @ Check Carry-Bit (C): if= 1 then ERROR

    @ Save the file handle in memory:
        ldr r1,=InputFileHandlekey         @ if OK, load input file handle
        str r0,[r1]                        @ save the file handle
        @ldr r1,=InputFileHandlekey                                              
        ldr r1,[r1]

@==Read the keys======================================
        ldr r5,=Row
        ldr r5,[r5]                        @ [r5] = Row
        ldr r6,=Col                        @ [r6] = Col
        ldr r6,[r6]
        ldr r8,=Kr
        ldr r9,=Kc
        mov r3, #0                         @ [r3] = i = 0

        LoopKr:
            cmp r3, r5                  @ compare r3 with Row
            beq inputKc                 @ if r3 equal to 0, jump to EofReached
            lsl r7, r3, #2
            add r7, r7, r8
            mov r0, r1
            swi SWI_RdInt
            str r0, [r7]
            add r3, r3, #1                     @ i++
            b LoopKr

    inputKc:
            mov r3, #0 
    LoopKc:        
            cmp r3, r6                        @ compare r3 with Col
            beq CloseInputFilekey             @ if r3 equal to 0, jump to EofReached
            lsl r7, r3, #2
            add r7, r7, r9
            mov r0, r1
            swi SWI_RdInt
            str r0, [r7]
            add r3, r3, #1                     @ i++
            b LoopKc

@====Close input key file==================================
 
 CloseInputFilekey :
    ldr R0, =InputFileHandlekey            @ get address of file handle
        ldr R0, [R0]                       @ get value at address
        swi SWI_Close       





@ == Open an encrypted output file for writing =============================
@ if problems, print message to Stdout and exit
    ldr r0,=OutFileName                @ set name for output file
    mov r1, #1                         @ set write mode
    swi SWI_Open                       @ open the file
    ldr r1, =OutputFileHandle
    str r0, [r1]                       @ save OutputFileHandle




    ldr r4,=Mat
    ldr r3,=T1
    ldr r9,=Kr

    ldr r5,=Row
    ldr r5,[r5]
    ldr r6,=Col
    ldr r6,[r6]

     
            

@row rotation begins=======================================================    
    mov r7, #0                           @i = 0
rowloop1:

    lsl r0, r7, #2
    add r0, r0, r9                        @[r0] = addr.kr[i]    ; [r9] = addr.kr
    ldr r0, [r0]                          @[r0] = kr[i]
    mov r1, #2                            @r1 = 2
    bl mod                                @if(kr[i] % 2)    r2 = (kr[i]%2)
    subs r2, r2, #1
    blt rowel

            mov r8, #0                   @j = 0
    rowifloop2: 

                lsl r0, r7, #2
                add r0, r0, r9               @[r0] = addr.kr[i]    ; [r9] = addr.kr
                ldr r0, [r0]                 @[r0] = kr[i] 
                add r0, r0, r8               @[r0] = j + kr[i]
                mov r1, r6                   @[r1] = col
                bl mod                       @r[2] = (j + kr[i]) % col
                mul r1, r7, r1               @[r1] = i * col
                add r0, r1, r2               @[r0] = i * col + ( (j + kr[i]) % col)
                lsl r0, r0, #2
                add r0, r0, r4               @addr. input[i][( j + kr[i]) % col]
                ldr r0, [r0]                 @r[0] = input[i][( j + kr[i]) % col]
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r3               @addr. t1[i][j]
                str r0 ,[r1]                 @t1[i][j] =  input[i][ ( j + kr[i]) % col]


    rowifloop2end:

            add r8, r8, #1               @j++
            subs r0, r6, r8
            bgt rowifloop2

rowloop1end:
            
    add r7, r7, #1
    subs r0, r5, r7
    bgt rowloop1
    b rowout

    rowel:      mov r8, #0                   @j=0
    rowelloop2: add r1, r8, r6               @[r1] = j + col
                lsl r0, r7, #2
                add r0, r0, r9               @[r0] = addr.kr[i]    ; [r9] = addr.kr
                ldr r0, [r0]                 @[r0] = kr[i] 
                sub r0, r1, r0               @[r0] = j + col - kr[i]
                mov r1, r6                   @[r1] = col
                bl mod                       @r[2] = ( j + col - kr[i]) % col



                mul r1, r7, r1               @[r1] = i * col
                add r0, r1, r2               @[r0] = i * col + ( (j + col - kr[i]) % col)
                lsl r0, r0, #2
                add r0, r0, r4               @addr. input[i][( j + col - kr[i]) % col]
                ldr r0, [r0]                 @[r0] = input[i][(j + col - kr[i]) % col]
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r3               @addr. t1[i][j]
                str r0 ,[r1]                 @t1[i][j] =  input[i][( j + kr[i] )%col ]
               

    rowelloop2end:
            add r8, r8, #1               @j++
            subs r0, r6, r8
            bgt rowelloop2
            b rowloop1end



rowout:      @ row rotation ends==============================================

ldr r4, =T2                            @[r4] = addr.T2
ldr r10, =Kc                           @[r10] = addr.kc

@ col rotation begins=========================================================
    mov r8, #0                           @j = 0
colloop1:
    lsl r0, r8, #2
    add r0, r0, r10                       @[r0] = addr.kc[j]     [r10] = addr.kc
    ldr r0, [r0]                          @[r0] = kc[j]
    mov r1, #2                            @r1 = 2
    bl mod                                @if( kc[j] % 2)
    subs r2, r2, #1
    blt  colel

            mov r7, #0                   @i = 0
    colifloop2: lsl r0, r8, #2
                add r0, r0, r10              @[r0] = addr.kc[j]     [r10] = addr.kc
                ldr r0, [r0]                 @[r0] = kc[j]
                add r0, r0, r7               @[r0] = i + kc[j]
                mov r1, r5                   @[r1] = row
                bl mod                       @r[2] = ( i + kc[j])% row
                mul r2, r6, r2               @[r2] = ((i + kc[j]) % row) * col
                add r0, r8, r2               @[r0] = (( i + kc[j]) % row) * col + j
                lsl r0, r0, #2
                add r0, r0, r3               @r[0] = addr.t1[ (i + kc[j] ) % row ][j]
                ldr r0, [r0]                 @r[0] = t1[ (i+kc[j])%row ][j]
                mul r1, r7, r6               @[r1] = i * col 
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r4               @addr. of t2[ i ][ j ]
                str r0 ,[r1]                 @t2[i][j] =  t1[ (i + kc[j]) % row ][j]


               

    colifloop2end:
            add r7, r7, #1               @ i++
            subs r0, r5, r7               
            bgt colifloop2              @i < row

colloop1end:
    add r8, r8, #1                @ j++
    subs r0, r6, r8
    bgt colloop1                 @j < col
    b colout

    colel:
            mov r7, #0                   @i=0
    colelloop2: add r1, r7, r5               @[r1] = row + i
                lsl r0, r8, #2
                add r0, r0, r10              @[r0] = addr.kc[j]     [r10] = addr.kc
                ldr r0, [r0]                 @[r0] = kc[j]
                sub r0, r1, r0               @[r0] = i+row-kc[j]
                mov r1, r5                   @[r1] = row
                bl mod                       @r[2] = (i + row - kc[ j ]) % row
                mul r2, r6, r2               @[r2] = ((i + row - kc[ j ]) % row ) * col
                add r0, r8, r2               @[r0] = ((i + row - kc[ j ]) % row ) * col + j
                lsl r0, r0, #2
                add r0, r0, r3               @r[0] = addr.t1[ ( i + row - kc[j] ) % row ][ j ]
                ldr r0, [r0]                 @r[0] = t1[ ( i + row - kc[j] ) % row ][ j ]
                mul r1, r7, r6               @[r1] = i * col 
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r4               @addr. t2[i][j]
                str r0 ,[r1]                 @t2[i][j] =  t1[ (i + row - kc[j] ) % row ][ j ]

               
    colelloop2end:
            add r7, r7, #1               @i++
            subs r0, r5, r7
            bgt colelloop2              @i<row
            b colloop1end

@colloop1end:
    add r8, r8, #1               @j++
    sub r0, r6, r8               
    bgt colloop1                @j<col

colout:  @ col rotation ends==========================================================


@ XOR begins==========================================================================
 mov r7, #0                           @i = 0
loop1:
       mov r8, #0                   @j = 0
        loop2: 
                mul r0, r7, r6
                add r0, r0, r8           @[r0] = i * col + j
                lsl r0, r0, #2
                add r0, r0, r4           @[r0] = addr. of T2[i][j]
                ldr r2, [r0]             @r[0] = T2[i][j]
                mov r1, #255
                eor r2, r1               @[r2] = T2[i][j] XOR 255
                str r2, [r0]             @T2[i][j] = T2[i][j] XOR 255


                add r1, r2, #0             @r1 = t2[i][j] XOR 255
                ldr r0, =OutputFileHandle  @loading outputfilehandle to r0
                ldr r0, [r0]               @ following  three instruction for printing 
                swi SWI_PrInt
                ldr r1, =Space
                swi SWI_PrStr
        loop2end:

            add r8, r8, #1               @ j++
            subs r0, r6, r8               
            bgt loop2                      @j < col
    
loop1end:

 ldr r0, =OutputFileHandle                 @ printing the new line after a row
            ldr r0, [r0]
            ldr r1, =NL 
            swi SWI_PrStr

    add r7, r7, #1               @i++
    subs r0, r5, r7               
    bgt loop1                @i < row

@XOR ends==============================================================================


CloseOutputFile:                                    
        ldr r0, =OutputFileHandle
        swi SWI_Close                      @ close output file




@======decryption begins================================
@ == Open an encrypted output file for writing =============================
@ if problems, print message to Stdout and exit
    ldr r0,=OutFileNamede              @ set name for output file
    mov r1, #1                         @ set write mode
    swi SWI_Open                       @ open the file
    ldr r1, =OutputFileHandlede
    str r0, [r1]                       @ save OutputFileHandlede

 @ rev XOR begins==========================================================================
 mov r7, #0                           @i = 0
loop1de:
       mov r8, #0                   @j = 0
        loop2de: 
                mul r0, r7, r6
                add r0, r0, r8           @[r0] = i * col + j
                lsl r0, r0, #2
                add r0, r0, r4           @[r0] = addr. of T2[i][j]
                ldr r2, [r0]             @r[0] = T2[i][j]
                mov r1, #255
                eor r2, r1               @[r0] = T2[i][j] XOR 255
                str r2, [r0]             @T2[i][j] = T2[i][j] XOR 255


                 
        loop2endde:

            

            add r8, r8, #1               @ j++
            subs r0, r6, r8               
            bgt loop2de              @i < row
    
loop1endde:


    add r7, r7, #1                   @i++
    subs r0, r5, r7               
    bgt loop1de                       @j<col

@rev XOR ends==============================================================================
            


    ldr r3,=T2                             @r3 = addr.t1
    ldr r4, =T1                            @[r4] = addr.T1
    ldr r10, =Kc                           @[r10] = addr.kc
    ldr r5,=Row                            @r5 = Row
    ldr r5,[r5]
    ldr r6,=Col                            @r6 = col
    ldr r6,[r6]

@ col rev rotation begins=========================================================
    mov r8, #0                           @j = 0
colloop1de:
    lsl r0, r8, #2                        
    add r0, r0, r10                       @[r0] = addr.kc[j]     [r10] = addr.kc
    ldr r0, [r0]                          @[r0] = kc[j]
    mov r1, #2                            @r1 = 2
    bl mod                                @if( kc[j] % 2)
    subs r2, r2, #1                       
    beq  colelde                          

            mov r7, #0                   @i = 0
    colifloop2de: lsl r0, r8, #2
                add r0, r0, r10                       @[r0] = addr.kc[j]     [r10] = addr.kc
                ldr r0, [r0]                          @[r0] = kc[j]
                add r0, r0, r7               @[r0] = i + kc[j]
                mov r1, r5                   @[r1] = row
                bl mod                       @r[2] = ( i + kc[j])% row
                mul r2, r6, r2               @[r2] = ((i + kc[j]) % row) * col
                add r0, r8, r2               @[r0] = (( i + kc[j]) % row) * col + j
                lsl r0, r0, #2
                add r0, r0, r3               @r[0] = addr.t1[ (i + kc[j] ) % row ][j]
                ldr r0, [r0]                 @r[0] = t2[ (i+kc[j])%row ][j]
                mul r1, r7, r6               @[r1] = i * col 
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r4               @addr. of t1[ i ][ j ]
                str r0 ,[r1]                 @t1[i][j] =  t2[ (i + kc[j]) % row ][j]


               

    colifloop2endde:
            add r7, r7, #1               @ i++
            subs r0, r5, r7               
            bgt colifloop2de              @i < row

colloop1endde:
           


    add r8, r8, #1                @ j++
    subs r0, r6, r8
    bgt colloop1de                 @j < col
    b coloutde

    colelde:
            mov r7, #0                   @i=0
    colelloop2de: add r1, r7, r5             @[r1] = row + i
                lsl r0, r8, #2
                add r0, r0, r10              @[r0] = addr.kc[j]     [r10] = addr.kc
                ldr r0, [r0]                 @[r0] = kc[j]
                sub r0, r1, r0               @[r0] = i+row-kc[j]
                mov r1, r5                   @[r1] = row
                bl mod                       @r[2] = (i + row - kc[ j ]) % row
                mul r2, r6, r2               @[r2] = ((i + row - kc[ j ]) % row ) * col
                add r0, r8, r2               @[r0] = ((i + row - kc[ j ]) % row ) * col + j
                lsl r0, r0, #2
                add r0, r0, r3               @r[0] = addr.t1[ ( i + row - kc[j] ) % row ][ j ]
                ldr r0, [r0]                 @r[0] = t1[ ( i + row - kc[j] ) % row ][ j ]
                mul r1, r7, r6               @[r1] = i * col 
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r4               @addr. t2[i][j]
                str r0 ,[r1]                 @t2[i][j] =  t1[ (i + row - kc[j] ) % row ][ j ]

               
    colelloop2endde:
            add r7, r7, #1               @i++
            subs r0, r5, r7
            bgt colelloop2de              @i<row
            b colloop1endde

@colloop1endde:
    add r8, r8, #1               @j++
    sub r0, r6, r8               
    bgt colloop1de                @j<col

coloutde:  @ col rev rotation ends==========================================================

     
    ldr r4,=T1
    ldr r3,=T2
    ldr r9,=Kr
    ldr r5,=Row
    ldr r5,[r5]
    ldr r6,=Col
    ldr r6,[r6]



@row rev rotation begins=======================================================    
    mov r7, #0                           @i = 0
rowloop1de:

    lsl r0, r7, #2
    add r0, r0, r9                        @[r0] = addr.kr[i]    ; [r9] = addr.kr
    ldr r0, [r0]                          @[r0] = kr[i]
    mov r1, #2                            @r1 = 2
    bl mod                                @if(kr[i] % 2)
    subs r2, r2, #1
    beq rowelde

            mov r8, #0                   @j = 0
    rowifloop2de: 

                lsl r0, r7, #2
                add r0, r0, r9               @[r0] = addr.kr[i]    ; [r9] = addr.kr
                ldr r0, [r0]                 @[r0] = kr[i] 
                add r0, r0, r8               @[r0] = j + kr[i]
                mov r1, r6                   @[r1] = col
                bl mod                       @r[2] = (j + kr[i]) % col
                mul r1, r7, r1               @[r1] = i * col
                add r0, r1, r2               @[r0] = i * col + ( (j + kr[i]) % col)
                lsl r0, r0, #2
                add r0, r0, r4               @addr. input[i][( j + kr[i]) % col]
                ldr r0, [r0]                 @r[0] = input[i][( j + kr[i]) % col]
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r3               @addr. t2[i][j]
                str r0 ,[r1]                 @t2[i][j] =  t1[i][ ( j + kr[i]) % col]

                add r1, r0, #0
                ldr r0, =OutputFileHandlede
                ldr r0, [r0]
                swi SWI_PrInt
                ldr r1, =Space
                swi SWI_PrStr


    rowifloop2endde:

            add r8, r8, #1               @j++
            subs r0, r6, r8
            bgt rowifloop2de

rowloop1endde:

            ldr r0, =OutputFileHandlede
            ldr r0, [r0]
            ldr r1, =NL 
            swi SWI_PrStr
            
    add r7, r7, #1
    subs r0, r5, r7
    bgt rowloop1de
    b rowoutde

    rowelde:      mov r8, #0                   @j=0
    rowelloop2de: add r1, r8, r6             @[r1] = j + col
                lsl r0, r7, #2
                add r0, r0, r9               @[r0] = addr.kr[i]    ; [r9] = addr.kr
                ldr r0, [r0]                 @[r0] = kr[i] 
                sub r0, r1, r0               @[r0] = j + col - kr[i]
                mov r1, r6                   @[r1] = col
                bl mod                       @r[2] = ( j + col - kr[i]) % col



                mul r1, r7, r1               @[r1] = i * col
                add r0, r1, r2               @[r0] = i * col + ( (j + col - kr[i]) % col)
                lsl r0, r0, #2
                add r0, r0, r4               @addr. input[i][( j + col - kr[i]) % col]
                ldr r0, [r0]                 @[r0] = input[i][(j + col - kr[i]) % col]
                add r1, r1, r8               @[r1] = i * col + j
                lsl r1, r1, #2
                add r1, r1, r3               @addr. t1[i][j]
                str r0 ,[r1]                 @t1[i][j] =  input[i][( j + kr[i] )%col ]

                add r1, r0, #0
                ldr r0, =OutputFileHandlede
                ldr r0, [r0]
                swi SWI_PrInt
                ldr r1, =Space
                swi SWI_PrStr
               

    rowelloop2endde:
            add r8, r8, #1               @j++
            subs r0, r6, r8
            bgt rowelloop2de
            b rowloop1endde



rowoutde:      @ row rev rotation ends==============================================






CloseOutputFile1:
        ldr r0, =OutputFileHandlede
        swi SWI_Close                      @ close output file

EofReached:
    mov R0, #Stdout                    @ print last message
    ldr R1, =EndOfFileMsg
    swi SWI_PrStr


Exit:
    swi SWI_Exit                       @ stop executing



InFileError:
    mov R0, #Stdout
    ldr R1, =FileOpenInpErrMsg
    swi SWI_PrStr
    bal Exit                           @ give up, go to end


mod :                                @mod(x,y)
	vmov s2, r1
	vcvt.F64.S32 d0, s2
	vmov s3, r0
	vcvt.F64.S32 d3, s3
	vdiv.F64 d9, d3, d0  
	vcvt.S32.F64 s0, d9 
	vmov r2,s0         			      @[r2]= x/y
    mul r2, r2, r1                    @[r2]= y*Quotient
	sub r2, r0, r2                    @[r2]= x % y 
	bx lr
		 


 .data
.align
Row:                .skip       4
Col:                .skip       4
InputFileHandle:    .skip       4
InputFileHandlekey: .skip       4
OutputFileHandle:   .skip       4
OutputFileHandlede: .skip       4
Mat:                .skip       1228800           @ 4*l*b
T1:                 .skip       1228800
T2:                 .skip       1228800
Kr:                 .skip       1920                @4*row
Kc:                 .skip       2560                @4*col
InFileName:         .asciz      "original_image.txt"
InFileNamekey:      .asciz      "Key.txt"
OutFileName:        .asciz      "outputencrypted.txt"
OutFileNamede:      .asciz      "outputdecrypted.txt"
FileOpenInpErrMsg:  .asciz      "Failed to open input file \n"
EndOfFileMsg:       .asciz      "End of file reached\n"
ColonSpace:         .asciz      ": "
NL:                 .asciz      "\n"   @ new line
Message1:           .asciz      "Hello World! \n"
Space:              .asciz      " "
.end 
    





