class AHB_cfg extends uvm_object;
	`uvm_object_utils(AHB_cfg)

	virtual AHB_intf vif;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	function new(string name = "AHB_cfg");
		super.new(name);
	endfunction
endclass
