class env extends uvm_env;

	`uvm_component_utils(env)

	master_agent m_agt[];
	spi_ms_ag ms_ag_h[];

	scoreboard sbh;
	virtual_sequencer vseqrh;


	env_config env_cfg;
	mem_adapter adapter;
	uvm_reg_predictor#(i2c_trans) mem_predictor;

	function new(string name = "env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")

		m_agt=new[env_cfg.no_of_master_agents];
		
		ms_ag_h = new[env_cfg.no_of_master_spi_agents];

		if(env_cfg.has_master_agent)
		begin
		foreach(m_agt[i])
		begin
			m_agt[i]=master_agent::type_id::create($sformatf("m_agt[%0d]",i),this);
			uvm_config_db#(master_config)::set(this,$sformatf("m_agt[%0d]*",i),"master_config",env_cfg.m_cfg[i]);
		end
		end

		if(env_cfg.has_scoreboard)
			sbh=scoreboard::type_id::create("sbh",this);

		if(env_cfg.has_virtual_sequencer)
			vseqrh=virtual_sequencer::type_id::create("vseqrh",this);

		if(env_cfg.has_ral_model)
		begin
			adapter = mem_adapter::type_id::create("adapter");
			mem_predictor=uvm_reg_predictor#(i2c_trans)::type_id::create("mem_predictor",this);
		end

		if(env_cfg.has_master_spi_agent)
		begin
			foreach(ms_ag_h[i])
			begin
				ms_ag_h[i] = spi_ms_ag::type_id::create($sformatf("ms_spi_agent[%0d]",i),this);
				uvm_config_db#(ms_ag_cfg)::set(this,$sformatf("ms_spi_agent[%0d]*",i),"ms_ag_cfg",env_cfg.ms_spi_cfg[i]);
			end
		end

		
	endfunction

	function void connect_phase(uvm_phase phase);
		if(env_cfg.has_master_agent)
		foreach(m_agt[i])
			m_agt[i].monh.ap.connect(sbh.master_fifo[i].analysis_export);

		if(env_cfg.has_virtual_sequencer)
		foreach(m_agt[i])
			vseqrh.m_seqrh[i]=m_agt[i].seqrh;

		if(env_cfg.has_ral_model)
		begin
			env_cfg.mem_blk_h.mem_map.set_sequencer(m_agt[0].seqrh,adapter);
			mem_predictor.map=env_cfg.mem_blk_h.mem_map;
			mem_predictor.adapter=adapter;
			env_cfg.mem_blk_h.mem_map.set_auto_predict(0);
			m_agt[0].monh.ap.connect(mem_predictor.bus_in);
		end
		if(env_cfg.has_master_spi_agent)
		begin
			foreach(ms_ag_h[i])
				ms_ag_h[i].mon_h.monitor_port.connect(sbh.ms_spi_exp[i].analysis_export);	
		end
		if (env_cfg.has_virtual_sequencer && env_cfg.has_master_spi_agent)
		begin
    			foreach (ms_ag_h[i])
       				 vseqrh.spi_seqr_h[i] = ms_ag_h[i].spi_seqr_h;
		end
		
			
	endfunction


endclass
