class stress_rd_test extends base_test;
	`uvm_component_utils(stress_rd_test)

	stress_rd_seq seqh_rd;
	

	function new(string name = "stress_rd_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
			no_of_reads = 128;
			super.build_phase(phase);
	endfunction
	task run_phase(uvm_phase phase);
		seqh_rd = stress_rd_seq::type_id::create("seqh_wr");
	

		phase.raise_objection(this);
		seqh_rd.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass
