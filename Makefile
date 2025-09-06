# Toolchain
CC      := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
OBJDUMP := arm-none-eabi-objdump
SIZE    := arm-none-eabi-size
GDB     := gdb-multiarch
OPENOCD := openocd

# Project name
TARGET  := magic-smoke-test

# Directories
DBG_DIR := Debug
SRC_DIR := Src
INC_DIR := Inc
STR_DIR := Startup

# Sources
C_SOURCES := \
    $(SRC_DIR)/main.c \
    $(SRC_DIR)/sysmem.c \
    $(SRC_DIR)/syscalls.c

ASM_SOURCES := \
    $(STR_DIR)/startup_stm32f446retx.s

# Linker script
LDSCRIPT := STM32F446RETX_FLASH.ld

# CPU & FPU
CPU := -mcpu=cortex-m4 -mthumb
FPU := -mfpu=fpv4-sp-d16 -mfloat-abi=hard

# Flags
CFLAGS := $(CPU) $(FPU) \
    -std=gnu11 -g3 -O0 \
    -Wall -Wextra -Werror \
    -ffunction-sections \
    -fdata-sections \
    -fstack-usage \
    -I$(INC_DIR) \
    -DDEBUG \
    -DSTM32 \
    -DSTM32F4 \
    -DSTM32F446RETx \
    -DNUCLEO_F446RE \
    --specs=nano.specs \
    -MMD -MP

LDFLAGS := $(CPU) $(FPU) \
    -T$(LDSCRIPT) \
    -Wl,-Map=$(DBG_DIR)/$(TARGET).map \
    -Wl,--gc-sections \
    --specs=nosys.specs \
    --specs=nano.specs \
    -static \
    -Wl,--start-group -lc -lm -Wl,--end-group

# Objects
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(DBG_DIR)/%.o,$(C_SOURCES)) \
           $(patsubst $(STR_DIR)/%.s,$(DBG_DIR)/%.o,$(ASM_SOURCES))

# Dependencies
DEPS := $(OBJECTS:.o=.d)

# OpenOCD configuration
OCD_CFG   := board/st_nucleo_f4.cfg

# Build all
all: $(DBG_DIR)/$(TARGET).elf $(DBG_DIR)/$(TARGET).bin

$(DBG_DIR):
	mkdir -p $@

# Compile C
$(DBG_DIR)/%.o: $(SRC_DIR)/%.c | $(DBG_DIR)
	$(CC) -c $(CFLAGS) -MF"$(@:.o=.d)" -MT"$@" $< -o $@

# Compile ASM
$(DBG_DIR)/%.o: $(STR_DIR)/%.s | $(DBG_DIR)
	$(CC) -c $(CFLAGS) -x assembler-with-cpp -MF"$(@:.o=.d)" -MT"$@" $< -o $@

# Link
$(DBG_DIR)/$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

# Binary
$(DBG_DIR)/$(TARGET).bin: $(DBG_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Disassembly
disasm: $(DBG_DIR)/$(TARGET).elf
	$(OBJDUMP) -h -S $< > $(DBG_DIR)/$(TARGET).list

# Clean all
clean:
	rm -rf $(DBG_DIR)

# Launch OpenOCD (in terminal №1)
ocd:
	cd $(DBG_DIR) && $(OPENOCD) -f $(OCD_CFG)

# Launch GDB (in terminal №2)
gdb:
	cd $(DBG_DIR) && $(GDB)

.PHONY: all disasm clean ocd gdb

-include $(DEPS)
