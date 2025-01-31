# Graphics Module Documentation

The graphics module provides functions for graphical operations and handling. This documentation includes details of the functions and data structures used in the graphics module.

## Functions

- **gfx.new**

  - Description: Initializes the graphics system.
  - Parameters: None.



- **gfx.free**

  - Description: Frees the resources allocated by the graphics system, effectively shutting down the graphics subsystem.
  - Parameters: None.

- **gfx.render**

  - Description: Renders the current graphics buffer to the screen. This function must be called to display any changes made to the VRAM buffer.
  - Parameters: None.

- **gfx.setPalette**

  - Description: Sets the color palette used by the graphics system. The palette is an array of colors that will be used to render the graphics. The maximum amount of colors that can be use in a palette is 256.
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

  - Description: Creates a new tilemap with the specified properties. Tilemaps are used for rendering large, grid-based graphical elements. A tileset is a 512 long array of 8 by 8 tiles.
  - Parameters:
    - `int addr` - The address of the tilemap data.
    - `int x` - The x-coordinate of the tilemap.
    - `int y` - The y-coordinate of the tilemap.
    - `ubyte[width*height]* tilelist` - The list of tiles in the tilemap.
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

  - Description: Sets a 8x8 tile in the specified tileset.
  - Parameters:
    - `int addr` - The address of the tileset data.
    - `int id` - The ID of the tile to set.
    - `ubyte[64]* tile` - The tile data.

- **gfx.tilemap.free**
  - Description: Frees the memory allocated for the specified tilemap.
  - Parameters:
    - `int* addr` - The address of the tilemap data.
- **gfx.readVRAM**
  - Description: Reads a byte from VRAM.
  - Parameters:
    - `int addr` - The address of the data.
- **gfx.writeVRAM**
  - Description: Writes a byte to VRAM.
  - Parameters:
    - `int data` - The byte to write.
    - `int* addr` - The address to write to.
- **gfx.copyRectVRAM** 
  - Description: Copies an area of memory to VRAM.
  - Parameters:
    - `int[]* src` - Data to copy.
    - `int width` - Width of area.
    - `int height` - Height of area.
    - `int x` - X coord to copy to.
    - `int y` - Y coord to copy to.
- **gfx.copyVRAMtoRAM**
  - Description: Copies an area of VRAM to RAM.
  - Parameters:
    - `int width` - Width of area.
    - `int height` - Height of area.
    - `int x` - X coord to copy from.
    - `int y` - Y coord to copy from.
    - `register addr` - Register to set with copied address.
- **gfx.fillVRAM**
  - Description: Fills a area of VRAM
  - Parameters:
    - `int color` - Color to fill with.
    - `int width` - Width of area.
    - `int height` - Height of area.
    - `int x` - X coord to copy to.
    - `int y` - Y coord to copy to.
- **gfx.savePalette**

  - Description: Saves the current color palette to a specified slot.
  - Parameters:
    - `int slot` - The slot to save the palette to.

- **gfx.loadPalette**
  - Description: Loads a color palette from a specified slot.
  - Parameters:
    - `int slot` - The slot to load the palette from.
## Data Structures


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

### Tilemap

Represents a tilemap in the graphics system.

```d
class Tilemap {
    int x; // X-coordinate of the tilemap
    int y; // Y-coordinate of the tilemap
    ubyte[width*height]* tilelist; // List of tiles in the tilemap
    (ubyte[512]*)[64] tileset; // Tileset used for the tilemap
    int width; // Width of the tilemap
    int height; // Height of the tilemap
}
```

