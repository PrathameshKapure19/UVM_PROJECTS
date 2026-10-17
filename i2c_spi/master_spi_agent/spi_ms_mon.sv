class spi_ms_mon extends uvm_monitor;
	`uvm_component_utils(spi_ms_mon)

	virtual spi_if.MS_MON ms_mon_if;
	ms_ag_cfg m_cfg;

	uvm_analysis_port#(spi_seq_item) monitor_port;

	function new(string name = "spi_ms_mon",uvm_component parent);
		super.new(name,parent);
		
	endfunction:new

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(ms_ag_cfg)::get(this,"","ms_ag_cfg",m_cfg))
			`uvm_fatal(get_full_name(),"Cannot get m_cfg in config db")
		super.build_phase(phase);
		monitor_port = new("monitor_port",this);
	endfunction:build_phase

	function void connect_phase(uvm_phase phase);
		ms_mon_if = m_cfg.ms_if;
	endfunction:connect_phase

	task run_phase (uvm_phase phase);
		forever 
		begin
			monitor_item();
		end
	endtask:run_phase
	
	task monitor_item();
		spi_seq_item item;
		item = spi_seq_item::type_id::create("item",this);
		wait(ms_mon_if.ms_mon_cb.newd == 1'b1);
		item.newd = ms_mon_if.ms_mon_cb.newd;
		item.din  = ms_mon_if.ms_mon_cb.din;
		`uvm_info(get_type_name(),$sformatf("Master_monitor input data :%s",item.sprint()),UVM_LOW)
		wait(ms_mon_if.ms_mon_cb.done == 1'b1);
		item.dout = ms_mon_if.ms_mon_cb.dout;
		item.done = ms_mon_if.ms_mon_cb.done;
		`uvm_info(get_type_name(),$sformatf("Master_monitor output data :%s",item.sprint()),UVM_LOW)
		monitor_port.write(item);
				
		@(ms_mon_if.ms_mon_cb);

	endtask:monitor_item
endclass:spi_ms_mon
