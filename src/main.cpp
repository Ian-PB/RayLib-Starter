#include "raylib.h"
#include <stdio.h>

#include "./game.h"




int main(void) 
{
    InitWindow(800, 600, "Raylib StarterKit GPPI");

    //  Game loop
    while (!WindowShouldClose()) 
    {
        Game game;
        game.run();   
    }

    CloseWindow();

    return 0;
}
