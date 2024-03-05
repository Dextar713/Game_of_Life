.data
mx_rows : .long 20
mx_cols : .long 20
mx_sz : .long 400
sz : .space 4

mat : .space 1600
m : .space 4
n : .space 4
p : .space 4
k : .space 4
temp : .space 4
cnt : .long 0
form_in3 : .asciz "%ld%ld%ld"
f_in2: .asciz "%ld%ld"
f_out : .asciz "%ld "
f_o : .asciz "%ld\n"
new_line : .asciz "\n"
f_in : .asciz "%ld"
i : .long 0
j : .long 0

file_ptr : .space 4
f_mode : .asciz "r"
f_name : .asciz "in.txt"
out_mode : .asciz "w"
out_name : .asciz "out.txt"
out_ptr : .space 4

.text
.global main


fill:
    xor %ecx, %ecx
    lea mat, %edi
    for_fill:
        movl $0, (%edi, %ecx, 4)
        incl %ecx
        cmp %ecx, mx_sz
        jg for_fill
    ret



main:
    pushl $f_mode
    pushl $f_name
    call fopen 
    add $8, %esp 
    movl %eax, file_ptr


    pushl $p
    pushl $n
    pushl $m
    pushl $form_in3
    pushl file_ptr
    call fscanf
    add $20, %esp
    xor %edx, %edx
    incl m
    incl n
    incl n 
    mov m, %eax
    mov n, %ebx
    mul %ebx
    mov %eax, sz
    decl sz 
    call fill

    xor %ecx, %ecx


    for_read:
        cmp %ecx, p
        je calc_ev
        pusha
        pushl $j
        pushl $i 
        pushl $f_in2
        pushl file_ptr
        call fscanf
        addl $16, %esp
        popa
        incl i
        incl j

        mov i, %eax
        mov n, %ebx
        mul %ebx
        add j, %eax

        

        movl $1, (%edi, %eax, 4)
        incl %ecx
        jmp for_read

    calc_ev:
        pusha
        pushl $k
        pushl $f_in
        pushl file_ptr
        call fscanf
        add $12, %esp 
        popa
        call evolution
        jmp display     




display:
    pusha
    pushl $out_mode
    pushl $out_name
    call fopen 
    add $8, %esp 
    mov %eax, out_ptr
    popa 

    xor %ecx, %ecx 
    decl n 
    mov n, %eax
    add $2, %eax 
    incl %ecx 


    for_write:
        cmp %ecx, m
        je fin
        xor %ebx, %ebx
        incl %ebx 
        forw:
            cmp %ebx, n
            je ex_forw
            mov %ebx, j
            xor %edx, %edx 
            movl (%edi, %eax, 4), %ebx
            mov %ebx, temp 
            mov j, %ebx 
            pusha
            pushl temp 
            pushl $f_out
            pushl out_ptr
            call fprintf
            add $12, %esp
            popa
            incl %eax  
            incl %ebx 
            jmp forw
        ex_forw:
            incl %eax 
            incl %eax 
            incl %ecx
            pusha 
            pushl $new_line
            pushl out_ptr
            call fprintf
            add $8, %esp 
            popa 
            jmp for_write

fin:
    pushl out_ptr
    call fclose 
    popl %ebx 
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80



evolution:
    movl $0, i
    
    for_ev:

        movl i, %eax
        cmp %eax, k
        je ex_ev
        mov n, %ecx
        incl %ecx 
        movl $2, %edx 

        for1:
            cmp %ecx, sz
            jle evol2 
            mov (%edi, %ecx, 4), %ebx 

            movl $0, cnt
            pushl %ebx 
            call count 
            popl %ebx 
            movl cnt, %eax
            cmpl $1, %ebx 
            je check1
            jmp check0

            loop_f:
                incl %ecx
                incl %edx 
                cmp %edx, n 
                je next_line
                jmp for1 
            
            next_line:
                add $2, %ecx  
                mov $2, %edx 
                jmp for1 

        
        check1:
            cmp $3, %eax 
            jg change
            cmp $2, %eax 
            jl change 
            jmp loop_f 

        
        check0:
            cmp $3, %eax 
            je change 
            jmp loop_f 


        change:
            addl $2, %ebx
            mov %ebx, (%edi, %ecx, 4)
            jmp loop_f
        
        evol2:
            mov n, %ecx
            incl %ecx  
            mov $2, %edx 

            for2:
                cmp %ecx, sz
                jle loop_ev 
                mov (%edi, %ecx, 4), %ebx
                cmp $2, %ebx
                jge restore

                loop_f2:
                    incl %ecx
                    incl %edx 
                    cmpl n, %edx 
                    je nextl2
                    jmp for2 
                
                nextl2:
                    mov $2, %edx
                    add $2, %ecx
                    jmp for2 


            restore:
                mov $3, %eax
                subl %ebx, %eax
                mov %eax, (%edi, %ecx, 4)
                jmp loop_f2
    loop_ev:
        incl i
        jmp for_ev


    ex_ev: 
        ret 


count:
    mov %ecx, %eax
    sub n, %eax 
    call check 
    incl %eax 
    call check
    subl $2, %eax
    call check
    add n, %eax
    call check
    addl $2, %eax
    call check
    add n, %eax
    call check
    decl %eax
    call check
    decl %eax
    call check

    ret 


check: 
    mov (%edi, %eax, 4), %ebx
    cmp $1, %ebx 
    je inc_cnt
    cmp $3, %ebx
    je inc_cnt
    ret

    inc_cnt:
        incl cnt 
        ret 


    

