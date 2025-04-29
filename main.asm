; x86 Assembly program implementing 10 algorithms as subroutines
; Algorithms: Bubble Sort, Binary Search, Factorial, Fibonacci, GCD, String Length,
; String Reverse, Power, Sum Array, Prime Check
; 32-bit Linux, NASM syntax

section .data
    ; Bubble Sort data
    bubble_array dd 64, 34, 25, 12, 22, 11, 90
    bubble_len equ ($ - bubble_array) / 4

    ; Binary Search data
    bin_array dd 1, 3, 5, 7, 9, 11, 13
    bin_len equ ($ - bin_array) / 4
    bin_target dd 7

    ; Factorial data
    fact_n dd 5

    ; Fibonacci data
    fib_n dd 10

    ; GCD data
    gcd_a dd 48
    gcd_b dd 18

    ; String Length and Reverse data
    str db "Hello", 0

    ; Power data
    power_base dd 2
    power_exp dd 3

    ; Sum Array data
    sum_array dd 1, 2, 3, 4, 5
    sum_len equ ($ - sum_array) / 4

    ; Prime Check data
    prime_n dd 17

    ; Results storage
    bubble_result dd 0
    bin_result dd 0
    fact_result dd 0
    fib_result dd 0
    gcd_result dd 0
    strlen_result dd 0
    strrev_result db 10 dup(0)
    power_result dd 0
    sum_result dd 0
    prime_result dd 0

section .text
global _start

; Bubble Sort: Sorts array in ascending order
bubble_sort:
    push ebp
    mov ebp, esp
    mov ecx, bubble_len
    dec ecx
outer_loop:
    mov ebx, 0
    mov esi, 0
inner_loop:
    mov eax, [bubble_array + esi*4]
    cmp eax, [bubble_array + esi*4 + 4]
    jle no_swap
    mov edx, [bubble_array + esi*4 + 4]
    mov [bubble_array + esi*4], edx
    mov [bubble_array + esi*4 + 4], eax
    mov ebx, 1
no_swap:
    inc esi
    cmp esi, ecx
    jl inner_loop
    test ebx, ebx
    jnz outer_loop
    mov esp, ebp
    pop ebp
    ret

; Binary Search: Finds target in sorted array, returns index or -1
binary_search:
    push ebp
    mov ebp, esp
    xor eax, eax
    mov ebx, bin_len
    dec ebx
search_loop:
    cmp eax, ebx
    jg not_found
    mov ecx, eax
    add ecx, ebx
    shr ecx, 1
    mov edx, [bin_array + ecx*4]
    cmp edx, [bin_target]
    je found
    jl search_right
    mov ebx, ecx
    dec ebx
    jmp search_loop
search_right:
    mov eax, ecx
    inc eax
    jmp search_loop
found:
    mov eax, ecx
    jmp end_search
not_found:
    mov eax, -1
end_search:
    mov [bin_result], eax
    mov esp, ebp
    pop ebp
    ret

; Factorial: Computes n!
factorial:
    push ebp
    mov ebp, esp
    mov eax, 1
    mov ecx, [fact_n]
fact_loop:
    cmp ecx, 0
    je end_fact
    mul ecx
    dec ecx
    jmp fact_loop
end_fact:
    mov [fact_result], eax
    mov esp, ebp
    pop ebp
    ret

; Fibonacci: Computes nth Fibonacci number
fibonacci:
    push ebp
    mov ebp, esp
    mov ecx, [fib_n]
    cmp ecx, 0
    je fib_zero
    cmp ecx, 1
    je fib_one
    mov eax, 0
    mov ebx, 1
    mov edx, 2
fib_loop:
    mov esi, eax
    add esi, ebx
    mov eax, ebx
    mov ebx, esi
    inc edx
    cmp edx, ecx
    jle fib_loop
    mov eax, ebx
    jmp end_fib
fib_zero:
    xor eax, eax
    jmp end_fib
fib_one:
    mov eax, 1
end_fib:
    mov [fib_result], eax
    mov esp, ebp
    pop ebp
    ret

; GCD: Computes GCD of a and b using Euclidean algorithm
gcd:
    push ebp
    mov ebp, esp
    mov eax, [gcd_a]
    mov ebx, [gcd_b]
gcd_loop:
    cmp ebx, 0
    je end_gcd
    xor edx, edx
    div ebx
    mov eax, ebx
    mov ebx, edx
    jmp gcd_loop
end_gcd:
    mov [gcd_result], eax
    mov esp, ebp
    pop ebp
    ret

; String Length: Computes length of null-terminated string
strlen:
    push ebp
    mov ebp, esp
    mov esi, str
    xor eax, eax
strlen_loop:
    cmp byte [esi], 0
    je end_strlen
    inc eax
    inc esi
    jmp strlen_loop
end_strlen:
    mov [strlen_result], eax
    mov esp, ebp
    pop ebp
    ret

; String Reverse: Reverses a null-terminated string in place
strrev:
    push ebp
    mov ebp, esp
    mov esi, str
    xor ecx, ecx
find_end:
    cmp byte [esi], 0
    je reverse
    inc ecx
    inc esi
    jmp find_end
reverse:
    dec esi
    mov edi, str
    shr ecx, 1
reverse_loop:
    mov al, [edi]
    mov bl, [esi]
    mov [esi], al
    mov [edi], bl
    inc edi
    dec esi
    loop reverse_loop
    mov esp, ebp
    pop ebp
    ret

; Power: Computes base^exp
power:
    push ebp
    mov ebp, esp
    mov eax, 1
    mov ecx, [power_exp]
    mov ebx, [power_base]
power_loop:
    cmp ecx, 0
    je end_power
    mul ebx
    dec ecx
    jmp power_loop
end_power:
    mov [power_result], eax
    mov esp, ebp
    pop ebp
    ret

; Sum Array: Computes sum of array elements
sum_array_proc:
    push ebp
    mov ebp, esp
    xor eax, eax
    mov ecx, sum_len
    mov esi, 0
sum_loop:
    add eax, [sum_array + esi*4]
    inc esi
    loop sum_loop
    mov [sum_result], eax
    mov esp, ebp
    pop ebp
    ret

; Prime Check: Returns 1 if n is prime, 0 otherwise
prime_check:
    push ebp
    mov ebp, esp
    mov eax, [prime_n]
    cmp eax, 1
    jle not_prime
    cmp eax, 2
    je is_prime
    mov ebx, 2
prime_loop:
    mov edx, 0
    div ebx
    cmp edx, 0
    je not_prime
    mov eax, [prime_n]
    inc ebx
    cmp ebx, eax
    jl prime_loop
is_prime:
    mov eax, 1
    jmp end_prime
not_prime:
    xor eax, eax
end_prime:
    mov [prime_result], eax
    mov esp, ebp
    pop ebp
    ret

; Main entry point
_start:
    ; Call each algorithm
    call bubble_sort
    call binary_search
    call factorial
    call fibonacci
    call gcd
    call strlen
    call strrev
    call power
    call sum_array_proc
    call prime_check

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
