/*
 * File: stm32f446re-board-cfg.h
 * Project: STM32F446RE-BME280-SSD1306 Bare-Metal C Firmware
 * Description: Register definitions and bit masks for STM32F446RE
 * Author: Timofei Alekseenko
 * License: MIT
 * Year: 2025
 *
 * Based on example code from:
 * Copyright (c) 2023 Packt (MIT License)
 */

#ifndef F446RE_BOARD_CONFIG_H
#define F446RE_BOARD_CONFIG_H

/*** Base addresses ***/
#define PERIPH_BASE         (0x40000000UL)   // Base address of peripheral registers
#define AHB1PERIPH_OFFSET   (0x00020000UL)   // Offset for AHB1 bus
#define AHB1PERIPH_BASE     (PERIPH_BASE + AHB1PERIPH_OFFSET)

/*** GPIOA peripheral ***/
#define GPIOA_OFFSET        (0x0000UL)
#define GPIOA_BASE          (AHB1PERIPH_BASE + GPIOA_OFFSET)

/*** RCC (Reset and Clock Control) peripheral ***/
#define RCC_OFFSET          (0x3800UL)
#define RCC_BASE            (AHB1PERIPH_BASE + RCC_OFFSET)

/*** RCC registers ***/
#define RCC_AHB1ENR_OFFSET  (0x30UL)  // AHB1 peripheral clock enable register
#define RCC_AHB1ENR         (*(volatile unsigned int *)(RCC_BASE + RCC_AHB1ENR_OFFSET))

/*** GPIOA registers ***/
#define GPIOA_MODER_OFFSET  (0x00UL)  // GPIO port mode register
#define GPIOA_MODER         (*(volatile unsigned int *)(GPIOA_BASE + GPIOA_MODER_OFFSET))

#define GPIOA_ODR_OFFSET    (0x14UL)  // GPIO port output data register
#define GPIOA_ODR           (*(volatile unsigned int *)(GPIOA_BASE + GPIOA_ODR_OFFSET))

/*** Bit masks ***/
#define GPIOAEN             (1U << 0)   // Enable clock for GPIOA
#define GPIO_PIN5           (1U << 5)   // Pin mask for PA5
#define LED_PIN             GPIO_PIN5   // Alias for the onboard LED (PA5)

#endif // F446RE_BOARD_CONFIG_H
