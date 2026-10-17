class rst_btw_test extends base_test;

	`uvm_component_utils(rst_btw_test)

	rst_btw_seq_v seqh;

	function new(string name="rst_btw_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_writes=5;
		no_of_seq_item = 1;
		super.build_phase(phase);

	endfunction

	task run_phase(uvm_phase phase);
		
		seqh=rst_btw_seq_v::type_id::create("seqh");

		phase.raise_objection(this);
		
		seqh.start(envh.vseqrh);
		//#300;
		phase.drop_objection(this);

	endtask

endclass



