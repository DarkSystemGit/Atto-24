# Atto-24 Debugger 

The Atto-24 debugger provides interactive debugging capabilities when running programs with the `--debug` flag, and when stopped by breakpoints (`bp` instruction).

## Debugger Commands

### Basic Commands
- `continue` - Continue program execution
- `kill` - Kill the machine/program
- `help` - Display help message with available commands
- `disprompt` - Disable the debugger prompt
- `isRunning` - Check if machine is running

### State Inspection
- `dump` - Dump complete machine state
- `dumptmem` - Print thread memory
- `dumpthreads` - Print thread information
- `stack` - Print stack contents
- `flags` - Print flags state
- `memusage` - Print memory usage in KB

### Register Commands
- `%A` - Print register A value
- `%B` - Print register B value
- `%C` - Print register C value  
- `%D` - Print register D value
- `%E` - Print register E value
- `%F` - Print register F value
- `%G` - Print register G value
- `%H` - Print register H value
- `%I` - Print register I value
- `%J` - Print register J value
- `%SP` - Print stack pointer value
- `%SBP` - Print stack base pointer value

### Memory Commands
- `dump <start> <end>` - Dump memory region from start to end address
- `write <addr> <value>` - Write value to memory address

## Debug Mode
When running in debug mode (`--debug` flag), the debugger will:
- Show instruction execution information
- Display error information on crashes
- Allow interactive debugging through commands

The debugger prompt shows the current instruction pointer (e.g. `32>`) and accepts commands listed above.