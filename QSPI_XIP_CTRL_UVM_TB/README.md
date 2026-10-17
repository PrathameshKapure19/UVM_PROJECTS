# QSPI XIP Controller — UVM-Based Verification

### Functional Verification of a Cache-Enabled Execute-in-Place Architecture

**Domain:** ASIC Design Verification  
**Methodology:** SystemVerilog | Universal Verification Methodology (UVM)  
**Interfaces:** AHB-Lite | Quad SPI (QSPI)  
**Simulation Tool:** QuestaSim

---

## Overview

This project focuses on **UVM-based functional verification of a cache-enabled Execute-in-Place (XIP) controller** that provides memory access through an AHB-Lite interface while retrieving data from external QSPI Flash memory.

A structured UVM verification environment is developed to verify interactions among the AHB-Lite interface, cache subsystem, XIP controller, and QSPI Flash interface. The environment uses reusable verification components to generate transactions, observe interface activity, and support functional debugging.

## UVM Verification Architecture

The verification environment integrates two primary interface-level agents:

- **AHB-Lite Master Agent:** Generates bus transactions to exercise the XIP controller and memory-access path.
- **QSPI Flash Agent:** Models Flash-side behavior and responds to read transactions initiated by the controller.

These agents enable coordinated verification of memory-access operations across the AHB-Lite and QSPI interfaces.

## Verification Objectives

- Verify AHB-Lite initiated memory accesses through the XIP controller.
- Examine cache-hit and cache-miss behavior.
- Verify QSPI Flash initialization and read-command handling.
- Check command sequencing, address transfer, and Flash data-response behavior.
- Evaluate interactions between cache-line fetching and AHB-Lite data delivery.
- Identify functional issues through transaction monitoring, simulation, and waveform analysis.

## UVM-Based Verification Methodology

The project applies the **Universal Verification Methodology (UVM)** to structure the testbench into reusable, transaction-oriented verification components.

Key aspects include:

- Agent-based verification for AHB-Lite and QSPI interfaces.
- Sequence-driven stimulus generation for bus transactions.
- Driver-based interface interaction.
- Monitor-based observation of protocol activity.
- Transaction-level analysis and simulation debugging.
- Integration of interface-level verification into an end-to-end XIP verification environment.

## Design Under Verification

The design combines an AHB-Lite-accessible XIP controller, a direct-mapped cache, and a QSPI Flash interface.

During a cache hit, requested data can be served from the cache. During a cache miss, the controller can initiate a Flash read to retrieve the required data and populate the cache.

The UVM verification environment focuses on the functional correctness of these interactions and the resulting bus and Flash-interface behavior.

## Tools & Technologies

- SystemVerilog
- Universal Verification Methodology (UVM)
- AHB-Lite
- Quad SPI (QSPI)
- QuestaSim
- RTL Simulation and Waveform Debugging

## Project Highlights

- UVM-based verification architecture for a cache-enabled XIP controller.
- Interface-level verification using AHB-Lite Master and QSPI Flash agents.
- Protocol interaction between the bus, cache, controller, and Flash interface.
- Reusable verification components and transaction-oriented stimulus.
- Simulation-driven functional analysis and debugging.

## Author

**Prathamesh Yogesh Kapure**

[GitHub](https://github.com/PrathameshKapure19) · [LinkedIn](https://www.linkedin.com/in/prathamesh-kapure-472a30266) · [Email](mailto:prathameshkapure19@gmail.com)
