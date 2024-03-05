.data
mx_rows : .long 20
mx_cols : .long 20
mx_sz : .long 400
sz : .space 4
sz_ext : .space 4

mat : .space 1600
m : .space 4
n : .space 4
p : .space 4
k : .space 4
temp : .space 4
cnt : .long 0
form_in3 : .asciz "%ld%ld%ld"
f_in2: .asciz "%ld%ld"
hex_0 : .asciz "%ld"
f_out : .asciz "%ld "
f_o : .asciz "%ld\n"
str_out : .asciz "%s\n"
str_in : .asciz "%s"
new_line : .asciz "\n"
f_in : .asciz "%ld"
in_s : .asciz "%s"
i : .long 0
j : .long 0
task : .long 0
pass : .space 1000
code : .space 8000
code_len : .long 0
key_len : .long 0
xor_code : .space 8000
key : .space 8000
pass_len : .space 4
msg : .space 1000
hi : .long 0
word_len : .long 0

hex_format : .asciz "%X"
hex_pref : .asciz "0x"


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

    pushl $p
    pushl $n
    pushl $m
    pushl $form_in3
    call scanf
    add $16, %esp
    xor %edx, %edx
    incl m
    incl n
    incl n 
    mov m, %eax
    mov n, %ebx
    mul %ebx
    add n, %eax 
    mov %eax, sz_ext
    sub n, %eax 
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
        call scanf
        addl $12, %esp
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
        call scanf
        add $8, %esp 
        popa
        call evolution 
        pusha 
        pushl $task
        pushl $f_in
        call scanf
        add $8, %esp 
        popa 
        mov task, %eax 
        cmpl $0, %eax 
        jne decr 
        call crypt 
        jmp fin 
    
    decr:
        call decrypt 





display:
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
            call printf
            add $8, %esp
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
            call printf
            add $4, %esp 
            popa 
            jmp for_write

fin:
    pushl $0
    call fflush
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


get_key:
    xor %ecx, %ecx 
    lea mat, %edi 
    lea key, %esi 
    for_key:
        cmp %ecx, sz_ext
        je ex_key 
        mov (%edi, %ecx, 4), %eax 
        addb $48, %al 
        movb %al, (%esi, %ecx, 1)
        incl %ecx 
        jmp for_key
    
    ex_key:
        ret 



crypt:
    pusha
    pushl $pass
    pushl $in_s
    call scanf
    add $8, %esp 
    popa 
    call slen 
    mov m, %eax
    mov n, %ebx 
    sub $2, %ebx 
    decl %eax 
    mul %ebx 
    mov %eax, key_len
    call get_key 
    call adjust_len
    call asci_code
    call make_xor 
    call print_xor 
    ret 


slen:
    xor %ecx, %ecx
    lea pass, %esi 
    
    for_slen:
        movb (%esi, %ecx, 1), %al 
        cmp $0, %al 
        je end_len 
        incl %ecx 
        jmp for_slen

    end_len:
        mov %ecx, code_len
        mov %ecx, pass_len
        ret 

mul8:
    mov code_len, %eax
    mov $8, %ebx 
    mul %ebx 
    mov %eax, code_len
    ret 

caller8:
    cmpl $0, task 
    je to_mul8
    mov code_len, %eax 
    sub $2, %eax 
    mov $4, %ebx 
    mul %ebx 
    mov %eax, code_len 
    ret
    to_mul8:
        call mul8 
        ret 


adjust_len:
    call caller8 
    lea key, %esi 
    mov sz_ext, %eax 
    mov %eax, key_len
    for_adj:
        mov key_len, %eax 
        cmpl code_len, %eax 
        jge ex_adj
        xor %ecx, %ecx 
        xor %ebx, %ebx 
        for_double:
            cmp %ecx, sz_ext
            je ex_double
            movb (%esi, %ecx, 1), %bl   
            mov %esi, %eax 
            add key_len, %eax 
            movb %bl, (%eax, %ecx, 1)
            incl %ecx 
            jmp for_double

        ex_double:
            mov key_len, %eax 
            add sz_ext, %eax 
            mov %eax, key_len 
            jmp for_adj

    ex_adj:
        ret 



make_xor:
    
    movl $0, i 
    lea key, %esi 
    lea code, %edi 
    lea xor_code, %ebx 

    for_xor:
        mov i, %ecx 
        cmp %ecx, code_len
        je ex_xor 
        xor %eax, %eax 
        xor %edx, %edx 
        movb (%edi, %ecx, 1), %al 
        movb (%esi, %ecx, 1), %dl

        
        subb $48, %al 
        subb $48, %dl  
        xorb %dl, %al 
        

        addb $48, %al 
        movb %al, (%ebx, %ecx, 1)
        incl i 
        jmp for_xor

    ex_xor:
        ret 


