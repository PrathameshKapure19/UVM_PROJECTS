class ral_single_read_test extends base_test;
	`uvm_component_utils(ral_single_read_test)

	vir_ral_single_read_seq s_read_seqh;

	function new(string name = "ral_single_read_test",uvm_component parent);
			super.new(name,parent);	
	endfunction

	function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			no_of_reads = 1;
			no_of_seq_item = 1;
	endfunction

	task run_phase(uvm_phase phase);
		s_read_seqh = vir_ral_single_read_seq::type_id::create("s_read_seqh");
		phase.raise_objection(this);
		s_read_seqh.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
	
endclass
	

