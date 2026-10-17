class all_zeros_test extends base_test;
	`uvm_component_utils(all_zeros_test)
	vir_all_zeros_seq seqh3;
	function new(string name = "all_zeros_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		no_of_seq_item = 1;
	endfunction

	task run_phase (uvm_phase phase);
		seqh3 = vir_all_zeros_seq::type_id::create("seqh3");
		phase.raise_objection(this);
		seqh3.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass
	
