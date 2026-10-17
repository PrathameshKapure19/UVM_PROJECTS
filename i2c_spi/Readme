# SPI & I2C Functional Verification using SystemVerilog and UVM

## Overview

This project focuses on functional verification of SPI and I2C interfaces using SystemVerilog and UVM-based testbench components. It includes protocol-specific test cases, verification agents, RTL modules, and a shared testbench environment for simulation and debugging.

## Project Objectives

- Develop structured verification environments for SPI and I2C interfaces.
- Organize stimulus generation and transaction handling using reusable verification components.
- Verify functional behavior through directed and stress-oriented test scenarios.
- Support debugging through monitoring, assertions, and scoreboard-based checking.

## Project Structure

```text
i2c_spi/
├── i2c_testcases/       # I2C test scenarios
├── master_i2c_agent/    # I2C master agent components
├── master_spi_agent/    # SPI master agent components
├── rtl/                 # SPI and I2C RTL modules
├── sim/                 # Simulation Makefile
├── spi_testcases/       # SPI test scenarios
├── tb/                  # Testbench environment and supporting components
└── test/                # Test packages and test files
```

## Verification Components

### I2C Verification

The I2C-related source files include:

- Master agent components
- Transaction and sequence support
- I2C test cases
- Interface and assertion files
- Register and memory-related components

The test cases cover scenarios such as reset behavior, read/write operations, address conditions, default values, and stress-oriented testing.

### SPI Verification

The SPI-related source files include:

- SPI master agent components
- Sequence items, sequences, driver, and monitor
- SPI RTL module
- SPI test cases
- SPI assertion and interface files

The test cases include all-zero and all-one data patterns, alternating values, and write-oriented scenarios.

### Shared Testbench Infrastructure

The testbench directory includes components such as:

- Environment and environment configuration
- Virtual sequence and virtual sequencer
- Scoreboard
- Interfaces and assertions
- Register and memory-related support components

## Tools and Technologies

- SystemVerilog
- Universal Verification Methodology (UVM)
- QuestaSim or another compatible simulator configured for the project
- Makefile-based simulation workflow

## Running the Simulation

The simulation directory contains a `Makefile`. The exact commands depend on the targets and simulator configuration defined in that file.

Navigate to the simulation directory:

```bash
cd sim
make
```

Check the Makefile for available targets and required simulator settings before running. The command above is a starting point, not a guarantee that the default target is configured.

## Project Highlights

- Separate SPI and I2C verification components
- Directed and stress-oriented test scenarios
- Testbench infrastructure with a scoreboard and assertions
- RTL and verification source organized into separate directories

## Author

**Prathamesh Yogesh Kapure**

- GitHub: [PrathameshKapure19](https://github.com/PrathameshKapure19)
- LinkedIn: [Prathamesh Kapure](https://www.linkedin.com/in/prathamesh-kapure-472a30266)
- Email: prathameshkapure19@gmail.com
