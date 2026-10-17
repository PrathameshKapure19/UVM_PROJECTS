class spi_ms_ag extends uvm_agent;
	`uvm_component_utils(spi_ms_ag)

	spi_ms_drv drv_h;
	spi_ms_mon mon_h;
 	spi_seqr spi_seqr_h;
	ms_ag_cfg m_cfg;

	function new(string name = "spi_ms_ag",uvm_component parent);
		super.new(name,parent);
	endfunction:new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(ms_ag_cfg)::get(this,"","ms_ag_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"cannot get m_cfg from ms_ag_cfg")
	
		mon_h = spi_ms_mon::type_id::create("mon_h",this);
		if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drv_h = spi_ms_drv::type_id::create("drv_h",this);
			spi_seqr_h = spi_seqr::type_id::create("spi_seqr_h",this);
		end

		super.build_phase(phase);
	endfunction:build_phase

	function void connect_phase(uvm_phase phase);
		if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drv_h.seq_item_port.connect(spi_seqr_h.seq_item_export);
		end
	endfunction:connect_phase
	

endclass:spi_ms_ag
