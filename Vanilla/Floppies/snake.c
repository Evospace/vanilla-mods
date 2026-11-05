// SNAKE
// Arrows turn, Enter starts. Food grows the snake by two.

#define W       SCREEN_W
#define RING_N  160
#define STEP    3
#define BODY    '█'
#define HEAD    '▓'
#define FOOD    '♦'

int  seed = 12345;
int  dir;
int  last;
int  head;
int  tail;
int  grow;
int  score;
int *ring[RING_N];

int random() {
    seed = seed * 6364136223846793005 + 1442695040888963407;
    return (seed >> 33) & 0x7FFFFFFF;
}

void food() {
    int *cell;
    do {
        int r = random();
        cell = &screen[2 + r % 17][1 + r / 17 % 38];
    } while (*cell);
    *cell = FOOD;
}

void show_score() {
    int *cell = &screen[0][38];
    int value = score;
    fill(&screen[0][31], 0, 8);
    do {
        *cell = '0' + value % 10;
        cell--;
        value = value / 10;
    } while (value);
}

void frame() {
    fill(screen, 0, SCREEN_SIZE);
    print(&screen[0][1], "SNAKE");
    print(&screen[0][25], "SCORE");
    fill(screen[1], '═', W);
    fill(screen[19], '═', W);
    screen[1][0] = '╔';
    screen[1][39] = '╗';
    screen[19][0] = '╚';
    screen[19][39] = '╝';
    for (int y = 2; y < 19; y++) {
        screen[y][0] = '║';
        screen[y][39] = '║';
    }
}

void wait_enter() {
    int k;
    while ((k = key()) != KEY_ENTER) {
        seed++;
        if (!k)
            wait(1);
    }
}

void play() {
    for (int y = 2; y < 19; y++)
        fill(&screen[y][1], 0, 38);
    int *mid = &screen[10][18];
    mid[0] = BODY;
    mid[1] = BODY;
    mid[2] = HEAD;
    ring[0] = mid;
    ring[1] = mid + 1;
    ring[2] = mid + 2;
    tail = 0;
    head = 2;
    dir = 1;
    last = 1;
    grow = 0;
    score = 0;
    food();
    show_score();

    for (;;) {
        wait(STEP);
        int k;
        while ((k = key())) {
            if (k == KEY_LEFT && last != 1)
                dir = -1;
            if (k == KEY_RIGHT && last != -1)
                dir = 1;
            if (k == KEY_UP && last != W)
                dir = -W;
            if (k == KEY_DOWN && last != -W)
                dir = W;
        }
        last = dir;

        int *p = ring[head];
        *p = BODY;
        p = p + dir;
        int cut = 0;
        if (*p == FOOD) {
            score++;
            grow++;
            food();
            show_score();
        } else if (*p) {
            return;
        } else if (grow) {
            grow--;
        } else {
            cut = 1;
        }
        if (cut || (head - tail + RING_N) % RING_N >= RING_N - 3) {
            *ring[tail] = 0;
            tail = (tail + 1) % RING_N;
        }
        head = (head + 1) % RING_N;
        ring[head] = p;
        *p = HEAD;
    }
}

void main() {
    frame();
    print(&screen[10][7], "ARROWS TURN, ENTER STARTS");
    for (;;) {
        wait_enter();
        play();
        print(&screen[10][7], " GAME OVER - PRESS ENTER ");
    }
}
