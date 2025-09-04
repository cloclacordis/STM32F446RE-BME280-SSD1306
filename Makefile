# Toolchain definitions
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
GDB = arm-none-eabi-gdb

# Project name
TARGET = Environmental_monitor

# Build directory
BUILD_DIR = Build

# Source files
C_SOURCES = \
    Src/main.c \
    Src/sysmem.c \
    Src/syscalls.c

# ASM sources (startup file)
ASM_SOURCES = Sys/startup_stm32f446retx.s

# Include paths
C_INCLUDES = -IInc

# Linker script
LDSCRIPT = Sys/STM32F446RETX_FLASH.ld

# CPU specific flags
CPU = -mcpu=cortex-m4 -mthumb
FPU = -mfpu=fpv4-sp-d16 -mfloat-abi=hard

# Compilation flags
CFLAGS = $(CPU) $(FPU) \
    -std=gnu11 \
    -O0 -g3 \
    -Wall -Wextra -Wpedantic \
    -ffunction-sections -fdata-sections \
    $(C_INCLUDES) \
    -DSTM32F446xx

# Linker flags
LDFLAGS = $(CPU) $(FPU) -specs=nosys.specs \
    -T$(LDSCRIPT) \
    -Wl,-Map=$(BUILD_DIR)/$(TARGET).map \
    -Wl,--gc-sections \
    --specs=nano.specs \
    -static

# Generate list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

# Default target
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin

# Create build directory
$(BUILD_DIR):
	mkdir -p $@

# Compile C files
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

# Compile ASM files
$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -x assembler-with-cpp $< -o $@

# Link object files
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) | $(BUILD_DIR)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

# Generate binary file
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	$(OBJCOPY) -O binary $< $@

# Flash the device using OpenOCD
flash: $(BUILD_DIR)/$(TARGET).elf
	openocd -f board/st_nucleo_f4.cfg -c "program $< verify reset exit"

# Start debug server
debug-server:
	openocd -f board/st_nucleo_f4.cfg

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean flash debug-server
