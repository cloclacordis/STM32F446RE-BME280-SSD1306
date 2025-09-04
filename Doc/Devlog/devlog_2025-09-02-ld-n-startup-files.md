## Date: 2025-09-02

### Stage 0 — Preparation & Init

**Tasks & Results:**

* Added vendor system files:
  * `STM32F446RETX_FLASH.ld` (linker script for execution from Flash).
  * `startup_stm32f446retx.s` (startup assembly file with vector table and reset handler).
* Created `Sys/` directory to hold system-level sources.

**Next Steps:**

* Integrate system files into the build system (Makefile).
* Run a minimal test program on the board to validate toolchain + startup file + linker script.
* Proceed with writing the project specification and requirements.
