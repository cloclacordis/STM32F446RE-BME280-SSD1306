/*
 * File: main.c
 * Project: STM32F446RE-BME280-SSD1306 Bare-Metal C Firmware
 * Description: Minimal main program to toggle PA5 (LED)
 * Author (of modifications): Timofei Alekseenko
 *
 * Copyright (c) 2023 Packt (original code)
 * SPDX-License-Identifier: MIT
 *
 * Modifications (c) 2025 Timofei Alekseenko
 * SPDX-License-Identifier: MIT
 */

#include "stm32f446re-board-cfg.h"

int main(void)
{
    // Enable clock for GPIOA
    RCC_AHB1ENR |= GPIOAEN;

    // Configure PA5 as general purpose output
    // MODER[11:10] = 01 -> output mode
    GPIOA_MODER |=  (1U << 10);   // Set bit 10
    GPIOA_MODER &= ~(1U << 11);   // Clear bit 11

    while (1) {
        GPIOA_ODR |= LED_PIN;     // Set PA5 high (turn LED on)
    }
}

