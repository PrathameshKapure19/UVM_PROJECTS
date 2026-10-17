package tb_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;	
`include "flash_mem_cfg.sv"
`include "AHB_seq_item.sv"
`include "QSPI_seq_item.sv"

`include "AHB_cfg.sv"
`include "QSPI_cfg.sv"
`include "env_cfg.sv"

`include "AHB_drv.sv"
`include "QSPI_drv.sv"

`include "AHB_mon.sv"
`include "QSPI_mon.sv"

`include "AHB_seqr.sv"
//`include "QSPI_seqr.sv"

`include "AHB_agt.sv"
`include "QSPI_agt.sv"

`include "AHB_seq.sv"
//`include "QSPI_seq.sv"

`include "scoreboard.sv"

`include "environment.sv"

`include "Base_test.sv"
endpackage
