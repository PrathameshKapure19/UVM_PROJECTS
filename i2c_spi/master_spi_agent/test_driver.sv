class test_driver extends spi_ms_drv;
	`uvm_component_utils(test_driver)

	virtual spi_if.MS_DRV ms_drv_if;

	ms_ag_cfg m_cfg;

	function new(string name = "test_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ms_ag_cfg)::get(this,"","ms_ag_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Failed to get configuration")
	endfunction

	function void connect_phase(uvm_phase phase);
		ms_drv_if = m_cfg.ms_if;
	endfunction

 	task run_phase (uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
	endtask

	task drive(spi_seq_item req);
		@(ms_drv_if.ms_drv_cb);
		ms_drv_if.ms_drv_cb.newd <= req.newd;
		ms_drv_if.ms_drv_cb.din <= req.din;
		repeat(10)@(ms_drv_if.ms_drv_cb);
		ms_drv_if.ms_drv_cb.newd <= 1'b0;
		wait(ms_drv_if.ms_drv_cb.done == 1'b1);
		@(ms_drv_if.ms_drv_cb);
	endtask
endclass
