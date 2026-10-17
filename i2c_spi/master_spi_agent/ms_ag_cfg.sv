class ms_ag_cfg extends uvm_object;

	`uvm_object_utils(ms_ag_cfg)
		
	virtual spi_if ms_if;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;
		

	function new(string name = "ms_ag_cfg");
		super.new(name);
	endfunction:new
endclass:ms_ag_cfg
