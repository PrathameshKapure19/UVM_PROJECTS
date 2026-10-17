
class env_config extends uvm_object;
  `uvm_object_utils(env_config)
  
  bit has_master_agent;		
  bit has_scoreboard;
  bit has_ral_model;
  bit has_virtual_sequencer;
  bit has_master_spi_agent;
  
  int no_of_master_agents;
  int no_of_master_spi_agents;

	int no_of_writes;
	int no_of_reads;
	int no_of_seq_item;
  
  master_config m_cfg[];
  ms_ag_cfg ms_spi_cfg[];

mem_block mem_blk_h;
mem_block_back mem_blk_b_h;
  function new(string name="env_config");
    super.new(name);
  endfunction
  
endclass



 
