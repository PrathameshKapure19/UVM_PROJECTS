class QSPI_cfg extends uvm_object;
	`uvm_object_utils(QSPI_cfg)

	virtual QSPI_intf qspi_if;

	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	function new(string name = "QSPI_cfg");
		super.new(name);
	endfunction

	
endclass
