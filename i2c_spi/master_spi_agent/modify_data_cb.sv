class modify_data_cb extends spi_drv_cb;
	`uvm_object_utils(modify_data_cb)

	function new(string name = "modify_data_cb");
		super.new(name);
	endfunction

	virtual task pre_drive(spi_seq_item req);
		req.din = 12'hABC;
	endtask
endclass
