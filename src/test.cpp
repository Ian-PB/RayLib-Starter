#include "raylib.h"
#include <stdio.h>
#include "test.h"

void Test::drawThing()
{
    Vector2 position = {1, 1};
    // Position, Radius, Colour
    DrawCircleV(position, 50, BLUE);
}