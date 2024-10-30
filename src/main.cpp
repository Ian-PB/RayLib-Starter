#include "raylib.h"
#include <stdio.h>

#include "./include/test.h"


int main(void) {
    InitWindow(800, 600, "Raylib StarterKit GPPI");

    int counter = 0;
    char message[11];

    //  Game loop
    while (!WindowShouldClose()) 
    {
        BeginDrawing();


        ClearBackground(RAYWHITE);
        DrawText("Welcome to Raylib", 190, 200, 20, LIGHTGRAY);
        DrawText("Gameplay Programming I", 190, 220, 20, LIGHTGRAY);
        sprintf(message, "%d", counter);
        DrawText(message, 190, 240, 20, LIGHTGRAY);

        Test test;
        test.drawThing();


        EndDrawing();
        counter++;
    }

    CloseWindow();

    return 0;
}
