class base_sequence extends uvm_sequence#(i2c_trans);

	`uvm_object_utils(base_sequence)

	env_config env_cfg;
	mem_block mem_blk_h;
	mem_block_back mem_blk_b_h;
	virtual i2c_if vif;

	bit[7:0]rdata_dv,rdata_mv;
	uvm_status_e status;
	uvm_reg_data_t data;

	function new(string name="base_sequence");
		super.new(name);
	endfunction

	task body;
		if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")
		if(!uvm_config_db#(virtual i2c_if)::get(null,"uvm_test_top.envh","i2c_if",vif))
			`uvm_fatal("reset_in_between_sequence","config getting failed")
		init_vif;
		mem_blk_h=env_cfg.mem_blk_h;
		mem_blk_b_h=env_cfg.mem_blk_b_h;
	endtask

	task init_vif;
		vif.rst<=0;
		vif.din<=0;
		vif.addr<=0;
		vif.datard<=0;
	endtask		
	

endclass


class reset_sequence extends base_sequence;

	`uvm_object_utils(reset_sequence)

	function new(string name="reset_sequence");
		super.new(name);
	endfunction

	task body();
		super.body;

		req=i2c_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize with {rst==1'b1;});
		`uvm_info(get_full_name(),$sformatf("the generated transaction %s",req.sprint),UVM_LOW)
		finish_item(req);

	endtask

endclass 

class write_sequence extends base_sequence;

	`uvm_object_utils(write_sequence)
	
	function new(string name="write_sequence");
		super.new(name);
	endfunction

	task body();
		
		super.body;

		repeat(env_cfg.no_of_writes)
		begin
			req=i2c_trans::type_id::create("req");
			start_item(req);
			assert(req.randomize with {wr==1'b1;rst==0;});
			`uvm_info(get_full_name(),$sformatf("the generated transaction %s",req.sprint),UVM_LOW)
			finish_item(req);
	
		end

/*		
		

				
      		mem_blk_h.regs[16].write(status, 8'd8, UVM_FRONTDOOR);	#260;	
		rdata_dv = mem_blk_h.regs[16].get();	
#10;
		//rdata_mv = mem_blk_h.regs[16].get_mirrored_value();
//`uvm_info(get_type_name(), $sformatf(" before write method Desired value is %0d, & Mirrored value is %0d", rdata_dv, rdata_mv), UVM_NONE)
//		mem_blk_h.regs[16].mirror(status,.path(UVM_FRONTDOOR),.parent(this));			
		rdata_mv = mem_blk_h.regs[16].get_mirrored_value();
		`uvm_info(get_type_name(), $sformatf(" After write method Desired value is %0d, & Mirrored value is %0d", rdata_dv, rdata_mv), UVM_NONE)
      
*/      			
		
	endtask

endclass 

