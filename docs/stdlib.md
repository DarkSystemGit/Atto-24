# Atto-24 Standard Library

## Print Module
The print module provides functions to print numbers, ASCII characters, and strings.

- **sys.printNum**
  - Description: Prints a number.
  - Parameters: 
    - `int a` - The number to print.

- **sys.printAscii**
  - Description: Prints an ASCII character.
  - Parameters: 
    - `char a` - The ASCII value of the character to print.

- **sys.printString**
  - Description: Prints a string.
  - Parameters: 
    - `string* str` - The string to print.

## File Module
The file module provides functions for file I/O operations.

- **file.read**
  - Description: Reads a file.
  - Parameters: 
    - `string path` - The path of the file to read.
    - `char[]* addr` - The address to store to.

- **file.write**
  - Description: Writes to a file.
  - Parameters: 
    - `string path` - The path of the file to write to.
    - `double[]* data` - The data to write.
- **file.writeText**
  - Description: Writes to a text file.
  - Parameters: 
    - `string path` - The path of the file to write to.
    - `double[]* data` - The data to write.
- **file.readText**
  - Description: Reads a text file.
  - Parameters: 
    - `string path` - The path of the file to read.
    - `char[]* addr` - The address to store to.
- **file.getLength**
  - Description: Gets the length of a file in bytes. If the file was written to by `file.write`, devide the result by 8 to convert bytes to doubles.
  - Parameters: 
    - `string path` - The path of the file.
    - `register length` - The register to store the file length.

- **file.getLastModified**
  - Description: Gets the last modified time of a file.
  - Parameters: 
    - `string path` - The path of the file.
    - `register time` - The register to store the last modified time.

- **file.remove**
  - Description: Removes a file.
  - Parameters: 
    - `string path` - The path of the file to remove.

## Directory Module
The directory module provides functions for directory operations.

- **dir.mkdir**
  - Description: Creates a directory.
  - Parameters: 
    - `string path` - The path of the directory to create.

- **dir.rmdir**
  - Description: Removes a directory.
  - Parameters: 
    - `string path` - The path of the directory to remove.

- **dir.ls**
  - Description: Lists the contents of a directory.
  - Parameters: 
    - `string path` - The path of the directory.
    - `register addr` - The register to store the directory content.

- **dir.isDir**
  - Description: Checks if a path is a directory.
  - Parameters: 
    - `string path` - The path to check.
    - `register result` - The register to store the result (1 if directory, 0 otherwise).

## String Module
The string module provides functions to manipulate and handle strings.

- **str.len**
  - Description: Gets the length of a string.
  - Parameters: 
    - `string* str` - The string to measure.
    - `register ret` - The register to store the length.

- **str.join**
  - Description: Concatenates two strings.
  - Parameters: 
    - `string* str` - The first string.
    - `string* str2` - The second string.
    - `char[]* mempos` - Memory position to store the concatenated string.

- **str.copy**
  - Description: Copies a string.
  - Parameters: 
    - `string* str` - The source string.
    - `char[] mempos` - Memory position to store the copied string.
    - `int len` - Length of the string to copy.

- **str.cmp**
  - Description: Compares two strings.
  - Parameters: 
    - `string* str` - The first string.
    - `string* cmp` - The second string.
    - `register ret` - The register to store the comparison result (1 if equal, 0 otherwise).

- **str.substr**
  - Description: Extracts a substring.
  - Parameters: 
    - `string* str` - The source string.
    - `string* substr` - The substring to extract.
    - `int start` - Start position of the substring.
    - `int end` - End position of the substring.
    - `register ret` - The register to store the result.

- **str.split**
  - Description: Splits a string using a delimiter.
  - Parameters: 
    - `string* str` - The source string.
    - `string* delimiter` - The delimiter to split the string by.
    - `char[]* mempos` - Memory position to store the split strings.

## Memory Module
The memory module provides functions to manage memory allocation and manipulation.

- **mem.dump**
  - Description: Dumps memory content.
  - Parameters: None.

- **mem.malloc**
  - Description: Allocates memory.
  - Parameters: 
    - `int size` - Size of memory to allocate.
    - `register addr` - The register to store the allocated memory address.
    - `register id` - The register to store the memory ID.

- **mem.free**
  - Description: Frees allocated memory.
  - Parameters: 
    - `int id` - ID of the memory to free.

