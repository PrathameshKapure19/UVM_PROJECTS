class ral_single_write_test extends base_test;
	`uvm_component_utils(ral_single_write_test)
	
	vir_ral_single_write_seq s_write_seqh;

	function new(string name = "ral_single_write_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		no_of_writes = 1;
		no_of_seq_item = 1;
	endfunction

	task run_phase(uvm_phase phase);
		s_write_seqh = vir_ral_single_write_seq::type_id::create("s_write_seqh");
		phase.raise_objection(this);
		s_write_seqh.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass


