# Atto-24 Standard Library

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

