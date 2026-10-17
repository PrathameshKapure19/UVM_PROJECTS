class spi_drv_cb extends uvm_callback;

	`uvm_object_utils(spi_drv_cb)

	function new(string name = "spi_drv_cb");
		super.new(name);
	endfunction

  	virtual task pre_drive(spi_seq_item req);
  	endtask

endclass
