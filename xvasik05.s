; Autor reseni: János László xvasik05

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xvasik05"  ; sem doplnte vas login
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
; xvasik05-r1-r20-r16-r28-r0-r4
; key1 = v
; key2 = a
                .text

                ; ZDE NAHRADTE KOD VASIM RESENIM
main:
                addi   r28, r0, 0 ; cycle counter (position of current char in string)
                addi   r20, r0, 0 ; even/odd counter (even = 0, odd = 1)

cycle:
                lb r1, login(r28)   ; load current char from login
                slti r16, r1, 97    ; slti dest, toComp, immediate --- if toComp < immediate -> dest = 1
                bne r16, r0, end    ; if char is lower than alphabet, jump to end
                beq r20, r0, even   ; jump to addition if on even indexed char

odd: ; subtract 1 (a) from every odd char
                addi r4, r0, 1
                sub r1, r1, r4
                slti r16, r1, 97 ; check if value is less than 97
                beq r16, r0, odd_end ; char in range, continue
                addi r4, r0, 97
                sub r1, r4, r1 ; else ensuring correct range of char
                addi r4, r0, 123
                sub r1, r4, r1
odd_end:
                addi r20, r0, 0 ;ensuring that the next char will be counted as even
                b rerun

even: ; add 22 (v) to every even char
                addi r1, r1, 22 ; addition
                slti r16, r1, 123 ; check if in range
                bne r16, r0, even_end ; if yes, start next cycle
                addi r4, r0, 122
                sub r1, r1, r4    ; ensuring correct range of char
                addi r1, r1, 96

even_end:
                addi r20, r0, 1 ; ensuring that the next char will be counted as odd

rerun:
                sb r1, cipher(r28) ; store byte in cypher
                addi r28, r28, 1 ; increment cycle counter
                b cycle

end:
                daddi r4, r0, cipher    ; put adress of result into r4
                jal     print_string    ; vypis pomoci print_string - viz nize
                syscall 0               ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
