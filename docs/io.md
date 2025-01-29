# Atto-24 IO
Standard libary functions for IO.
## IO Module
The IO module provides functions for IO.

- **io.printNum**
  - Description: Prints a number.
  - Parameters: 
    - `int a` - The number to print.

- **io.printASCII**
  - Description: Prints an ASCII character.
  - Parameters: 
    - `char a` - The ASCII value of the character to print.

- **io.printStr**
  - Description: Prints a string.
  - Parameters: 
    - `string* str` - The string to print.
- **io.cd**
  - Description: Changes the current working directory.
  - Parameters:
    - `string* path` - Path to switch to.
- **io.getcwd**
  - Description: Gets the current working directory
  - Parameters:
    - `register addr` - Register to put pointer to path into.

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
