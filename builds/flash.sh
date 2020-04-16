#!/bin/bash

serial_dev=/dev/ttyACM0
baud=19200

if [[ ! -f $serial_dev ]]; then
	echo "Serial port $serial_dev is missing"
	exit 1
fi

ARDUINO_PATH="/home/lheck/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/"
# ARDUINO_PATH=/home/lheck/Downloads/arduino-1.8.5/hardware/tools/avr/bin/avrdude

export PATH=${ARDUINO_PATH}/bin:$PATH

# Flash the bootloader (only once)
avrdude \
	-C ${ARDUINO_PATH}/etc/avrdude.conf \
	-v -patmega1284p -cstk500v1 -P${serial_dev} -b${baud} \
	-e -Ulock:w:0x3F:m -Uefuse:w:0xFD:m -Uhfuse:w:0xDE:m -Ulfuse:w:0xFF:m

hex_file="./marlin-1.1.x-2020-04-16.hex"

# Flash the firmware
avrdude \
	-C ${ARDUINO_PATH}/etc/avrdude.conf \
	-v -V -patmega1284p -cstk500v1 -P${serial_dev} -b${baud} \
	-D -Uflash:w:"${hex_file}":i

