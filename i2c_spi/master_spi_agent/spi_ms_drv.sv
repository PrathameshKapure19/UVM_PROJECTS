class spi_ms_drv extends uvm_driver#(spi_seq_item);
	`uvm_component_utils(spi_ms_drv)
	`uvm_register_cb(spi_ms_drv,spi_drv_cb)

	ms_ag_cfg m_cfg;
	
	virtual spi_if.MS_DRV ms_drv_if;

	function new(string name = "spi_ms_drv",uvm_component parent);
		super.new(name,parent);
	endfunction:new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ms_ag_cfg)::get(this,"","ms_ag_cfg",m_cfg))
			`uvm_fatal(get_full_name,"cannot find configuration in config db")
		
	endfunction:build_phase

	function void connect_phase(uvm_phase phase);
		ms_drv_if = m_cfg.ms_if;
	endfunction:connect_phase

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive_item(req);
			seq_item_port.item_done();
		end
			
	endtask:run_phase
	
	
	task drive_item(spi_seq_item item);
		@(ms_drv_if.ms_drv_cb);
		ms_drv_if.ms_drv_cb.newd <= item.newd;
		`uvm_do_callbacks(spi_ms_drv,spi_drv_cb,pre_drive(req))

		ms_drv_if.ms_drv_cb.din  <= item.din;
		`uvm_info(get_type_name(),$sformatf("Master_Driver:%s",item.sprint),UVM_LOW)
		@(ms_drv_if.ms_drv_cb);
		ms_drv_if.ms_drv_cb.newd <= 1'b0;
		wait(ms_drv_if.ms_drv_cb.done == 1'b1);
		@(ms_drv_if.ms_drv_cb);
	endtask:drive_item

endclass:spi_ms_drv
