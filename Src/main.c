/*******************************************************************
 * File: main.c
 * Project: STM32F446RE-BME280-SSD1306 Bare-Metal C Firmware
 * Description: Minimal main program to toggle PA5 (LED)
 * Author: Timofei Alekseenko
 * License: MIT
 * Year: 2025
 *******************************************************************/

#include "board_config.h"

int main(void) {
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

