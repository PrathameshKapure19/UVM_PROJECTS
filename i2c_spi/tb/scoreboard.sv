class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(i2c_trans) master_fifo[];
	uvm_tlm_analysis_fifo #(spi_seq_item) ms_spi_exp[];

	i2c_trans m_xtn;
	spi_seq_item ms_spi_item;

	env_config env_cfg;

	int ref_mem[int];

	mem_block mem_blk_h;
	mem_block_back mem_blk_b_h;

	// SPI Data fields
        bit [11:0] cov_spi_din;
	bit cov_newd;
     
      covergroup spi_cg;
	
		CP_SPI_NEWD: coverpoint cov_newd
		{
	               bins HIGH = {1'b1};
		       
		}

		CP_SPI_DATA : coverpoint cov_spi_din
		{
    			bins ZERO = {12'h000};
    			bins LOW  = {[12'h001:12'h3FF]};
    			bins MID  = {[12'h400:12'hBFF]};
    			bins HIGH = {[12'hC00:12'hFFE]};
    			bins MAX  = {12'hFFF};
		}
 		cross CP_SPI_NEWD,CP_SPI_DATA;	
	    
        endgroup

	// I2C Data fields
        bit cov_i2c_wr;
  	bit[6:0] cov_i2c_addr;
  	bit[7:0] cov_i2c_din;
	
	covergroup i2c_cg;

                  CP_I2C_WR : coverpoint cov_i2c_wr

		  {
			bins HIGH_wr = {1'b1};
			bins LOW_wr  = {1'b0};
			
		  }

                  CP_I2C_ADDR : coverpoint cov_i2c_addr
    
		{	
			bins ZERO    = {0};
   			bins ADDR_0 = {[1:15]};
    			bins ADDR_1 = {[16:31]};
    			bins ADDR_2 = {[32:47]};
    			bins ADDR_3 = {[48:63]};
   			bins ADDR_4 = {[64:79]};
   			bins ADDR_5 = {[80:95]};
    			bins ADDR_6 = {[96:111]};
    			bins ADDR_7 = {[112:126]};
			bins MAX    = {127};
		}
                  CP_I2C_DIN : coverpoint cov_i2c_din
		{
    			bins ZERO_in = {8'h00};
    			bins LOW  = {[8'h01:8'h3F]};
    			bins MID  = {[8'h40:8'hBF]};
    			bins HIGH = {[8'hC0:8'hFE]};
    			bins FF_in   = {8'hFF};
		}
                 cross CP_I2C_WR, CP_I2C_ADDR, CP_I2C_DIN;

     endgroup
	
	
        int no_of_i2c_writes;
	int no_of_i2c_reads;
	int no_of_spi_writes;
	int i2c_pass;
	int i2c_fail;
	int spi_pass;
	int spi_fail;
	int addr[$];

	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
                spi_cg = new();
		i2c_cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")

		master_fifo=new[env_cfg.no_of_master_agents];
		ms_spi_exp = new[env_cfg.no_of_master_spi_agents];

		foreach(master_fifo[i])
			master_fifo[i]=new($sformatf("master_fifo[%0d]",i),this);
	
		foreach(ms_spi_exp[i])
			ms_spi_exp[i] = new($sformatf("ms_spi_exp[%0d]",i),this);


	endfunction

	function void connect_phase(uvm_phase phase);
		mem_blk_h=env_cfg.mem_blk_h;
		mem_blk_b_h=env_cfg.mem_blk_b_h;
	endfunction

	task run_phase(uvm_phase phase);
	fork
		forever
		begin
			master_fifo[0].get(m_xtn);

			
			if(m_xtn.rst)
			begin
				check_reset;
			end
			else if(m_xtn.wr == 1'b1)
			begin
				no_of_i2c_writes++;
				write_mem(m_xtn);
				cov_i2c_wr   = m_xtn.wr;
			        cov_i2c_addr = m_xtn.addr;
			        cov_i2c_din  = m_xtn.din;
				
			end
			else if(m_xtn.wr==0)
			begin
				no_of_i2c_reads++;
				read_mem(m_xtn);
					cov_i2c_wr   = m_xtn.wr;
			        cov_i2c_addr = m_xtn.addr;
			        cov_i2c_din  = m_xtn.datard;


			end
			i2c_cg.sample();
		end
		forever 
		begin
				ms_spi_exp[0].get(ms_spi_item);
				check_data(ms_spi_item);
                                cov_newd = ms_spi_item.newd;
                                cov_spi_din = ms_spi_item.din;
	                        spi_cg.sample();
		end
	join
	endtask:run_phase

	task write_mem(i2c_trans xtn);
		 
		uvm_status_e    status;
		uvm_reg_data_t  data;
		ref_mem[xtn.addr]=xtn.din;
		mem_blk_b_h.regs[xtn.addr].read(status,data,UVM_BACKDOOR);
		if(ref_mem[xtn.addr]==data)
		begin
			i2c_pass++;
			`uvm_info(get_type_name(),$sformatf("data written succesfull %0d %0d",ref_mem[xtn.addr],data),UVM_LOW)
		end
		else
		begin
			i2c_fail++;
			`uvm_error(get_type_name(),$sformatf("data writing failed %0d %0d %0d",xtn.addr,ref_mem[xtn.addr],data))	
		end
	endtask:write_mem
		

	task check_reset;
		uvm_status_e    status;
		uvm_reg_data_t  data;
		bit error;
		for(int i=0;i<128;i++)
		begin
			mem_blk_b_h.regs[i].read(status,data,UVM_BACKDOOR);
			mem_blk_h.reset;
			ref_mem[i]=0;
			if(data==ref_mem[i])
				error=0;
			else
				error=1;
		end
		if(error)
			`uvm_error(get_type_name(),"dut reset failed")
		else
			`uvm_info(get_type_name(),"dut reset sucessfull",UVM_LOW)
	endtask:check_reset

	task read_mem(i2c_trans m_xtn);
		
		uvm_status_e    status;
		uvm_reg_data_t  data;
		if(ref_mem.exists(m_xtn.addr))
		begin
			
			if(ref_mem[m_xtn.addr]==m_xtn.datard)
			begin
				i2c_pass++;	
				

				`uvm_info(get_type_name(),"data read successfull",UVM_LOW)
			end
			else
			begin
				i2c_fail++;
				`uvm_error(get_type_name(),"data read failed")
			end
		end
		else
		begin
			mem_blk_b_h.regs[m_xtn.addr].read(status,data,UVM_BACKDOOR);
			if(data==m_xtn.datard)
			begin 
				i2c_pass++;
				`uvm_info(get_type_name(),"data read successfull from ral",UVM_LOW)
			end
			else
			begin
				i2c_fail++;
				`uvm_error(get_type_name(),"data read failed")
			end
		
		end
		
	endtask:read_mem

	task check_data(spi_seq_item ms_spi_item);
		no_of_spi_writes++;
		if(ms_spi_item.din == ms_spi_item.dout)
		begin
			spi_pass++;
			`uvm_info(get_type_name(),$sformatf("DATA MATCH|Expected = 0x%0h| Actual = 0x%0h|",ms_spi_item.din,ms_spi_item.dout),UVM_MEDIUM)
		end
		else
		begin
			spi_fail++;
			`uvm_error(get_type_name(),$sformatf("DATA MISMATCH|Expected = 0x%0h| Actual = 0x%0h|",ms_spi_item.din,ms_spi_item.dout))			  
		end
	endtask:check_data

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),
			$sformatf(
			{"\n========================== Scoreboard Report ==========================\n",
			 "number of i2c_writes = %0d\n",
			 "number of i2c reads  = %0d\n",
			 "number of spi writes = %0d\n",
			 "i2c pass = %0d\n",
			 "i2c fail = %0d\n",
			 "spi pass = %0d\n",
			 "spi fail = %0d\n",
			 "========================================================================"},
			no_of_i2c_writes,
			no_of_i2c_reads,
			no_of_spi_writes,
			i2c_pass,
			i2c_fail,
			spi_pass,
			spi_fail
			),UVM_LOW)
			
		  `uvm_info("COV",$sformatf("I2C Coverage = %0.2f%%", i2c_cg.get_coverage()),UVM_LOW)

                  `uvm_info("COV",$sformatf("SPI Coverage = %0.2f%%", spi_cg.get_coverage()),UVM_LOW)	
				
			
	endfunction:report_phase

				
endclass