- **mem.copy**
  - Description: Copies memory from source to destination.
  - Parameters: 
    - `int src` - Source memory address.
    - `int dest` - Destination memory address.
    - `int size` - Size of memory to copy.

- **mem.fill**
  - Description: Fills memory with a value.
  - Parameters: 
    - `int addr` - Memory address.
    - `int len` - Length of memory to fill.
    - `int value` - Value to fill the memory with.

- **mem.castval**
  - Description: Casts a value to a specified type.
  - Parameters: 
    - `value` - The value to cast.
    - `type` - The type to cast to.

## Time Module
The time module handles operations related to time and date management.

- **time.new**
  - Description: Creates a new time object.
  - Parameters: 
    - `int id` - The ID for the new time object.

- **time.set**
  - Description: Sets the time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `int hr` - The hour to set.
    - `int min` - The minute to set.
    - `int sec` - The second to set.

- **time.setUnix**
  - Description: Sets Unix time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `int unixTime` - The Unix timestamp to set.

- **time.setStd**
  - Description: Sets standard time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `long stdTime` - The standard time to set.

- **time.getStd**
  - Description: Gets standard time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `register reg` - The register to store the standard time.

- **time.getUnix**
  - Description: Gets Unix time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `register reg` - The register to store the Unix time.

- **time.getDateTime**
  - Description: Gets date and time.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `register reg` - The register to store the date and time.

- **time.setDate**
  - Description: Sets the date.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `int year` - The year to set.
    - `int month` - The month to set.
    - `int day` - The day to set.

- **time.setUTCOffset**
  - Description: Sets UTC offset.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `int offset` - The UTC offset to set.

- **time.getUTCOffset**
  - Description: Gets UTC offset.
  - Parameters: 
    - `int id` - The ID of the time object.
    - `register reg` - The register to store the UTC offset.

- **time.add**
  - Description: Adds time.
  - Parameters: 
    - `int id1` - The ID of the first time object.
    - `int id2` - The ID of the second time object.

- **time.sub**
  - Description: Subtracts time.
  - Parameters: 
    - `int id1` - The ID of the first time object.
    - `int id2` - The ID of the second time object.

- **time.setToCurrent**
  - Description: Sets time to the current time.
  - Parameters: 
    - `int id` - The ID of the time object.

- **time.setGMT**
  - Description: Sets GMT time.
  - Parameters: 
    - `int id` - The ID of the time object.

- **time.free**
  - Description: Frees a time object.
  - Parameters: 
    - `int id` - The ID of the time object to free.

## Random Module
The random module provides functions to handle random number generation and distributions.

- **random.new**
  - Description: Creates a new random number generator.
  - Parameters: 
    - `int seed` - The seed for the random number generator.
    - `register id` - The register to store the random number generator ID.

- **random.setSeed**
  - Description: Sets the seed for the random number generator.
  - Parameters: 
    - `int seed` - The new seed.

- **random.get**
  - Description: Gets a random number.
  - Parameters: 
    - `register num` - The register to store the random number.

- **random.setDistribution**
  - Description: Sets the distribution for the random number generator.
  - Parameters: 
    - `int id` - The ID of the random number generator.
    - `int distId` - The ID of the distribution.

- **randomDistrubution.new**
  - Description: Creates a new random distribution.
  - Parameters: 
    - `register id` - The register to store the distribution ID.

- **randomDistrubution.setProbibilities**
  - Description: Sets the probabilities for a distribution.
  - Parameters: 
    - `int id` - The ID of the distribution.
    - `double[] probs` - The probabilities.

- **randomDistrubution.setUniform**
  - Description: Sets a uniform distribution.
  - Parameters: 
    - `int id` - The ID of the distribution.
    - `int min` - The minimum value.
    - `int max` - The maximum value.

- **random.free**
  - Description: Frees a random number generator.
  - Parameters: 
    - `int id` - The ID of the random number generator.

- **randomDistrubution.free**
  - Description: Frees a random distribution.
  - Parameters: 
    - `int id` - The ID of the distribution.

## Graphics Module
The graphics module provides functions for graphical operations and handling.

- **gfx.new**
  - Description: Initializes the graphics system.
  - Parameters: 
    - `string title` - The title of the window.
    - `int vramAddr` - The VRAM address.

- **gfx.getVRAMBuffer**
  - Description: Gets the VRAM buffer.
  - Parameters: 
    - `register addr` - The register to store the VRAM buffer address.
    - `register id` - The register to store the buffer ID.

