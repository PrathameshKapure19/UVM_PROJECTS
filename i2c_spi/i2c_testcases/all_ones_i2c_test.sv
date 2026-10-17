class all_ones_i2c_test extends base_test;
	`uvm_component_utils(all_ones_i2c_test)
	
	vir_all_ones_write_seq seqh_w_ff;
	vir_all_ones_read_seq seqh_r_ff;
	vir_single_write_spi_seq seqh0;


	function new(string name = "all_ones_i2c_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_writes = 1;
		no_of_reads = 1;
		no_of_seq_item = 1;
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		seqh_w_ff = vir_all_ones_write_seq::type_id::create("seqh_w_ff");
		seqh_r_ff = vir_all_ones_read_seq::type_id::create("seqh_r_ff");
		seqh0     = vir_single_write_spi_seq::type_id::create("seqh0");
	
		phase.raise_objection(this);
		fork
		   begin
			seqh_w_ff.start(envh.vseqrh);
			seqh_r_ff.start(envh.vseqrh);
		   end
			seqh0.start(envh.vseqrh);
		join
		#50;
		phase.drop_objection(this);
	endtask

endclass


	

