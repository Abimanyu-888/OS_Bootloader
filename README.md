# OS Bootloader Project — From Power-On to Kernel Execution

## 1. Bootloader: The First Code That Runs
The **bootloader** is the very first software that runs after the system completes its Power-On Self-Test (POST). Its job is simple but critical:

- Initialize essential hardware
- Load the operating system kernel into memory
- Transition the CPU from **16-bit Real Mode** (BIOS default) to **32-bit Protected Mode**

In this project, the bootloader acts as the bridge between low-level hardware initialization and a higher-level C-based kernel.

---

## 2. Project File Breakdown

### `bootsect.asm` — The Entry Point (MBR)
- Located in the **first sector of the disk**
- Sets up the stack at `0x9000`
- Stores the boot drive index
- Loads the kernel from disk
- Initiates switch to 32-bit mode

---

### `disk.asm` — Disk Reader
- Implements `disk_load` function
- Uses BIOS interrupt `0x13` for disk access
- Reads sectors starting from **sector 2**
- Loads kernel into memory

---

### `gdt.asm` — Memory Segmentation Setup
- Defines the **Global Descriptor Table (GDT)**
- Required for Protected Mode
- Configures:
  - Code segment
  - Data segment
- Maps memory for 32-bit execution

---

### `switch_to_32_bit.asm` — Mode Transition Engine
Handles the critical switch from Real Mode → Protected Mode:

- Disables interrupts
- Loads GDT
- Sets Protection Enable (PE) bit in `CR0`
- Executes a **far jump** to flush instruction pipeline

---

### `kernel_entry.asm` — Bridge to C
- Minimal assembly wrapper
- Declares external `main` function
- Transfers control cleanly to C kernel

---

### `kernel.c` — The Kernel Core
- Written in **freestanding C**
- Directly interacts with hardware
- Writes to VGA text buffer at `0xb8000`
- Displays output → proves successful 32-bit execution

---

### `Makefile` — Build Automation
Automates the entire pipeline:

- Compiles C with:
  - `-m32` (32-bit mode)
  - `-ffreestanding` (no standard library)
- Links kernel at memory offset `0x1000`
- Produces final bootable image

---

## 3. Required Tools
Make sure these are installed before running:

- **NASM** → Assemble `.asm` files
- **GCC (i386)** → Compile kernel code
- **GNU ld (Binutils)** → Link binaries
- **GNU Make** → Automate build process
- **QEMU** → Emulate and test OS image

---

## 4. How to Build & Run

### 📂 1. Open Terminal
Navigate to the project's root directory where the `Makefile` is located.

Make sure the following tools are installed:
- `gcc`
- `nasm`
- `qemu`

---
### 🛠️ 2. Build & Launch

Run the main build command:

```bash
make
```
#### Automated Workflow Pipeline

##### 🔹 Compilation
Compiles the C kernel and assembly entry files into object code.

##### 🔹 Linking
Links object files into a standalone `kernel.bin`.  
Loaded at memory address: `0x1000`.

##### 🔹 Bootstrapping
Assembles the bootloader into `bootsect.bin`.

##### 🔹 Image Synthesis
Combines the bootloader and kernel into a single `os_image.bin`.

##### 🔹 Execution
Automatically runs the OS image using the QEMU emulator.

---

### 3. Environment Cleanup

To remove build artifacts and ensure a fresh build:

```bash
make clean
```
---