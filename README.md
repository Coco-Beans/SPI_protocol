# SPI Master-Slave Communication in Verilog

## Overview
Designed and implemented a parameterized **SPI (Serial Peripheral Interface)** Master and Slave in Verilog HDL to demonstrate full-duplex serial communication. The master generates the SPI clock, controls chip select, transmits data over MOSI, and receives data over MISO. A testbench verifies multiple data transfers.

## Features
- Parameterized design (`DATA_WIDTH`, `CLK_FREQ`, `SPI_FREQ`)
- Full-duplex SPI communication
- FSM-based SPI Master
- Clock divider for SPI clock generation
- Shift register-based serial transmission and reception
- Edge detection for data shifting and sampling
- Functional testbench with multiple test cases

## Project Structure
```
SPI/
├── spi_master.v      // SPI Master
├── spi_slave.v       // SPI Slave
├── tb_spi.v          // Testbench
└── README.md
```

## Working
1. The master waits for the `start` signal.
2. On start, `CS_N` is asserted low and transmit data is loaded.
3. The clock divider generates the SPI clock (`SCLK`).
4. Data is shifted out on **MOSI** and sampled on **MISO** simultaneously.
5. After all bits are transferred, `done` is asserted and the received data is stored.

## Parameters

| Parameter | Default |
|----------|---------|
| `DATA_WIDTH` | 8 |
| `CLK_FREQ` | 50 MHz |
| `SPI_FREQ` | 5 MHz |

## Tools Used
- Verilog HDL
- Xilinx Vivado
- EDA Playground

## Future Improvements
- Support all SPI modes (CPOL/CPHA)
- Multi-slave support
- Variable data widths
- FIFO buffering
- Continuous burst transfers
