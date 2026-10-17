class base_virtual_seq extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(base_virtual_seq)
		
	`uvm_declare_p_sequencer(virtual_sequencer)

	master_sequencer m_seqrh[];

	spi_seqr spi_seqr_h[];

	env_config env_cfg;

	base_sequence seqh;

	spi_seq seq_h;

	function new(string name="base_virtual_seq");
		super.new(name);
	endfunction

	task body;
		seqh=base_sequence::type_id::create("seqh");
		seq_h = spi_seq::type_id::create("seq_h");

		if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")	

		m_seqrh=new[env_cfg.no_of_master_agents];
		spi_seqr_h = new[env_cfg.no_of_master_spi_agents];

		foreach(m_seqrh[i])
			m_seqrh[i]=p_sequencer.m_seqrh[i];
		foreach(spi_seqr_h[i])
			spi_seqr_h[i] = p_sequencer.spi_seqr_h[i];


	endtask

endclass

class reset_seq_v extends base_virtual_seq;

	`uvm_object_utils(reset_seq_v)

	reset_sequence rst_seq;
	single_write_spi_seq seqh_0;

	function new(string name="reset_seq_v");
		super.new(name);
	endfunction

	task body;
	
		super.body;

		rst_seq = reset_sequence::type_id::create("rst_seq");
		seqh_0  = single_write_spi_seq::type_id::create("seqh_0");
		
		fork
			rst_seq.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join

	endtask

endclass


class write_seq_v extends base_virtual_seq;

	`uvm_object_utils(write_seq_v)

	write_sequence wr_seq;
	

	function new(string name="write_seq_v");
		super.new(name);
	endfunction

	task body;
	
		super.body;

		wr_seq=write_sequence::type_id::create("wr_seq");
		
		wr_seq.start(m_seqrh[0]);

	endtask

endclass

class vir_ral_single_write_seq extends base_virtual_seq;
	`uvm_object_utils(vir_ral_single_write_seq)
	
	ral_single_write_seq seqh;
	single_write_spi_seq seqh_0;


	function new(string name = "vir_ral_single_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh = ral_single_write_seq::type_id::create("seqh");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");

		fork
			seqh.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join
	endtask		
	
endclass

class vir_ral_single_read_seq extends base_virtual_seq;
	`uvm_object_utils(vir_ral_single_read_seq)

	ral_single_read_seq seqh1;
	single_write_spi_seq seqh_0;

	function new(string name = "vir_ral_single_read_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh1 = ral_single_read_seq::type_id::create("seqh1");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		fork
			seqh1.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join
	endtask
endclass



class ral_write_seq_v extends base_virtual_seq;

	`uvm_object_utils(ral_write_seq_v)

	ral_write_sequence wr_seq;
	single_write_spi_seq seqh_0;

	function new(string name="ral_write_seq_v");
		super.new(name);
	endfunction

	task body;
	
		super.body;

		wr_seq=ral_write_sequence::type_id::create("wr_seq");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		fork
			wr_seq.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join
	endtask

endclass



class ral_read_seq_v extends base_virtual_seq;

	`uvm_object_utils(ral_read_seq_v)

	ral_read_sequence rd_seq;
	single_write_spi_seq seqh_0;

	function new(string name="ral_read_seq_v");
		super.new(name);
	endfunction

	task body;
	
		super.body;

		rd_seq = ral_read_sequence::type_id::create("rd_seq");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		fork
			rd_seq.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join

	endtask

endclass

class vir_all_ones_write_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_ones_write_seq)
	
	all_ones_write_seq seqh_ff;	


	function new(string name = "vir_all_ones_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_ff = all_ones_write_seq::type_id::create("seqh_ff");
			
			seqh_ff.start(m_seqrh[0]);
					
	endtask		
endclass

class vir_all_ones_read_seq extends base_virtual_seq;
	
	`uvm_object_utils(vir_all_ones_read_seq)

	all_ones_read_seq seqh_r_ff;
	
	function new(string name = "vir_all_ones_read");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_r_ff = all_ones_read_seq::type_id::create("seqh_r_ff");
		seqh_r_ff.start(m_seqrh[0]);		
	endtask
