# Toolchain
CC      := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
OBJDUMP := arm-none-eabi-objdump
SIZE    := arm-none-eabi-size
GDB     := arm-none-eabi-gdb
OPENOCD := openocd

# Project name
TARGET   := blink_test

# Directories
DBG_DIR   := Debug
SRC_DIR   := Src
INC_DIR   := Inc
STR_DIR   := Startup

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
    -Wall \
    -ffunction-sections \
    -fdata-sections \
    -fstack-usage \
    -I$(INC_DIR) \
    -DDEBUG \
    -DSTM32 -DSTM32F4 \
    -DSTM32F446RETx \
    --specs=nano.specs \
    -MMD -MP -MF"Src/main.d" -MT"Src/main.o"

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

all: $(DBG_DIR)/$(TARGET).elf $(DBG_DIR)/$(TARGET).bin

$(DBG_DIR):
	mkdir -p $@

# Compile C
$(DBG_DIR)/%.o: $(SRC_DIR)/%.c | $(DBG_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

# Compile ASM
$(DBG_DIR)/%.o: $(STR_DIR)/%.s | $(DBG_DIR)
	$(CC) -c $(CFLAGS) -x assembler-with-cpp $< -o $@

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

# Flash
flash: $(DBG_DIR)/$(TARGET).elf
	$(OPENOCD) -f board/st_nucleo_f4.cfg -c "program $< verify reset exit"

# Debug server
debug-server:
	$(OPENOCD) -f board/st_nucleo_f4.cfg

# GDB
gdb: $(DBG_DIR)/$(TARGET).elf
	$(GDB) $< -ex "target remote localhost:3333"

# Clean
clean:
	rm -rf $(DBG_DIR)
	rm -f $(SRC_DIR)/*.d

.PHONY: all clean flash debug-server gdb disasm

-include $(DEPS)
