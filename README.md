# Parameterizable SPI Master & Slave Architecture in Verilog

A robust, fully parameterizable, and synchronous implementation of the **Serial Peripheral Interface (SPI)** protocol in Verilog. This repository features a configurable SPI Master controller with an integrated clock divider, a synchronous SPI Slave peripheral model, and an automated verification testbench.

Designed for synthesis on modern FPGA devices (Xilinx, Intel, Lattice) and integration into ASIC system-on-chip (SoC) architectures.

---

## 📌 Table of Contents
- [Overview & SPI Protocol Primer](#-overview--spi-protocol-primer)
- [System Architecture](#-system-architecture)
  - [SPI Master Module (`spi_master.v`)](#1-spi-master-module-spi_masterv)
  - [SPI Slave Module (`spi_slave.v`)](#2-spi-slave-module-spi_slavev)
- [Finite State Machine (FSM) Design](#-finite-state-machine-fsm-design)
- [Timing Diagrams & Waveforms](#-timing-diagrams--waveforms)
- [Module Interfaces & Specifications](#-module-interfaces--specifications)
- [Verification & Simulation](#-verification--simulation)
- [Synthesis & Resource Utilization](#-synthesis--resource-utilization)
- [License](#-license)

---

## 📌 Overview & SPI Protocol Primer

The Serial Peripheral Interface (SPI) is a synchronous, four-wire, full-duplex serial communication interface commonly used to communicate between microcontrollers, FPGAs, sensors, EEPROMs, and display controllers.

### Protocol Modes Summary
SPI operates across 4 primary modes defined by Clock Polarity (**CPOL**) and Clock Phase (**CPHA**):

| SPI Mode | CPOL (Idle Clock State) | CPHA (Clock Edge Sampling) | Sample Edge | Shift Edge |
| :---: | :---: | :---: | :---: | :---: |
| **Mode 0** | **`0` (LOW)** | **`0` (Leading Edge)** | **Rising Edge** | **Falling Edge** |
| Mode 1 | `0` (LOW) | `1` (Trailing Edge) | Falling Edge | Rising Edge |
| Mode 2 | `1` (HIGH) | `0` (Leading Edge) | Falling Edge | Rising Edge |
| Mode 3 | `1` (HIGH) | `1` (Trailing Edge) | Rising Edge | Falling Edge |

> **This implementation uses SPI Mode 0 (CPOL = 0, CPHA = 0).** Data is shifted out on the falling edge of `SCLK` and sampled on the rising edge of `SCLK`.

---

## 🔌 System Architecture

The project consists of three core components: an **SPI Master Controller**, an **SPI Slave Model**, and a **Testbench Top**.

```text
+-----------------------------------------------------------------------------------------+
|                                    TB_SPI TESTBENCH                                     |
|                                                                                         |
|  +----------------------------------+            +-----------------------------------+  |
|  |           SPI MASTER             |            |             SPI SLAVE             |  |
|  |                                  |   sclk     |                                   |  |
|  |                      sclk   o----+----------->| i   sclk                          |  |
|  |                      cs_n   o----+----------->| i   cs_n                          |  |
|  |                      mosi   o----+----------->| i   mosi                          |  |
|  |                      miso   i<---+-----------+o   miso                            |  |
|  |                                  |            |                                   |  |
|  |  +----------------------------+  |            |  +-----------------------------+  |  |
|  |  | Clock Divider & Edge Detect|  |            |  | Shift Register Logic        |  |  |
|  |  +----------------------------+  |            |  +-----------------------------+  |  |
|  |  | 4-State Control FSM        |  |            +-----------------------------------+  |
|  |  +----------------------------+  |                                                   |
|  +----------------------------------+                                                   |
+-----------------------------------------------------------------------------------------+