- **gfx.free**
  - Description: Frees the graphics system.
  - Parameters: None.

- **gfx.render**
  - Description: Renders the graphics.
  - Parameters: None.

- **gfx.setPalette**
  - Description: Sets the color palette.
  - Parameters: 
    - `int addr` - The address of the palette.

- **gfx.getPressedKeys**
  - Description: Gets the currently pressed keys.
  - Parameters: 
    - `register addr` - The register to store the pressed keys.

- **gfx.windowClosed**
  - Description: Checks if the window is closed.
  - Parameters: 
    - `register result` - The register to store the result (1 if closed, 0 otherwise).

- **gfx.keys.up**
  - Description: Key for moving up.

- **gfx.keys.down**
  - Description: Key for moving down.

- **gfx.keys.left**
  - Description: Key for moving left.

- **gfx.keys.right**
  - Description: Key for moving right.

- **gfx.keys.z**
  - Description: Key for action Z.

- **gfx.keys.x**
  - Description: Key for action X.

- **gfx.sprite.new**
  - Description: Creates a new sprite.
  - Parameters: 
    - `int addr` - The address of the sprite.
    - `int x` - The x-coordinate.
    - `int y` - The y-coordinate.
    - `int angle` - The angle.
    - `ubyte[64]* pixels` - The pixel data.

- **gfx.sprite.resize**
  - Description: Resizes a sprite.
  - Parameters: 
    - `int addr` - The address of the sprite.
    - `int width` - The new width.
    - `int height` - The new height.

- **gfx.sprite.scale**
  - Description: Scales a sprite.
  - Parameters: 
    - `int addr` - The address of the sprite.
    - `int scaleX` - The scale factor for x.
    - `int scaleY` - The scale factor for y.

- **gfx.sprite.render**
  - Description: Renders a sprite.
  - Parameters: 
    - `int addr` - The address of the sprite.

- **gfx.sprite.free**
  - Description: Frees a sprite.
  - Parameters: 
    - `int addr` - The address of the sprite.

- **gfx.tilemap.new**
  - Description: Creates a new tilemap.
  - Parameters: 
    - `int addr` - The address of the tilemap.
    - `int x` - The x-coordinate.
    - `int y` - The y-coordinate.
    - `ubyte[80*60]* tilelist` - The tile list.
    - `(ubyte[512]*)[64]* tileset` - The tileset.
    - `int width` - The width.
    - `int height` - The height.

- **gfx.tilemap.render**
  - Description: Renders a tilemap.
  - Parameters: 
    - `int addr` - The address of the tilemap.

- **gfx.tilemap.blit**
  - Description: Blits a tilemap.
  - Parameters: 
    - `int addr` - The address of the tilemap.

- **gfx.tileset.setTile**
  - Description: Sets a tile in a tileset.
  - Parameters: 
    - `int addr` - The address of the tileset.
    - `int id` - The tile ID.
    - `ubyte[64]* tile` - The tile data.

- **gfx.tilemap.free**
  - Description: Frees a tilemap.
  - Parameters: 
    - `int addr` - The address of the tilemap.

## Array Module
The array module provides functions to manage and manipulate arrays.

- **array.new**
  - Description: Creates a new array.
  - Parameters: 
    - `int length` - The length of the array.
    - `register addr` - The register to store the array address.

- **array.dynamic.new**
  - Description: Creates a new dynamic array.
  - Parameters: 
    - `int length` - The length of the array.
    - `register addr` - The register to store the array address.

- **array.getBody**
  - Description: Gets the body of an array.
  - Parameters: 
    - `array* arr` - The array.
    - `register addr` - The register to store the body address.

- **array.capacity**
  - Description: Gets the capacity of an array.
  - Parameters: 
    - `array* arr` - The array.
    - `register addr` - The register to store the capacity.

- **array.data**
  - Description: Gets the data of an array.
  - Parameters: 
    - `array* arr` - The array.
    - `register addr` - The register to store the data.

- **array.length**
  - Description: Gets the length of an array.
  - Parameters: 
    - `array* arr` - The array.
    - `register addr` - The register to store the length.

- **array.push**
  - Description: Pushes an element to an array.
  - Parameters: 
    - `array* arr` - The array.
    - `double data` - The data to push.

- **array.pop**
  - Description: Pops an element from an array.
  - Parameters: 
    - `array* arr` - The array.
    - `int pos` - The position to pop from.
    - `register ret` - The register to store the popped element.

