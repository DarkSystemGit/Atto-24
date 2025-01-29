# Thread Module
The thread module provides functions for managing thread operations and multithreading capabilities.

- **thread.create**
    - Description: Creates a new thread.
    - Parameters:
        - `int len` - The length of code for the new thread.
        - `code* code` - Pointer to the thread's code.

- **thread.switch**
    - Description: Switches to the next thread in round-robin order.
    - Parameters: None.

- **thread.getId**
    - Description: Gets the current thread ID.
    - Parameters:
        - `register ret` - Register to store the thread ID.

- **thread.remove**
    - Description: Removes a thread.
    - Parameters:
        - `int id` - ID of the thread to remove.

- **thread.dump**
    - Description: Dumps information about all threads.
    - Parameters: None.

- **thread.getInfo**
    - Description: Gets detailed information about a thread.
    - Parameters:
        - `int id` - ID of the thread to get info about.
        - `register addr` - Register to store the thread info structure.

- **thread.update**
    - Description: Updates thread state from a thread info structure.
    - Parameters:
        - `int id` - ID of the thread to update.
        - `threadinfo* info` - Pointer to thread info structure.

- **thread.setInterrupt**
    - Description: Sets an interrupt handler for a thread.
    - Parameters:
        - `int id` - Interrupt ID.
        - `code* handler` - Pointer to interrupt handler code.

Note: Thread operations can only be performed from thread 0 (main thread).