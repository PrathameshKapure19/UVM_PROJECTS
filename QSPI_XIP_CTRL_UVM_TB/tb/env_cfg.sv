class env_cfg extends uvm_object;

`uvm_object_utils(env_cfg)

AHB_cfg p_cfg;
QSPI_cfg s_cfg;
flash_mem_cfg mem_cfg_h;
bit has_scoreboard;
bit has_master_agent;
bit has_slave_agent;

int no_of_seq_item;

function new(string name = "env_cfg");
	super.new(name);
endfunction

endclass
