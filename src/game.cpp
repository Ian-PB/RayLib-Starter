#include "game.h"

Game::Game()
{
}

void Game::run()
{
    const float fps = 60.0f;
    const float timePerFrame = 1.0f / fps; // Equivalent to sf::seconds(1.0f / fps)
    float timeSinceLastUpdate = 0.0f;
    
    SetTargetFPS(fps); // Set the target FPS in raylib
    
    while (!WindowShouldClose()) // Equivalent to window.isOpen()
    {
        float frameTime = GetFrameTime(); // Time in seconds since last frame
        timeSinceLastUpdate += frameTime;

        // Update at the set frame rate (fps) using a fixed time step
        while (timeSinceLastUpdate > timePerFrame)
        {
            timeSinceLastUpdate -= timePerFrame;
            update(timePerFrame); // Call update with a fixed time step
        }

        draw(); // Draw as many frames as possible
    }
}


void Game::update(float t_deltaTime)
{
    sprintf(message, "%d", counter);
    
    test.setSpeed(t_deltaTime);

    counter++;
}


void Game::draw()
{
    BeginDrawing();

    

    ClearBackground(RAYWHITE);
    DrawText("Welcome to Raylib", 190, 200, 20, LIGHTGRAY);
    DrawText("Gameplay Programming I", 190, 220, 20, LIGHTGRAY);
    DrawText(message, 190, 240, 20, LIGHTGRAY);

    
    test.drawThing();


    EndDrawing();
}
