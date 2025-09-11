## Week 1 — Day 1
**Date:** 2025-09-01  
**Phase:** Project Preparation & Init  
**Module(s):** System, Board Configuration  

**Tasks & Results:**

* Project structure created (`/Src`, `/Inc`, `/Startup`, `/Doc`).
* Stub/test files added (`main.c`, `stm32f446re-board-cfg.h`).
* Development log initialized (`/Doc/Devlog`).
* Added vendor system files:
  - `startup_stm32f446retx.s`,  
  - `STM32F446RETX_FLASH.ld`,  
  - `STM32F446RETX_RAM.ld`,  
  - `syscalls.c`,  
  - `sysmem.c`.

**Next Steps:**

* Create a preliminary`Makefile`.
* Draft a specification and define requirements.
* Create a high-level architectural diagram of the project.
* Verify toolchain, build system, and development board with a simple test program.
