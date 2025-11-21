# 🎮 2-Player Pong Game - x86 Assembly

A classic Pong implementation written entirely in x86 Assembly language, demonstrating low-level programming excellence through real-time graphics, interrupt handling, and direct hardware access.

## Features

- **Two-player gameplay** with intuitive keyboard controls
- **Realistic ball physics** with dynamic bounce angles
- **Live scoring system** with win condition (first to 5 points)
- **Smooth 60 FPS gameplay** using timer interrupts
- **Text-mode graphics** with colored paddles and court elements
- **Instant restart functionality** without program reload

## Controls

- **Player 1 (Left)**: W (up), S (down)
- **Player 2 (Right)**: O (up), K (down)
- **Game Menu**: R (restart), Any other key (exit)

## Technical Implementation

### Architecture
Built for 16-bit DOS environment using .COM format (org 0x0100). The game utilizes direct video memory manipulation at segment B800h for graphics rendering and BIOS interrupts for keyboard input handling.

### Game Loop & Timing
Uses Programmable Interval Timer (IRQ0) interrupts to maintain consistent frame rate. The timer interrupt service routine handles game state updates, ball movement, and collision detection while ensuring smooth gameplay performance.

### Graphics & Display
- Court boundaries drawn using custom character patterns
- Colored paddles (red and blue) using ASCII block characters
- Real-time score display and game information
- Victory screens with restart options
- Efficient screen updates using direct memory writes

### Physics & Collision
- Ball movement with configurable speed and direction vectors
- Advanced collision detection against paddles and walls
- Dynamic bounce angles based on paddle contact position
- Boundary checking and score validation

## Compilation & Execution

Requires NASM assembler and DOS-compatible environment (DOSBox recommended):

```bash
nasm pong.asm -f bin -o pong.com
pong.com
```

## Code Structure

The assembly code is organized into logical sections:
- **Data Section**: Game variables, messages, and initial positions
- **Initialization**: Timer setup and screen preparation
- **Game Loop**: Main gameplay logic and state management
- **Interrupt Handlers**: Timer and input processing
- **Utility Functions**: Drawing, collision, and scoring routines

## Educational Value

This project serves as an excellent learning resource for:
- x86 Assembly language programming
- Interrupt handling and management
- Real-time game development
- Low-level hardware interaction
- Memory management and optimization
- Text-mode graphics programming

## Technical Highlights

- Efficient use of processor registers and memory
- Optimized drawing routines for smooth animation
- Clean state management and game logic
- Professional code organization and documentation
- Robust error handling and user interface

Experience classic arcade action while exploring the fundamentals of low-level system programming through this complete, feature-rich Pong implementation.# 🎮 2-Player Pong Game - x86 Assembly

A classic Pong implementation written entirely in x86 Assembly language, demonstrating low-level programming excellence through real-time graphics, interrupt handling, and direct hardware access.

## Features

- **Two-player gameplay** with intuitive keyboard controls
- **Realistic ball physics** with dynamic bounce angles
- **Live scoring system** with win condition (first to 5 points)
- **Smooth 60 FPS gameplay** using timer interrupts
- **Text-mode graphics** with colored paddles and court elements
- **Instant restart functionality** without program reload

## Controls

- **Player 1 (Left)**: W (up), S (down)
- **Player 2 (Right)**: O (up), K (down)
- **Game Menu**: R (restart), Any other key (exit)

## Technical Implementation

### Architecture
Built for 16-bit DOS environment using .COM format (org 0x0100). The game utilizes direct video memory manipulation at segment B800h for graphics rendering and BIOS interrupts for keyboard input handling.

### Game Loop & Timing
Uses Programmable Interval Timer (IRQ0) interrupts to maintain consistent frame rate. The timer interrupt service routine handles game state updates, ball movement, and collision detection while ensuring smooth gameplay performance.

### Graphics & Display
- Court boundaries drawn using custom character patterns
- Colored paddles (red and blue) using ASCII block characters
- Real-time score display and game information
- Victory screens with restart options
- Efficient screen updates using direct memory writes

### Physics & Collision
- Ball movement with configurable speed and direction vectors
- Advanced collision detection against paddles and walls
- Dynamic bounce angles based on paddle contact position
- Boundary checking and score validation

## Compilation & Execution

Requires NASM assembler and DOS-compatible environment (DOSBox recommended):

```bash
nasm pong.asm -o pong.com
pong.com
```

## Code Structure

The assembly code is organized into logical sections:
- **Data Section**: Game variables, messages, and initial positions
- **Initialization**: Timer setup and screen preparation
- **Game Loop**: Main gameplay logic and state management
- **Interrupt Handlers**: Timer and input processing
- **Utility Functions**: Drawing, collision, and scoring routines

## Educational Value

This project serves as an excellent learning resource for:
- x86 Assembly language programming
- Interrupt handling and management
- Real-time game development
- Low-level hardware interaction
- Memory management and optimization
- Text-mode graphics programming

## Technical Highlights

- Efficient use of processor registers and memory
- Optimized drawing routines for smooth animation
- Clean state management and game logic
- Professional code organization and documentation
- Robust error handling and user interface

Experience classic arcade action while exploring the fundamentals of low-level system programming through this complete, feature-rich Pong implementation.
