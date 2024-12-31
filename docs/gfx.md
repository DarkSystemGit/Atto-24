# Graphics Module Documentation

The graphics module provides functions for graphical operations and handling. This documentation includes details of the functions and data structures used in the graphics module.

## Functions

- **gfx.new**

  - Description: Initializes the graphics system by creating a new window with the specified title and setting up the VRAM address.
  - Parameters:
    - `int vramAddr` - The VRAM address where the graphics data will be stored.

- **gfx.getVRAMBuffer**

  - Description: Allocates and returns the VRAM buffer for the graphics system. This buffer is used to store pixel data for rendering.
  - Parameters:
    - `register addr` - The register to store the VRAM buffer address.
    - `register id` - The register to store the buffer ID.

- **gfx.free**

  - Description: Frees the resources allocated by the graphics system, effectively shutting down the graphics subsystem.
  - Parameters: None.

- **gfx.render**

  - Description: Renders the current graphics buffer to the screen. This function must be called to display any changes made to the VRAM buffer.
  - Parameters: None.

- **gfx.setPalette**

  - Description: Sets the color palette used by the graphics system. The palette is an array of colors that will be used to render the graphics.
  - Parameters:
    - `int addr` - The address of the palette data in memory.

- **gfx.getPressedKeys**

  - Description: Retrieves the currently pressed keys from the input system and stores them in the specified register.
  - Parameters:
    - `register addr` - The register to store the pressed keys.

- **gfx.windowClosed**

  - Description: Checks if the graphics window has been closed by the user.
  - Parameters:
    - `register result` - The register to store the result (1 if closed, 0 otherwise).

- **gfx.keys.up**

  - Description: Key for moving up in the graphics window.

- **gfx.keys.down**

  - Description: Key for moving down in the graphics window.

- **gfx.keys.left**

  - Description: Key for moving left in the graphics window.

- **gfx.keys.right**

  - Description: Key for moving right in the graphics window.

- **gfx.keys.z**

  - Description: Key for action Z in the graphics window.

- **gfx.keys.x**

  - Description: Key for action X in the graphics window.

- **gfx.sprite.new**

  - Description: Creates a new sprite with the specified properties. Sprites are used for rendering individual graphical elements on the screen.
  - Parameters:
    - `int addr` - The address of the sprite data.
    - `int x` - The x-coordinate of the sprite.
    - `int y` - The y-coordinate of the sprite.
    - `int angle` - The rotation angle of the sprite.
    - `ubyte[64]* pixels` - The pixel data for the sprite.

- **gfx.sprite.resize**

  - Description: Resizes the specified sprite to the given dimensions.
  - Parameters:
    - `int addr` - The address of the sprite data.
    - `int width` - The new width of the sprite.
    - `int height` - The new height of the sprite.

- **gfx.sprite.scale**

  - Description: Scales the specified sprite by the given factors along the x and y axes.
  - Parameters:
    - `int addr` - The address of the sprite data.
    - `int scaleX` - The scale factor for the x-axis.
    - `int scaleY` - The scale factor for the y-axis.

- **gfx.sprite.render**

  - Description: Renders the specified sprite to the screen at its current position and rotation.
  - Parameters:
    - `int addr` - The address of the sprite data.

- **gfx.sprite.free**

  - Description: Frees the memory allocated for the specified sprite.
  - Parameters:
    - `int addr` - The address of the sprite data.

- **gfx.tilemap.new**

  - Description: Creates a new tilemap with the specified properties. Tilemaps are used for rendering large, grid-based graphical elements.
  - Parameters:
    - `int addr` - The address of the tilemap data.
    - `int x` - The x-coordinate of the tilemap.
    - `int y` - The y-coordinate of the tilemap.
    - `ubyte[80*60]* tilelist` - The list of tiles in the tilemap.
    - `(ubyte[512]*)[64]* tileset` - The tileset used for the tilemap.
    - `int width` - The width of the tilemap.
    - `int height` - The height of the tilemap.

- **gfx.tilemap.render**

  - Description: Renders the specified tilemap to the screen.
  - Parameters:
    - `int addr` - The address of the tilemap data.

- **gfx.tilemap.blit**

  - Description: Blits the specified tilemap to the screen. This function is used to copy a portion of the tilemap to a different location on the screen.
  - Parameters:
    - `int addr` - The address of the tilemap data.

- **gfx.tileset.setTile**

  - Description: Sets a tile in the specified tileset.
  - Parameters:
    - `int addr` - The address of the tileset data.
    - `int id` - The ID of the tile to set.
    - `ubyte[64]* tile` - The tile data.

- **gfx.tilemap.free**
  - Description: Frees the memory allocated for the specified tilemap.
  - Parameters:
    - `int addr` - The address of the tilemap data.

## Data Structures

### GFX

Represents the graphics system.

```d
class GFX {
    string title; // Title of the graphics window
    int[] screenDims; // Screen dimensions [width, height]
    uint[] palette; // Color palette used for rendering
    ubyte[] pixels; // Array of pixels representing the screen
    string[] events; // List of events (e.g., key presses, window close)
}
```

### Sprite

Represents a sprite in the graphics system.

```d
struct Sprite {
    int x; // X-coordinate of the sprite
    int y; // Y-coordinate of the sprite
    float angle; // Rotation angle of the sprite
    ubyte[] pixels; // Pixel data of the sprite
    uint[] scaledDims; // Scaled dimensions of the sprite [width, height]
}
```

### TileMap

Represents a tilemap in the graphics system.

```d
class Tilemap {
    int x; // X-coordinate of the tilemap
    int y; // Y-coordinate of the tilemap
    ubyte[80*60]* tilelist; // List of tiles in the tilemap
    (ubyte[512]*)[64] tileset; // Tileset used for the tilemap
    int width; // Width of the tilemap
    int height; // Height of the tilemap
}
```

This document provides a comprehensive overview of the graphics module, including functions and data structures used for graphical operations.