endclass
class vir_all_zero_write_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_zero_write_seq)
	
	all_zero_write_seq seqh_ff;
	function new(string name = "vir_all_zero_write_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_ff = all_zero_write_seq::type_id::create("seqh_ff");
		seqh_ff.start(m_seqrh[0]);
	endtask
endclass

class vir_all_zero_read_seq extends base_virtual_seq;
	
	`uvm_object_utils(vir_all_zero_read_seq)

	all_ones_read_seq seqh_r_ff;
	
	function new(string name = "vir_all_zero_read");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_r_ff = all_ones_read_seq::type_id::create("seqh_r_ff");
		seqh_r_ff.start(m_seqrh[0]);		
	endtask
endclass

class vir_acc_extreme_addr1_write extends base_virtual_seq;
	`uvm_object_utils(vir_acc_extreme_addr1_write)
	
	acc_extreme_addr1_write seqh_addr1;
	
	function new(string name = "vir_acc_extreme_addr1_write");
		super.new(name);
	endfunction 

	task body();
		super.body();
		seqh_addr1 = acc_extreme_addr1_write::type_id::create("seqh_addr1");
		seqh_addr1.start(m_seqrh[0]);
		
	endtask
endclass



class vir_acc_extreme_addr1_read extends base_virtual_seq;
	`uvm_object_utils(vir_acc_extreme_addr1_read)
	
	acc_extreme_addr1_read seqh_addr1;
	
	function new(string name = "vir_acc_extreme_addr1_read");
		super.new(name);
	endfunction 

	task body();
		super.body();
		seqh_addr1 = acc_extreme_addr1_read::type_id::create("seqh_addr1");
		seqh_addr1.start(m_seqrh[0]);
		
	endtask
endclass
class vir_acc_extreme_addr2_write extends base_virtual_seq;
	`uvm_object_utils(vir_acc_extreme_addr2_write)
	
	acc_extreme_addr2_write seqh_addr2;
	
	function new(string name = "vir_acc_extreme_addr2_write");
		super.new(name);
	endfunction 

	task body();
		super.body();
		seqh_addr2 = acc_extreme_addr2_write::type_id::create("seqh_addr2");
		seqh_addr2.start(m_seqrh[0]);
		
	endtask
endclass

class vir_acc_extreme_addr2_read extends base_virtual_seq;
	`uvm_object_utils(vir_acc_extreme_addr2_read)
	
	acc_extreme_addr2_read seqh_addr2;
	
	function new(string name = "vir_acc_extreme_addr2_read");
		super.new(name);
	endfunction 

	task body();
		super.body();
		seqh_addr2 = acc_extreme_addr2_read::type_id::create("seqh_addr2");
		seqh_addr2.start(m_seqrh[0]);
		
	endtask
endclass
class vir_default_seq_read extends base_virtual_seq;
	`uvm_object_utils(vir_default_seq_read)
	
		default_seq_read seqh;
		single_write_spi_seq seqh_0;
	function new(string name = "vir_default_seq_read");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh = default_seq_read::type_id::create("seqh");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		fork
		 seqh.start(m_seqrh[0]);
		 seqh_0.start(spi_seqr_h[0]);
		join		
	endtask
endclass

class vir_rst_after_ack1_seq extends base_virtual_seq;
	`uvm_object_utils(vir_rst_after_ack1_seq)
	rst_after_ack1_seq seqh;
	write_sequence wr_seq;
	function new(string name = "vir_rst_after_ack1_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		wr_seq = write_sequence::type_id::create("wr_seq");
		seqh = rst_after_ack1_seq::type_id::create("seqh");
		fork
			wr_seq.start(m_seqrh[0]);
			seqh.start(m_seqrh[0]);
			
		join
		
	endtask
endclass	
class vir_rst_after_ack2_seq extends base_virtual_seq;
	`uvm_object_utils(vir_rst_after_ack2_seq)
	rst_after_ack2_seq seqh;
	write_sequence wr_seq;
	function new(string name = "vir_rst_after_ack2_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		wr_seq = write_sequence::type_id::create("wr_seq");
		seqh = rst_after_ack2_seq::type_id::create("seqh");
		fork
			wr_seq.start(m_seqrh[0]);
			seqh.start(m_seqrh[0]);
			
		join
		
	endtask
endclass	




class rst_btw_seq_v extends base_virtual_seq;

	`uvm_object_utils(rst_btw_seq_v)

	reset_in_between_sequence rst_seq;
	write_sequence wr_seq;
	single_write_spi_seq seqh_0;

	function new(string name="rst_btw_seq_v");
		super.new(name);
	endfunction

	task body;
	
		super.body;

		wr_seq=write_sequence::type_id::create("wr_seq");
		rst_seq=reset_in_between_sequence::type_id::create("rst_seq");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		fork
		wr_seq.start(m_seqrh[0]);
		rst_seq.start(m_seqrh[0]);
		seqh_0.start(spi_seqr_h[0]);
		join
	endtask

endclass
class vir_full_mem_acc_seq extends base_virtual_seq;
	`uvm_object_utils(vir_full_mem_acc_seq)
	
	full_mem_acc_seq seqh_acc;
	single_write_spi_seq seqh_0;
	function new(string name = "vir_full_mem_acc_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_acc = full_mem_acc_seq::type_id::create("seqh_acc");
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");


		fork
			seqh_acc.start(m_seqrh[0]);
			seqh_0.start(spi_seqr_h[0]);
		join

	endtask
endclass

class vir_all_ones_stress_wr_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_ones_stress_wr_seq)

	all_ones_stress_wr_seq seqh_wr;

	function new(string name = "vir_all_ones_stress_wr_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_wr = all_ones_stress_wr_seq::type_id::create("seqh_wr");
		seqh_wr.start(m_seqrh[0]);
	endtask
	
endclass

class vir_all_ones_stress_rd_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_ones_stress_rd_seq)
	all_ones_stress_rd_seq seqh_rd;
	function new(string name = "vir_all_ones_stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_rd = all_ones_stress_rd_seq::type_id::create("seqh_rd");
		seqh_rd.start(m_seqrh[0]);
	endtask
	
endclass

class vir_all_zero_stress_wr_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_zero_stress_wr_seq)

	all_zero_stress_wr_seq seqh_wr;

	function new(string name = "vir_all_zero_stress_wr_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_wr = all_zero_stress_wr_seq::type_id::create("seqh_wr");
		seqh_wr.start(m_seqrh[0]);
	endtask
	
endclass


class vir_all_zero_stress_rd_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_zero_stress_rd_seq)
	all_zero_stress_rd_seq seqh_rd;
	function new(string name = "vir_all_zero_stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_rd = all_zero_stress_rd_seq::type_id::create("seqh_rd");
		seqh_rd.start(m_seqrh[0]);
	endtask
	
endclass

class vir_stress_rd_seq extends base_virtual_seq;
	`uvm_object_utils(vir_stress_rd_seq)

	stress_rd_seq seqh_rd;

	function new(string name = "vir_stress_rd_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_rd = stress_rd_seq::type_id::create("seqh_wr");
		seqh_rd.start(m_seqrh[0]);
	endtask
	
endclass

class vir_direct_seq extends base_virtual_seq;
	`uvm_object_utils(vir_direct_seq)
	direct_seq seqh;
	function new(string name = "vir_direct_seq");
		super.new(name);
	endfunction
	task body();
		super.body();
		seqh = direct_seq::type_id::create("seqh");
		seqh.start(m_seqrh[0]);
	endtask
endclass





//SPI virtual sequence extended classes 
class vir_single_write_spi_seq extends base_virtual_seq;
	`uvm_object_utils(vir_single_write_spi_seq)
	
	single_write_spi_seq seqh_0;
	function new(string name = "vir_single_write_spi_seq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		seqh_0 = single_write_spi_seq::type_id::create("seqh_0");
		seqh_0.start(spi_seqr_h[0]);
	endtask
	
endclass

class vir_write_spi_seq extends base_virtual_seq;
	`uvm_object_utils(vir_write_spi_seq)

	write_spi_seq seqh_1;
	function new(string name  = "vir_write_spi_seq");
		super.new(name);
	endfunction
	task body();
		super.body();
		seqh_1 = write_spi_seq::type_id::create("seqh_1");
		seqh_1.start(spi_seqr_h[0]);
	endtask
endclass

class vir_all_ones_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_ones_seq)
	
	all_ones_seq seqh_2;
	function new(string name ="vir_all_ones_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_2 = all_ones_seq::type_id::create("seqh_2");
		seqh_2.start(spi_seqr_h[0]);
	endtask 

endclass

class vir_all_zeros_seq extends base_virtual_seq;
	`uvm_object_utils(vir_all_zeros_seq)
	
	all_zeros_seq seqh_3;
	function new(string name ="vir_all_ones_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_3 = all_zeros_seq::type_id::create("seqh_3");
		seqh_3.start(spi_seqr_h[0]);
	endtask 

endclass

class vir_newd_seq extends base_virtual_seq;
	`uvm_object_utils(vir_newd_seq)

	newd_seq seqh_4;

	function new(string name = "vir_newd_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_4 = newd_seq::type_id::create("seqh_4");
		seqh_4.start(spi_seqr_h[0]);
	endtask
endclass

class vir_alter_value_seq extends base_virtual_seq;
	`uvm_object_utils(vir_alter_value_seq)
	
	alter_value_seq seqh_5;

	function new(string name = "vir_alter_value_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		seqh_5 = alter_value_seq::type_id::create("seqh_5");
		seqh_5.start(spi_seqr_h[0]);
			
	endtask
endclass



