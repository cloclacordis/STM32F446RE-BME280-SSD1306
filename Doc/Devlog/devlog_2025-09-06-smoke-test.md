## Date: 2025-09-06

### Week 1 — Toolchain & Board Smoke Test

**Tasks & Results:**

* Makefile updated — finalized build and debug/flash targets (`all`, `disasm`, `clean`, `ocd`, `gdb`).
* Verified build process — all sources compile and link, binary generated successfully.

![](assets/2025-09-06-1-build.png)

* Verified debug and flashing workflow (OpenOCD + GDB).

  * OpenOCD launched and GDB connected via port `3333`.
  
  ![](assets/2025-09-06-2-ocd.png)
  
  * Debug session commands executed step by step:

    1. Connect to the MCU: `target remote localhost:3333`
    2. Reset/init device: `monitor reset init`
    3. Flash new firmware: `monitor flash write_image erase magic-smoke-test.elf`
    4. Reset again: `monitor reset init`
    5. Resume execution: `monitor resume`
    6. Exit session
    
    ![](assets/2025-09-06-3-gdb.png)

* Development board successfully programmed and verified. Full toolchain + board operation confirmed.

**Next Steps:**

* Refine state diagrams, requirements, and architecture documentation.
* Configure UART and implement single-byte transmission.
* Begin development of peripheral drivers (**Week 2**).
