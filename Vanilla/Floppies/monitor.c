// WIRE MONITOR
// Lists the signals on the wire behind the terminal: item and value, up to 18 rows.

#define LINES 18
#define NUM_W 14

void number(int *at, int value, int width) {
    fill(at, 0, width);
    int *cell = at + width - 1;
    int negative = value < 0;
    if (negative)
        value = -value;
    do {
        *cell = '0' + value % 10;
        cell--;
        value = value / 10;
    } while (value);
    if (negative)
        *cell = '-';
}

void main() {
    fill(screen, 0, SCREEN_SIZE);
    print(&screen[0][1], "WIRE MONITOR");
    fill(screen[1], '─', SCREEN_W);

    for (;;) {
        int count = nsig();
        number(&screen[0][25], count, NUM_W);
        for (int row = 0; row < LINES; row++) {
            int *line = screen[row + 2];
            if (row < count) {
                int item = isig(row);
                iname(line + 1, item, 24);
                number(line + 25, sig(item), NUM_W);
            } else if (row == 0) {
                print(line + 1, "NO SIGNALS ON THE WIRE                ");
            } else {
                fill(line, 0, SCREEN_W);
            }
        }
        wait(5);
    }
}
