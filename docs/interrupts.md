# Interrupts

## Overview
Interrupts in Atto-24 allow for asynchronous handling of events. When an interrupt occurs, the current thread's execution is paused and control transfers to Thread 0, which handles the interrupt. Child threads can run interrupt handlers by using the `int` command, but the handler must finish with `sys thread.finishInterrupt` before returning to the interrupted thread.

## System Interrupts

- **Interrupt 0**
    - Description: Function return cleanup
    - Triggered: When using JMP, CALL or similar control flow instructions

- **Interrupt 1**
    - Description: Render complete
    - Triggered: After gfx.render finishes displaying a frame

- **Interrupt 2**
    - Description: Enter key pressed
    - Triggered: When the Enter key is pressed and released

## Usage

To set an interrupt handler:

```asm
sys thread.setInterrupt <interrupt id>, <handler addr>; //Register interrupt handler
```

Example:

```asm
// Must be in Thread 0
#include <stdlib>;
#define intStr "Interrupt occurred";
sys thread.setInterrupt 2, Handler; //Register interrupt handler
Handler:
    //Handle interrupt
    sys io.printStr &intStr; //Print message
    sys thread.finishInterrupt; //Return to interrupted thread
```

Note:
- Only Thread 0 can register and handle interrupts
- Interrupt handlers run in Thread 0's context
- Must call thread.finishInterrupt before returning from handler
- The interrupted thread resumes after handler completes

