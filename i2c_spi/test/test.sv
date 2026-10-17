class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	env envh;

	int no_of_master_agents=1;
	int no_of_master_spi_agents = 1;

	bit has_master_agent=1;
	bit has_master_spi_agent = 1;
	bit has_scoreboard=1;
	bit has_ral_model=1;
	bit has_virtual_sequencer=1;
  
	int no_of_writes=1;
	int no_of_reads=1;
	int no_of_seq_item = 1;

	master_config m_cfg[];
	ms_ag_cfg ms_spi_cfg[];

	env_config env_cfg;
	mem_block mem_blk_h;
	mem_block_back mem_blk_b_h;
	
	base_virtual_seq base_seq;

	function new(string name="base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  envh = env::type_id::create("envh", this);

  env_cfg = env_config::type_id::create("env_cfg");
  
  // Allocate config arrays
  env_cfg.m_cfg      = new[no_of_master_agents];
  env_cfg.ms_spi_cfg = new[no_of_master_spi_agents];
  m_cfg      = new[no_of_master_agents];
  ms_spi_cfg = new[no_of_master_spi_agents];

  //-----------------------------
  // I2C Master Configuration
  //-----------------------------
  foreach (env_cfg.m_cfg[i]) begin
    m_cfg[i] = master_config::type_id::create($sformatf("m_cfg[%0d]", i));
    

    m_cfg[i].is_active = UVM_ACTIVE;

    if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_if", m_cfg[i].vif))
      `uvm_fatal(get_type_name(), "Failed to get i2c_if")
	
    env_cfg.m_cfg[i]=m_cfg[i];
	
  end

  //-----------------------------
  // SPI Master Configuration
  //-----------------------------
  foreach (env_cfg.ms_spi_cfg[i]) 
  begin
    ms_spi_cfg[i] = ms_ag_cfg::type_id::create($sformatf("ms_spi_cfg[%0d]", i));

    ms_spi_cfg[i].is_active = UVM_ACTIVE;

    if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_if", ms_spi_cfg[i].ms_if))
      `uvm_fatal(get_type_name(), "Failed to get spi_if")
    
    env_cfg.ms_spi_cfg[i]= ms_spi_cfg[i];
  end

  //-----------------------------
  // Register Model
  //-----------------------------
  if (has_ral_model) begin
    mem_blk_h = mem_block::type_id::create("mem_blk_h");
    mem_blk_h.build();

    mem_blk_b_h = mem_block_back::type_id::create("mem_blk_b_h");
    mem_blk_b_h.build();

    env_cfg.mem_blk_h   = mem_blk_h;
    env_cfg.mem_blk_b_h = mem_blk_b_h;
  end

  //-----------------------------
  // Environment Configuration
  //-----------------------------
  env_cfg.no_of_master_agents    = no_of_master_agents;
  env_cfg.no_of_master_spi_agents = no_of_master_spi_agents;
  env_cfg.has_master_agent       = has_master_agent;
  env_cfg.has_master_spi_agent   = has_master_spi_agent;
  env_cfg.has_scoreboard         = has_scoreboard;
  env_cfg.has_ral_model          = has_ral_model;
  env_cfg.has_virtual_sequencer  = has_virtual_sequencer;
  env_cfg.no_of_writes           = no_of_writes;
  env_cfg.no_of_reads            = no_of_reads;
  env_cfg.no_of_seq_item        = no_of_seq_item;

  uvm_config_db#(env_config)::set(this, "*", "env_config", env_cfg);

endfunction	
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction:end_of_elaboration_phase


endclass

class write_test extends base_test;

	`uvm_component_utils(write_test)

	write_seq_v seqh;reset_seq_v rseqh;

	function new(string name="write_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_writes=10;
		super.build_phase(phase);

	endfunction

	task run_phase(uvm_phase phase);
		
		seqh=write_seq_v::type_id::create("seqh");
		rseqh=reset_seq_v::type_id::create("seqh");
		phase.raise_objection(this);
		
		seqh.start(envh.vseqrh);
		//#300;
		phase.drop_objection(this);

	endtask

endclass








