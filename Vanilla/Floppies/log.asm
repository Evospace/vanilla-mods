; FIELD LOG
; Three pages of text; arrows or Enter turn them.

        .equ ROW, SCREEN_W
        .equ BOTTOM, SCREEN + 760
        .equ PAGES, 3

p1:     .text "EXPEDITION FIELD LOG\n\nDAY 1\nLANDED IN THE GREEN BASIN. SOIL IS\nGOOD, WATER IS CLOSE. THE BEACON IS UP\nAND CALLING HOME.\n\nDAY 4\nFOUND STONEWORK UNDER A HILL. THE\nBLOCKS ARE CUT CLEAN, BY NO TOOL WE\nKNOW. A STAIR GOES DOWN."
p2:     .text "DAY 6\nTHE CRYPT IS OLDER THAN THE RUINS\nABOVE IT. THE AIR INSIDE IS DRY AND\nSTILL.\n\nDAY 9\nNO ANSWER FROM HOME FOR THREE DAYS.\nTHE BEACON STILL TRANSMITS."
p3:     .text "DAY 12\nWE GO DOWN AGAIN TOMORROW. THIS DISK\nSTAYS AT THE ENTRANCE FOR WHOEVER\nCOMES NEXT.\n\nKEEP LISTENING."
foot:   .text " ARROWS TURN THE PAGE "
table:  .word p1, p1_len, p2, p2_len, p3, p3_len
page:   .word 0

show:
        fill  [SCREEN], 0, SCREEN_SIZE
        ld    r0, [page]
        add   r0, r0, r0
        ld    r1, [r0 + table]
        ld    r2, [r0 + table + 1]
        mov   r3, 0
        mov   r4, SCREEN
        mov   r5, SCREEN
chars:
        jge   r3, r2, footer
        div   r6, r3, 8
        add   r6, r6, r1
        ld    r6, [r6]
        mod   r0, r3, 8
        mul   r0, r0, 8
        shr   r6, r6, r0
        and   r6, r6, 255
        add   r3, r3, 1
        jeq   r6, 10, newline
        st    [r5], r6
        add   r5, r5, 1
        jmp   chars
newline:
        add   r4, r4, ROW
        mov   r5, r4
        jmp   chars

footer:
        fill  [BOTTOM], 196, ROW
        print [BOTTOM + 1], [foot], foot_len
        ld    r0, [page]
        add   r0, r0, '1'
        st    [BOTTOM + 33], 32
        st    [BOTTOM + 34], r0
        st    [BOTTOM + 35], '/'
        st    [BOTTOM + 36], '0' + PAGES
        st    [BOTTOM + 37], 32
keys:
        key   r0
        jz    r0, idle
        jeq   r0, KEY_RIGHT, next
        jeq   r0, KEY_DOWN, next
        jeq   r0, KEY_ENTER, next
        jeq   r0, KEY_LEFT, prev
        jeq   r0, KEY_UP, prev
        jmp   keys
idle:
        wait  2
        jmp   keys
next:
        ld    r0, [page]
        add   r0, r0, 1
        jge   r0, PAGES, keys
        st    [page], r0
        jmp   show
prev:
        ld    r0, [page]
        jz    r0, keys
        sub   r0, r0, 1
        st    [page], r0
        jmp   show