print_xor:
    
    mov $4, %eax 
    mov $1, %ebx 
    mov $hex_pref, %ecx
    mov $2, %edx 
    int $0x80

    xor %ecx, %ecx 
    lea xor_code, %esi 
    xor %ebx, %ebx 
    xor %eax, %eax 
    xor %edx, %edx 

    for_print:
        cmp %ecx, code_len
        je fin_print
        movb (%esi, %ecx, 1), %al
        subb $'0', %al
        shl $1, %edx 
        addb %al, %dl 
        incl %ebx 
        incl %ecx 
        cmp $4, %ebx 
        je next_byte
        jmp for_print 

        next_byte:
            pusha 
            pushl %edx 
            pushl $hex_format
            call printf 
            add $8, %esp 
            popa 
            xor %edx, %edx 
            xor %ebx, %ebx 
            jmp for_print
    
    fin_print:
        pusha 
        pushl $new_line
        pushl $in_s
        call printf 
        add $8, %esp 
        popa 

    ret 

asci_code:
    lea pass, %edi
    lea code, %esi 
    movl $0, i
    xor %ecx, %ecx 

    for_0:
        cmp %ecx, code_len
        je for_code
        movb $48, (%esi, %ecx, 1)
        incl %ecx 
        jmp for_0


    for_code:
        mov i, %ecx 
        cmp %ecx, pass_len
        je ex_code
        incl i 
        xor %eax, %eax 
        movb (%edi), %al
        incl %edi 

        xor %ecx, %ecx 
        add $7, %ecx  

        for_c2:
            cmp $0, %eax 
            je next_let 
            xor %edx, %edx
            mov $2, %ebx
            div %ebx 
            addb $48, %dl 
            movb %dl, (%esi, %ecx, 1)
            decl %ecx 
            jmp for_c2

    next_let:
        add $8, %esi 
        jmp for_code 

    ex_code:
        ret 
        

decrypt:
    pushl $pass 
    pushl $str_in
    call scanf 
    add $8, %esp 
    
    call hex_bin
    call slen 
    mov m, %eax
    mov n, %ebx 
    sub $2, %ebx 
    decl %eax 
    mul %ebx 
    mov %eax, key_len
    call get_key 
    call adjust_len
    call make_xor
    call get_msg

    pushl $msg
    pushl $str_out
    call printf 
    add $8, %esp 

    jmp fin 


hex_bin:

    lea pass, %esi
    lea code, %edi
    xor %ebx, %ebx 
    call fill_hex  
    mov $2, %ecx 

    for_conv:
        xor %eax, %eax 
        xor %edx, %edx
        movb (%esi, %ecx, 1), %bl
        cmp $0, %bl 
        je disp_hex
        cmp $'9', %bl
        jg by_ten
        subb $'0', %bl 
        addb %bl, %al 
        jmp to_bin

    by_ten:
        addb $10, %al
        subb $'A', %bl 
        addb %bl, %al 
        jmp to_bin

    to_bin:
        movl $3, hi

        for_bin:
            
            cmpb $0, %al 
            je next
            xor %edx, %edx 
            mov $2, %ebx 
            div %ebx
            addb $'0', %dl 
            mov hi, %ebx 
            movb %dl, (%edi, %ebx, 1)
            decl hi
            jmp for_bin


    next:
        add $4, %edi
        incl %ecx
        jmp for_conv


    disp_hex: 
        ret 
    
    fill_hex:
        xor %ecx, %ecx 
        for_fill2: 
            cmp $1000, %ecx 
            je ex_fill2 
            movb $'0', (%edi, %ecx, 1)
            incl %ecx 
            jmp for_fill2
        
        ex_fill2:
            ret 


get_msg:
    lea msg, %edi 
    lea xor_code, %esi 
    xor %ecx, %ecx 
    xor %eax, %eax 
    movl $0, j  
    movl $0, i

    for_msg:
        mov i, %ecx 
        cmp code_len, %ecx 
        je ex_msg
        movb (%esi, %ecx, 1), %bl 
        subb $'0', %bl 
        xor %edx, %edx
        movl $2, %ecx
        mul %ecx 
        addb %bl, %al 
        incl j 
        incl i 
        cmpl $8, j 
        je to_word 
        jmp for_msg

        to_word:
            movb %al, (%edi) 
            incl %edi 
            incl word_len 
            xor %eax, %eax 
            movl $0, j 
            jmp for_msg

    
    ex_msg:
        ret 

