class all_ones_test extends base_test;
	`uvm_component_utils(all_ones_test)
	vir_all_ones_seq seqh2;
	function new(string name = "all_ones_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		no_of_seq_item = 1;
	endfunction

	task run_phase (uvm_phase phase);
		seqh2 = vir_all_ones_seq::type_id::create("seqh2");
		phase.raise_objection(this);
		seqh2.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass

