class rst_after_ack2_test extends base_test;
	`uvm_component_utils(rst_after_ack2_test)

	vir_rst_after_ack2_seq seqh;

	function new(string name = "rst_after_ack2_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_writes = 1;
		super.build_phase(phase);
	endfunction

	task run_phase (uvm_phase phase);
		seqh = vir_rst_after_ack2_seq::type_id::create("seqh");
		phase.raise_objection(this);
		seqh.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
	
endclass
