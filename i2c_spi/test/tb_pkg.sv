package tb_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	
	`include "i2c_trans.sv"
	`include "spi_seq_item.sv"	
	`include "reg_mem.sv"
	`include "mem_block.sv"
	`include "mem_block_back.sv"
	`include "mem_adapter.sv"

	`include "master_config.sv"
	`include "ms_ag_cfg.sv"
	`include "env_config.sv"
	
	`include "master_driver.sv"
	`include "spi_drv_cb.sv"
	`include "spi_ms_drv.sv"
	`include "modify_data_cb.sv"
	`include "test_driver.sv"
	

	`include "master_monitor.sv"
	`include "spi_ms_mon.sv"

	`include "master_sequencer.sv"
	`include "spi_seqr.sv"

	`include "master_agent.sv"
	`include "spi_ms_ag.sv"
	
	

	`include "base_sequence.sv"
	`include "spi_seq.sv"

	`include "scoreboard.sv"
	`include "virtual_sequencer.sv"
	`include "virtual_sequence.sv"

	`include "env.sv"
	`include "test.sv"

endpackage
