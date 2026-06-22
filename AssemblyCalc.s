.global _main
.align 2

.data
prompt: .ascii "Enter First Number: \0"
prompt_op: .ascii "Enter operator (+, -, *, /): \0"
prompt2: .ascii "Enter Second Number: \0"

input_buffer: .space 8
output_buffer: .space 16

.text
_main:
    ; Print Prompt
    mov X0, #1 ; file descriptor for stdout
    adrp X1, prompt@PAGE 
    add X1, X1, prompt@PAGEOFF 
    mov X2, #21 ; length of prompt  
    mov X16, #4 ; syscall for write
    svc 0

    ; Read Input 
    mov X0, #0 ; file descriptor for stdin
    adrp X1, input_buffer@PAGE
    add X1, X1, input_buffer@PAGEOFF
    mov X2, #8 ; up to 8 chars 
    mov X16, #3 ; syscall for read
    svc 0



    ; Ascii conversion 
    mov X4, #0 ; total 
    mov X5, #10 ; multiplier 

    adrp X1, input_buffer@PAGE ; set X1 to point at start of our sting 
    add X1, X1, input_buffer@PAGEOFF

    parse_loop:
        ldrb w6, [X1] ; load one byte (a char)
            ; w6 drops it in the lower 32 bits so it wont spend extra time managing the upper bits 
        cmp w6, #10 ; check if the char is the Enter key (\n is 10)
        beq done_parsing ; If it is equal , break out o fthe loop
        cmp w6, #0 ; check if it is null in case 
        beq done_parsing

        sub w6, w6, #48 ; subract 48 to turn ascii '2' into 2
        mul X4, X4, X5 ; multiply our total by 10
        add X4, X4, X6 ; add new digit to our total 

        add X1, X1, #1 ; move our pointer forward by one byte
        b parse_loop ; loop back to the top -from b-

    done_parsing:
        ; SUCCESS! for prompt one 
        mov X19, X4 ; ; move to a safe place 

    ; get operator 
    mov X0, #1
    adrp X1, prompt_op@PAGE
    add X1, X1, prompt_op@PAGEOFF
    mov X2, #29
    mov X16, #4
    svc 0

    mov X0, #0
    adrp X1, input_buffer@PAGE
    add X1, X1, input_buffer@PAGEOFF
    mov X2, #8
    mov X16, #3
    svc 0
    ; only the first char typed 
    adrp X1, input_buffer@PAGE
    add X1, X1, input_buffer@PAGEOFF
    ldrb w22, [X1]
    


    ; Print Secound Prompt
    mov X0, #1 ; file descriptor for stdout
    adrp X1, prompt2@PAGE 
    add X1, X1, prompt2@PAGEOFF 
    mov X2, #21
    mov X16, #4 ; syscall for write
    svc 0

    ; Read Secound Input 
    mov X0, #0 ; file descriptor for stdin
    adrp X1, input_buffer@PAGE
    add X1, X1, input_buffer@PAGEOFF
    mov X2, #8 ; up to 8 chars 
    mov X16, #3 ; syscall for read
    svc 0



    ; Ascii conversion Secound
    mov X4, #0 ; total 
    mov X5, #10 ; multiplier 

    adrp X1, input_buffer@PAGE ; set X1 to point at start of our sting 
    add X1, X1, input_buffer@PAGEOFF

    parse_loop2:
        ldrb w6, [X1] ; load one byte (a char)
            ; w6 drops it in the lower 32 bits so it wont spend extra time managing the upper bits 
        cmp w6, #10 ; check if the char is the Enter key (\n is 10)
        beq done_parsing2 ; If it is equal , break out o fthe loop
        cmp w6, #0 ; check if it is null in case 
        beq done_parsing2

        sub w6, w6, #48 ; subract 48 to turn ascii '2' into 2
        mul X4, X4, X5 ; multiply our total by 10
        add X4, X4, X6 ; add new digit to our total 

        add X1, X1, #1 ; move our pointer forward by one byte
        b parse_loop2 ; loop back to the top -from b-

    done_parsing2:
        ; SUCCESS! 
        mov X20, X4 ; move to a safe place 
    
    ; do the math 
    mov X21, #0 ; default to zero 

    cmp w22, #'+'
    beq do_add

    cmp w22, #'-'
    beq do_sub

    cmp w22, #'*'
    beq do_mul

    cmp w22, #'/'
    beq do_div

    b end_math

    do_add:
    add X21, X19, X20
    b end_math 

    do_sub:
    sub X21, X19, X20
    b end_math

    do_mul:
    mul X21, X19, X20
    b end_math

    do_div:
    sdiv X21, X19, X20
    b end_math

    end_math: ; will do it from the end of the buffer so that it wont come out backwards 
        adrp X1, output_buffer@PAGE
        add X1, X1, output_buffer@PAGEOFF
        add X1, X1, #15 ; jump to the end of the buffer 

        mov w2, #10 ; add newline
        strb w2, [X1] ; store newline
        sub X1, X1, #1 ; move pointer backward one point 

        mov x3, #0 ; count how many chars we print 
        mov X5, #10 ; divide by ten 

        convert_loop: ; as we dont have a module op here we do rem = t - (q * 10)
            sdiv X4, X21, X5 ; Division: X4 = 125 / 10  -> (X4 = 12)
            msub X6, X4, X5, X21 ; Modulo:   X6 = 125 - (12 * 10) -> (X6 = 5)

            add w6, w6, #48
            strb w6, [X1]

            add X3, X3, #1
            sub X1, X1, #1
            mov X21, X4

            cmp X21, #0
            bgt convert_loop


            add X1, X1, #1
            add X2, X3, #1

            mov X0, #1
            mov X16, #4
            svc 0


    ; Exit Call 
    mov X0, #0 ; exit status
    mov X16, #1 ; syscall for exit
    svc 0

