; SNAKE
; Arrows turn, Enter starts. Food grows the snake by two.

        .equ ROW, SCREEN_W
        .equ FIELD, SCREEN + ROW + ROW + 1
        .equ BOTTOM, SCREEN + 760
        .equ MIDDLE, SCREEN + 400
        .equ BODY_CELL, 219
        .equ HEAD_CELL, 178
        .equ FOOD_CELL, 4
        .equ RING, 64
        .equ RING_N, 160
        .equ STEP, 3
        .equ NUM_W, 8

title:  .text "SNAKE"
scoret: .text "SCORE"
help:   .text "ARROWS TURN, ENTER STARTS"
over:   .text " GAME OVER - PRESS ENTER "
seed:   .word 12345
dir:    .word 1
last:   .word 1
head:   .word 0
tail:   .word 0
grow:   .word 0
score:  .word 0
numbuf: .word 0, 0, 0, 0, 0, 0, 0, 0

start:
        fill  [SCREEN], 0, SCREEN_SIZE
        print [SCREEN + 1], [title], title_len
        print [SCREEN + 25], [scoret], scoret_len
        fill  [SCREEN + ROW], 205, ROW
        fill  [BOTTOM], 205, ROW
        st    [SCREEN + ROW], 201
        st    [SCREEN + ROW + 39], 187
        st    [BOTTOM], 200
        st    [BOTTOM + 39], 188
        mov   r1, SCREEN + ROW + ROW
side:
        st    [r1], 186
        st    [r1 + 39], 186
        add   r1, r1, ROW
        jlt   r1, BOTTOM, side
        print [MIDDLE + 7], [help], help_len

hold:
        ld    r0, [seed]
        add   r0, r0, 1
        st    [seed], r0
        key   r0
        jeq   r0, KEY_ENTER, begin
        jnz   r0, hold
        wait  1
        jmp   hold

begin:
        mov   r1, FIELD
clear:
        fill  [r1], 0, 38
        add   r1, r1, ROW
        jlt   r1, BOTTOM, clear
        st    [score], 0
        st    [grow], 0
        st    [dir], 1
        st    [last], 1
        st    [RING], MIDDLE + 18
        st    [RING + 1], MIDDLE + 19
        st    [RING + 2], MIDDLE + 20
        st    [tail], 0
        st    [head], 2
        st    [MIDDLE + 18], BODY_CELL
        st    [MIDDLE + 19], BODY_CELL
        st    [MIDDLE + 20], HEAD_CELL
        call  food
        call  shown

loop:
        wait  STEP
        ld    r1, [last]
input:
        key   r0
        jz    r0, move
        jeq   r0, KEY_LEFT, left
        jeq   r0, KEY_RIGHT, right
        jeq   r0, KEY_UP, up
        jeq   r0, KEY_DOWN, down
        jmp   input
left:
        jeq   r1, 1, input
        st    [dir], -1
        jmp   input
right:
        jeq   r1, -1, input
        st    [dir], 1
        jmp   input
up:
        jeq   r1, ROW, input
        st    [dir], -ROW
        jmp   input
down:
        jeq   r1, -ROW, input
        st    [dir], ROW
        jmp   input

move:
        ld    r1, [dir]
        st    [last], r1
        ld    r2, [head]
        ld    r3, [r2 + RING]
        st    [r3], BODY_CELL
        add   r3, r3, r1
        ld    r4, [r3]
        jeq   r4, FOOD_CELL, eat
        jnz   r4, dead
        ld    r5, [grow]
        jz    r5, cut
        sub   r5, r5, 1
        st    [grow], r5
        jmp   check
eat:
        ld    r5, [score]
        add   r5, r5, 1
        st    [score], r5
        ld    r5, [grow]
        add   r5, r5, 1
        st    [grow], r5
        call  food
        call  shown
check:
        ld    r5, [head]
        ld    r6, [tail]
        sub   r5, r5, r6
        jge   r5, 0, length
        add   r5, r5, RING_N
length:
        jlt   r5, RING_N - 3, advance
cut:
        ld    r5, [tail]
        ld    r6, [r5 + RING]
        st    [r6], 0
        add   r5, r5, 1
        jlt   r5, RING_N, cutok
        mov   r5, 0
cutok:
        st    [tail], r5
advance:
        add   r2, r2, 1
        jlt   r2, RING_N, headok
        mov   r2, 0
headok:
        st    [head], r2
        st    [r2 + RING], r3
        st    [r3], HEAD_CELL
        jmp   loop

dead:
        print [MIDDLE + 7], [over], over_len
deadkey:
        key   r0
        jeq   r0, KEY_ENTER, begin
        jnz   r0, deadkey
        wait  1
        jmp   deadkey

; food: a random empty cell of the field gets food; uses r0, r4, r5, r6
food:
        ld    r0, [seed]
        mul   r0, r0, 6364136223846793005
        add   r0, r0, 1442695040888963407
        st    [seed], r0
        shr   r4, r0, 33
        and   r4, r4, 0x7FFFFFFF
        mod   r5, r4, 17
        div   r4, r4, 17
        mod   r6, r4, 38
        mul   r5, r5, ROW
        add   r5, r5, r6
        add   r5, r5, FIELD
        ld    r6, [r5]
        jnz   r6, food
        st    [r5], FOOD_CELL
        ret

; shown: the score into the header; keeps r2 and r3
shown:
        push  r2
        ld    r0, [score]
        call  number
        copy  [SCREEN + 31], [numbuf], NUM_W
        pop   r2
        ret

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