- **array.slice**
  - Description: Slices an array.
  - Parameters: 
    - `array* arr` - The array.
    - `int start` - The start position.
    - `int end` - The end position.
    - `register addr` - The register to store the sliced array.

- **array.splice**
  - Description: Splices an array.
  - Parameters: 
    - `array* arr` - The array.
    - `int start` - The start position.
    - `int end` - The end position.
    - `register addr` - The register to store the spliced array.

- **array.insert**
  - Description: Inserts an element into an array.
  - Parameters: 
    - `array* arr` - The array.
    - `int pos` - The position to insert at.
    - `array* data` - The data to insert.

- **array.print**
  - Description: Prints an array.
  - Parameters: 
    - `array* arr` - The array.

- **array.set**
  - Description: Sets an element in an array.
  - Parameters: 
    - `array* arr` - The array.
    - `int pos` - The position to set.
    - `double val` - The value to set.

- **array.get**
  - Description: The register to store the retrieved element.
  - Parameters: 
    - `array* arr` - The array.
    - `int pos` - The position to get.
    - `register ret` - The register to store the retrieved element.

- **array.concat**
  - Description: Concatenates two arrays.
  - Parameters: 
    - `array* orig` - The original array.
    - `array* joined` - The array to concatenate.

- **array.dynamic.free**
  - Description: Frees a dynamic array.
  - Parameters: 
    - `array* arr` - The array to free.

- **array.free**
  - Description: Frees an array.
  - Parameters: 
    - `array* arr` - The array to free.

## Math Module
The math module provides mathematical functions and operations.

- **math.abs**
  - Description: Computes the absolute value.
  - Parameters: 
    - `int val` - The value to compute the absolute value of.
    - `register r` - The register to store the result.

- **math.sqrt**
  - Description: Computes the square root.
  - Parameters: 
    - `int val` - The value to compute the square root of.
    - `register r` - The register to store the result.

- **math.cbrt**
  - Description: Computes the cube root.
  - Parameters: 
    - `int val` - The value to compute the cube root of.
    - `register r` - The register to store the result.

- **math.hypot**
  - Description: Computes the hypotenuse.
  - Parameters: 
    - `int val1` - The first value.
    - `int val2` - The second value.
    - `register r` - The register to store the result.

- **math.sin**
  - Description: Computes the sine.
  - Parameters: 
    - `int val` - The value to compute the sine of.
    - `register r` - The register to store the result.

- **math.cos**
  - Description: Computes the cosine.
  - Parameters: 
    - `int val` - The value to compute the cosine of.
    - `register r` - The register to store the result.

- **math.tan**
  - Description: Computes the tangent.
  - Parameters: 
    - `int val` - The value to compute the tangent of.
    - `register r` - The register to store the result.

- **math.asin**
  - Description: Computes the arcsine.
  - Parameters: 
    - `int val` - The value to compute the arcsine of.
    - `register r` - The register to store the result.

- **math.acos**
  - Description: Computes the arccosine.
  - Parameters: 
    - `int val` - The value to compute the arccosine of.
    - `register r` - The register to store the result.

- **math.atan**
  - Description: Computes the arctangent.
  - Parameters: 
    - `int val` - The value to compute the arctangent of.
    - `register r` - The register to store the result.

- **math.ceil**
  - Description: Computes the ceiling value.
  - Parameters: 
    - `int val` - The value to compute the ceiling of.
    - `register r` - The register to store the result.

- **math.floor**
  - Description: Computes the floor value.
  - Parameters: 
    - `int val` - The value to compute the floor of.
    - `register r` - The register to store the result.

- **math.round**
  - Description: Rounds a value.
  - Parameters: 
    - `int val` - The value to round.
    - `register r` - The register to store the result.

- **math.int**
  - Description: Converts a value to an integer.
  - Parameters: 
    - `int val` - The value to convert.
    - `register r` - The register to store the result.

- **math.pow**
  - Description: Computes the power of a value.
  - Parameters: 
    - `int val` - The base value.
    - `int exp` - The exponent value.
    - `register r` - The register to store the result.

- **math.log**
  - Description: Computes the logarithm.
  - Parameters: 
    - `int val` - The value to compute the logarithm of.
    - `register r` - The register to store the result.

- **math.finite**
  - Description: Checks if a value is finite.
  - Parameters: 
    - `int val` - The value to check.
    - `register r` - The register to store the result.