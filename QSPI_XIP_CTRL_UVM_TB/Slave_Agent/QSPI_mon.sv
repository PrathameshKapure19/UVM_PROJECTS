class QSPI_mon extends uvm_monitor;
 `uvm_component_utils(QSPI_mon)

  env_cfg m_cfg;

  QSPI_cfg p_cfg;


  virtual QSPI_intf qspi_mon_if;

  uvm_analysis_port#(QSPI_seq_item) ap;

  function new(string name = "QSPI_mon",uvm_component parent);
	super.new(name,parent);
	ap = new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"failed to get configuration")
	if(!uvm_config_db#(QSPI_cfg)::get(this,"","QSPI_cfg",p_cfg))
		`uvm_fatal(get_type_name(),"failed to get configuration")

  endfunction

  function void connect_phase(uvm_phase phase);
		qspi_mon_if = p_cfg.qspi_if;
  endfunction

 task run_phase(uvm_phase phase);
	monitor_reset();
	monitor_read();	
 endtask

task monitor_reset();
bit [7:0] C66  = 'h0;
bit [7:0] C99  = 'h0;

	@(negedge qspi_mon_if.CS);
	
		for(int i = 0 ;i < 8;i++)
		begin 
			@(posedge qspi_mon_if.sck); 			
			C66[7-i] = qspi_mon_if.IO[0];
			//@(qspi_mon_if.qspi_mon_cb); 	
		end
		`uvm_info(get_type_name(),$sformatf("C66 = %0h",C66),UVM_LOW)
		if(C66 != 8'h66)
			`uvm_error(get_type_name(),"Failed to receive C66")
	

		for(int i = 0; i < 8;i++)
		begin
			@(posedge qspi_mon_if.sck);			
			C99[7-i] = qspi_mon_if.IO[0];
			//@(qspi_mon_if.qspi_mon_cb); 
		end

		if(C99 != 8'h99)
			`uvm_error(get_type_name(),"Failed to receive C99")
	


	@(posedge qspi_mon_if.CS);


endtask

task monitor_read();
	bit [7:0] C_A5;
	bit [7:0] C_EB = 'h0;

	QSPI_seq_item item,data2scb;

	
	@(negedge qspi_mon_if.CS)

	for(int i = 0; i < 8;i++)
	begin
	 	@(posedge qspi_mon_if.sck);
		C_EB[7 - i] = qspi_mon_if.IO[0];
		//@(qspi_mon_if.qspi_mon_cb);
	end

	if(C_EB == 8'hEB)
		`uvm_info(get_type_name(),$sformatf("C_EB = %0h",C_EB),UVM_LOW)

	else
		`uvm_error(get_type_name(),"Failed to receive EB command")	


	forever begin
		item = QSPI_seq_item::type_id::create("item");	
		for(int i = 0; i < 6;i++)
		begin
			@(posedge qspi_mon_if.sck);
			item.addr[23 - (i*4)-: 4] = qspi_mon_if.IO;

		end
		`uvm_info(get_type_name(),$sformatf("Address = %0h",item.addr),UVM_LOW);

		for(int i = 0; i <= 1; i++)
		begin
			@(posedge qspi_mon_if.sck);
			C_A5[7-(i*4) -:4] = qspi_mon_if.IO;
		end

		if(C_A5 != 8'hA5)
		begin
			`uvm_error(get_type_name(),"Failed to capture A5")
		end

		repeat(4)@(posedge qspi_mon_if.sck);//Dummy cycles

	
		item.data = m_cfg.mem_cfg_h.read_word(item.addr);
		data2scb = new item;
		ap.write(data2scb); 
	@(posedge qspi_mon_if.CS);
	end
endtask
	
endclass
