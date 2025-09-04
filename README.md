## Environmental Monitor (STM32F446RE)

This repository contains a **bare-metal C firmware** project for the **STM32F446RE** microcontroller (NUCLEO-64 board).

The system reads **temperature, pressure, and humidity** from a **BME280 sensor** and displays the data on an **SSD1306 OLED** via I²C. Debug messages are sent over UART for development and verification.

The firmware is designed with a **layered, modular architecture** (system layer, BSP, peripheral drivers, device drivers, application logic). Documentation includes specifications, architecture diagrams, and a development log.

**Status:** Active development.
