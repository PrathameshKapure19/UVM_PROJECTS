class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);

	`uvm_component_utils(virtual_sequencer)

	master_sequencer m_seqrh[];
	
	spi_seqr spi_seqr_h[];

	 env_config env_cfg;

	function new(string name="virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")

		m_seqrh=new[env_cfg.no_of_master_agents];
		spi_seqr_h = new[env_cfg.no_of_master_spi_agents];

	endfunction

endclass