class ral_single_write_seq extends base_sequence;
	`uvm_object_utils(ral_single_write_seq)
	function new(string name = "ral_single_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
		    req = i2c_trans::type_id::create("req");
		    assert(req.randomize()with{wr == 1'b1;rst == 1'b0;});
		    mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);	
		end
	endtask
endclass

class ral_single_read_seq extends base_sequence;
	`uvm_object_utils(ral_single_read_seq)
	
	function new(string name = "ral_single_read_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		req = i2c_trans::type_id::create("req");
		assert(req.randomize()with{wr == 1'b0;rst == 1'b0;});
		mem_blk_b_h.regs[req.addr].write(status,req.din,UVM_BACKDOOR);
		mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		
	endtask 
endclass


class ral_write_sequence extends base_sequence;

	`uvm_object_utils(ral_write_sequence)

	function new(string name="ral_write_sequence");
		super.new(name);
	endfunction

	task body;
		super.body;

		repeat(env_cfg.no_of_writes)
		begin
			req=i2c_trans::type_id::create("req");
			assert(req.randomize with {wr==1'b1;rst==0;});
			mem_blk_h.regs[req.addr].write(status,req.din, UVM_FRONTDOOR);
		end

	endtask

endclass



class ral_read_sequence extends base_sequence;

	`uvm_object_utils(ral_read_sequence)

	function new(string name="ral_read_sequence");
		super.new(name);
	endfunction

	task body;
		super.body;

		repeat(env_cfg.no_of_reads)
		begin
			req=i2c_trans::type_id::create("req");
			assert(req.randomize with {wr==1'b0;rst==0;});
			mem_blk_b_h.regs[req.addr].write(status, req.din,UVM_BACKDOOR);			
			mem_blk_h.regs[req.addr].read(status, data, UVM_FRONTDOOR);
		end

	endtask

endclass

class all_ones_write_seq extends base_sequence;
	`uvm_object_utils(all_ones_write_seq)
	function new(string name = "all_ones_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize() with {wr == 1'b1; rst == 1'b0;din == 8'hff;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
endclass

class all_ones_read_seq extends base_sequence;
	
	`uvm_object_utils(all_ones_read_seq)

	function new(string name = "all_ones_read_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		
		repeat(env_cfg.no_of_reads)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with {wr == 1'b0;rst == 1'b0;din == 8'hff;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
endclass
class all_zero_write_seq extends base_sequence;
	`uvm_object_utils(all_zero_write_seq)
	function new(string name = "all_zero_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize() with {wr == 1'b1; rst == 1'b0;din == 8'h00;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
endclass

class all_zero_read_seq extends base_sequence;
	
	`uvm_object_utils(all_zero_read_seq)

	function new(string name = "all_zero_read_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		
		repeat(env_cfg.no_of_reads)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with {wr == 1'b0;rst == 1'b0;din == 8'h00;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
endclass
class acc_extreme_addr1_write extends base_sequence;
	`uvm_object_utils(acc_extreme_addr1_write)
       function new(string name = "acc_extreme_addr1_write");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b1; rst == 1'b0; addr == 0;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
endclass

class acc_extreme_addr1_read extends base_sequence;
	`uvm_object_utils(acc_extreme_addr1_read)
       function new(string name = "acc_extreme_addr1_read");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_reads)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b0; rst == 1'b0; addr == 0;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
endclass

class acc_extreme_addr2_write extends base_sequence;
	`uvm_object_utils(acc_extreme_addr2_write)
       function new(string name = "acc_extreme_addr2_write");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b1; rst == 1'b0; addr == 127;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
endclass

class acc_extreme_addr2_read extends base_sequence;
	`uvm_object_utils(acc_extreme_addr2_read)
       function new(string name = "acc_extreme_addr2_read");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_reads)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b0; rst == 1'b0; addr == 127;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
endclass

class full_mem_acc_seq extends base_sequence;
	`uvm_object_utils(full_mem_acc_seq)

	function new(string name = "full_mem_acc_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		req = i2c_trans::type_id::create("req");
		begin
		
				for(int i = 0; i < env_cfg.no_of_writes;i++)
				begin
					assert(req.randomize()with{wr == 1'b1;rst == 1'b0;addr == i;});
					mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
				end
					
				for(int i = 0; i < env_cfg.no_of_reads;i++)
				begin
					assert(req.randomize()with{wr == 1'b0;rst == 1'b0;addr == i;});
					mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
				end
			
		end
	endtask
endclass





class reset_in_between_sequence extends base_sequence;

	`uvm_object_utils(reset_in_between_sequence)

	

	function new(string name="reset_in_between_sequence");
		super.new(name);
	endfunction

	task body;
		super.body;
		


		repeat(80)
		@(posedge vif.clk);

		vif.rst<=1'b1;

		repeat(6)
		@(posedge vif.clk);

		vif.rst<=1'b0;

	endtask

endclass

class default_seq_read extends base_sequence;
	`uvm_object_utils(default_seq_read)
	
	function new(string name = "default_seq_read");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_reads)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize() with{wr == 1'b0; rst == 1'b0;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
						
		end	
	endtask
endclass

class rst_after_ack1_seq extends base_sequence;
	`uvm_object_utils(rst_after_ack1_seq)

	function new(string name = "rst_after_ack1_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			wait(vif.state == 4'b0011);
			vif.rst = 1'b1;
			repeat(1)@(posedge vif.clk);
			vif.rst = 1'b0;
		end
		
	endtask
endclass

class rst_after_ack2_seq extends base_sequence;
	`uvm_object_utils(rst_after_ack2_seq)

	function new(string name = "rst_after_ack2_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_writes)
		begin
			wait(vif.state == 4'b0101);
			vif.rst = 1'b1;
			repeat(1)@(posedge vif.clk);
			vif.rst = 1'b0;
		end
		
	endtask
endclass





	

class all_ones_stress_wr_seq extends base_sequence;
	`uvm_object_utils(all_ones_stress_wr_seq)

	function new(string name = "all_ones_stress_wr_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0; i < env_cfg.no_of_writes;i++)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din == 8'hFF;addr == i;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
	
endclass

class all_ones_stress_rd_seq extends base_sequence;
	`uvm_object_utils(all_ones_stress_rd_seq)

	function new(string name = "all_ones_stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0; i < env_cfg.no_of_reads;i++)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b0;rst == 1'b0;addr == i;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
	
endclass

class all_zero_stress_wr_seq extends base_sequence;
	`uvm_object_utils(all_zero_stress_wr_seq)

	function new(string name = "all_zero_stress_wr_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0; i < env_cfg.no_of_writes;i++)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din == 8'h00;addr == i;});
			mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		end
	endtask
	
endclass

class all_zero_stress_rd_seq extends base_sequence;
	`uvm_object_utils(all_zero_stress_rd_seq)

	function new(string name = "all_zero_stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0; i < env_cfg.no_of_reads;i++)
		begin
			req = i2c_trans::type_id::create("req");
			assert(req.randomize()with{wr == 1'b0;rst == 1'b0;addr == i;});
			mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		end
	endtask
	
endclass

class stress_rd_seq extends base_sequence;
	`uvm_object_utils(stress_rd_seq)

	function new(string name = "stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();

	
	
			for(int j = 0; j < env_cfg.no_of_reads;j++)
			begin
				req = i2c_trans::type_id::create("req");
				assert(req.randomize()with{wr == 1'b0;rst == 1'b0;din == 8'hFF;addr == j;});
				mem_blk_b_h.regs[req.addr].write(status,req.din,UVM_BACKDOOR);
				mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
			end

	endtask
	
endclass

class direct_seq extends base_sequence;
	`uvm_object_utils(direct_seq)

	function new(string name = "direct_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		req = i2c_trans::type_id::create("req");
		assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din inside {[8'hC0:8'hFE]};addr == 0;});
		mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din inside {[8'h40:8'hBF]};addr == 127;});
		mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din inside {[8'h01:8'h3F]};addr == 127;});
		mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);
		assert(req.randomize()with{wr == 1'b1;rst == 1'b0;din == 0;addr == 0;});
		mem_blk_h.regs[req.addr].write(status,req.din,UVM_FRONTDOOR);
		mem_blk_h.regs[req.addr].read(status,data,UVM_FRONTDOOR);


	endtask
	
endclass




								
