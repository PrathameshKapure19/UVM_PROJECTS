class QSPI_drv extends uvm_driver#(QSPI_seq_item);

`uvm_component_utils(QSPI_drv)

virtual QSPI_intf qspi_drv_if;

env_cfg m_cfg;
QSPI_cfg p_cfg;


function new(string name = "QSPI_drv",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Failed to get Configuration")
	if(!uvm_config_db#(QSPI_cfg)::get(this,"","QSPI_cfg",p_cfg))
		`uvm_fatal(get_type_name(),"Failed to get Configuration")

endfunction

function void connect_phase(uvm_phase phase);
	qspi_drv_if = p_cfg.qspi_if;
endfunction

task run_phase(uvm_phase phase);

	flash_init();
	flash_read();
endtask

task flash_init();
bit [7:0] C66  = 'h0;
bit [7:0] C99  = 'h0;
bit [7:0] C_EB = 'h0;
bit reset_enable  = 1'b0;
bit mem_wr_enable = 1'b0;

		@(negedge qspi_drv_if.CS);
	
		for(int i = 0 ;i < 8;i++)
		begin 
			@(posedge qspi_drv_if.sck);	
			C66[7-i] = qspi_drv_if.IO[0];	
		end

		if(C66 == 8'h66)
			`uvm_info(get_type_name(),$sformatf("C_66 = %0h",C66),UVM_LOW)
		else
			`uvm_error(get_type_name(),"Failed to receive C66")


		for(int j = 0; j < 8;j++)
		begin	
			@(posedge qspi_drv_if.sck);	
			C99[7-j] = qspi_drv_if.IO[0]; 
		end
		

		if(C99 == 8'h99)
		begin
			`uvm_info(get_type_name(),$sformatf("C_99 = %0h",C99),UVM_LOW)
			reset_enable = 1'b1;
		end		
		else
			`uvm_error(get_type_name(),"Failed to receive C99")

		if(reset_enable)
		begin
			m_cfg.mem_cfg_h.init();	
			mem_wr_enable = 1'b1;	
		end
		else
			`uvm_error(get_type_name(),"Failed to initialize memory.")

		if(mem_wr_enable)
		begin
			m_cfg.mem_cfg_h.write_byte();	
		end
		else
			`uvm_error(get_type_name(),"Failed to write bytes in memory.")

		@(posedge qspi_drv_if.CS);	

		

endtask
task flash_read();
	bit [23:0] addr;
	bit [7:0] C_A5 = 'h0;
	bit [7:0] C_EB = 'h0;


	@(negedge qspi_drv_if.CS);

	for(int i = 0; i < 8;i++)
	begin
		@(posedge qspi_drv_if.sck);	
		C_EB[7 - i] = qspi_drv_if.IO[0];
		
	end
	if(C_EB == 8'hEB)
		`uvm_info(get_type_name(),$sformatf("C_EB = %0h",C_EB),UVM_LOW)
	else
		`uvm_error(get_type_name(),"Failed to receive EB command")



	

	forever begin
	for(int i = 0; i < 6;i++)
	begin
		@(posedge qspi_drv_if.sck);
		addr[23 - (i*4)-: 4] = qspi_drv_if.IO;
		
					
	end
	`uvm_info(get_type_name(),$sformatf("Address = %0h",addr),UVM_LOW)	
		for(int i = 0; i <= 1; i++)
		begin
			@(posedge qspi_drv_if.sck);
			C_A5[7-(i*4) -:4] = qspi_drv_if.IO;
		
		end
		`uvm_info(get_type_name(),$sformatf("C_A5 = %0h",C_A5),UVM_LOW)

		if(C_A5 != 8'hA5)
		begin
			`uvm_error(get_type_name(),"Failed to capture A5")
		end

		m_cfg.mem_cfg_h.cache_read(addr);

		repeat(4)@(posedge qspi_drv_if.sck);//Dummy cycles

	
		qspi_drv_if.slv_IO_oe = 1'b1;
	
			
		for(int nibble_idx = 0 ; nibble_idx < 64;nibble_idx++)
		begin
			@(posedge qspi_drv_if.sck);		
			qspi_drv_if.slv_IO_drv <= m_cfg.mem_cfg_h.read_nibble(addr,nibble_idx);
		end
		@(posedge qspi_drv_if.CS);		
	
		qspi_drv_if.slv_IO_oe = 1'b0;

		
	end

endtask
endclass
