class QSPI_agt extends uvm_agent;
	`uvm_component_utils(QSPI_agt)
	QSPI_drv drv_h;

	QSPI_mon mon_h;

	QSPI_cfg m_cfg;

	function new(string name = "QSPI_agt",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(QSPI_cfg)::get(this,"","QSPI_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Failed to get configuration")
		mon_h = QSPI_mon::type_id::create("mon_h",this);
		if(m_cfg.is_active)
		begin
			drv_h = QSPI_drv::type_id::create("drv_h",this);
		end
	endfunction
endclass
