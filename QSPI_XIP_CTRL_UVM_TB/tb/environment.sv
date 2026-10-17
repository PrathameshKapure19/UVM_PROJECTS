class environment extends uvm_env;
  `uvm_component_utils(environment)

   scoreboard sco_h;

   AHB_agt m_agt_h;

   QSPI_agt sl_agt_h;

   env_cfg m_cfg;

  function new(string name = "environment",uvm_component parent);
      super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase  phase);
      super.build_phase(phase);
      if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
	  `uvm_fatal(get_type_name(),"Failed to get configuration") //getting env_cfg handle in env

      if(m_cfg.has_scoreboard)
	sco_h = scoreboard::type_id::create("sco_h",this);//common scoreboard
	
      if(m_cfg.has_master_agent)
	begin
		m_agt_h = AHB_agt::type_id::create("m_agt_h",this);//AHB Lite Master Agent
		uvm_config_db#(AHB_cfg)::set(this,"m_agt_h*","AHB_cfg",m_cfg.p_cfg);
	end

      if(m_cfg.has_slave_agent)
      begin
                sl_agt_h = QSPI_agt::type_id::create("sl_agt_h",this);//QSPI Slave Agent
	        uvm_config_db#(QSPI_cfg)::set(this,"sl_agt_h*","QSPI_cfg",m_cfg.s_cfg);
      end

 endfunction
 
 function void connect_phase(uvm_phase phase);
	if(m_cfg.has_master_agent)
        begin
           m_agt_h.mon_h.ap.connect(sco_h.AHB_exp.analysis_export);//connecting AHB_mon's ap port to scoreboard's ms_exp tlm_fifo
        end
     /*	if(m_cfg.has_slave_agent)
	begin
	   sl_agt_h.mon_h.ap.connect(sco_h.QSPI_exp.analysis_export);//connecting QSPI_mon's ap port to scoreboard's sl_exp tlm_fifo
	end */
 endfunction

endclass
