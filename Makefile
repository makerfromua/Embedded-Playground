# MCU
MCU=attiny13
# FUSE_L=0x6A
# FUSE_H=0xFF
F_CPU=1200000

# Compiler & Linker
CC=avr-gcc
LD=avr-ld
OBJCOPY=avr-objcopy
SIZE=avr-size
AVRDUDE=avrdude
CFLAGS=-std=c99 -Wall -g -Os -mmcu=${MCU} -DF_CPU=${F_CPU} -I.

# Files
TARGET=main
SRCS = main.c

# USBAsp Settings
BITCLOCK=40

all:
	${CC} ${CFLAGS} -o ${TARGET}.o ${SRCS}
	${LD} -o ${TARGET}.elf ${TARGET}.o
	${OBJCOPY} -j .text -j .data -O ihex ${TARGET}.o ${TARGET}.hex
	${SIZE} -C --mcu=${MCU} ${TARGET}.elf

flash:
	${AVRDUDE} -p ${MCU} -c usbasp -B${BITCLOCK} -U flash:w:${TARGET}.hex:i -F -P usb

# fuse:
# 	$(AVRDUDE) -p ${MCU} -c usbasp -B${BITCLOCK} -U hfuse:w:${FUSE_H}:m -U lfuse:w:${FUSE_L}:m

clean:
	rm -f *.c~ *.o *.elf *.hex
