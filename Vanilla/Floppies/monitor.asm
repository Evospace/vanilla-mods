; WIRE MONITOR
; Lists the signals on the wire behind the terminal: item and value, up to 18 rows.

        .equ ROW, SCREEN_W
        .equ LIST, SCREEN + ROW + ROW
        .equ LINES, 18
        .equ NUM_W, 14

title:  .text "WIRE MONITOR"
none:   .text "NO SIGNALS ON THE WIRE                "
numbuf: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

start:
        fill  [SCREEN], 0, SCREEN_SIZE
        print [SCREEN + 1], [title], title_len
        fill  [SCREEN + ROW], 196, ROW

frame:
        nsig  r5
        mov   r0, r5
        call  number
        copy  [SCREEN + 25], [numbuf], NUM_W
        mov   r6, 0
rows:
        jge   r6, LINES, rest
        mul   r3, r6, ROW
        add   r3, r3, LIST
        jge   r6, r5, blank
        isig  r2, r6
        iname [r3 + 1], r2, 24
        sig   r0, r2
        call  number
        copy  [r3 + 25], [numbuf], NUM_W
        jmp   next
blank:
        jnz   r6, clear
        print [r3 + 1], [none], none_len
        jmp   next
clear:
        fill  [r3], 0, ROW
next:
        add   r6, r6, 1
        jmp   rows
rest:
        wait  5
        jmp   frame

; number: r0 -> decimal, right-aligned in numbuf; uses r1, r2, r4
number:
        fill  [numbuf], 0, NUM_W
        mov   r1, numbuf + NUM_W - 1
        mov   r4, 0
        jge   r0, 0, digit
        mov   r4, 1
        sub   r0, 0, r0
digit:
        mod   r2, r0, 10
        add   r2, r2, '0'
        st    [r1], r2
        sub   r1, r1, 1
        div   r0, r0, 10
        jnz   r0, digit
        jz    r4, done
        st    [r1], '-'
done:
        ret
