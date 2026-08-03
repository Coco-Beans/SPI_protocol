# SPI Master-Slave Communication in Verilog

A lightweight, parameterizable Verilog implementation of the **Serial Peripheral Interface (SPI)** protocol operating in **SPI Mode 0 (CPOL = 0, CPHA = 0)**. The repository includes an SPI Master controller, an SPI Slave peripheral, and a full self-checking testbench.

---

## 📌 Features

- **Parameterizable Configuration:** Configurable system clock frequency (`CLK_FREQ`), SPI clock frequency (`SPI_FREQ`), and payload width (`DATA_WIDTH`).
- **Synchronous Full-Duplex Transfer:** Simultaneous MOSI (Master Out Slave In) transmission and MISO (Master In Slave Out) reception.
- **SPI Mode 0 Standard:**
  - Clock Polarity (`CPOL = 0`): `SCLK` stays LOW when idle.
  - Clock Phase (`CPHA = 0`): Data sampled on **rising edge**, shifted on **falling edge**.
- **Internal Clock Generation:** Glitch-free `SCLK` generation using a counter-based clock divider.
- **Complete Testbench Included:** Simulates multiple sequential 8-bit transfers and logs transmitted/received values to the console.

---

## 📂 Repository Structure

```text
.
├── rtl/
│   ├── spi_master.v    # SPI Master controller with FSM and clock divider
│   └── spi_slave.v     # Simple SPI Slave shift-register model
├── sim/
│   └── tb_spi.v        # Testbench with task-based stimulus generation
└── README.md           # Project documentation
