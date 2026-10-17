class reset_test extends base_test;

	`uvm_component_utils(reset_test)

	reset_seq_v seqh;

	function new(string name="reset_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_seq_item = 1;
		super.build_phase(phase);

	endfunction

	task run_phase(uvm_phase phase);
		seqh=reset_seq_v::type_id::create("seqh");
	
		phase.raise_objection(this);
		seqh.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
		
	endtask

endclass

