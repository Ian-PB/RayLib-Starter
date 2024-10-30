#include "raylib.h"
#include <stdio.h>

#include "./test.h"

class Game
{
public:
    Game();

    void run();

private:

    void update(float t_deltaTime);

    void draw();



    // Game Objects
    Test test;

    // Variables
    int counter = 0;
    char message[11];
};