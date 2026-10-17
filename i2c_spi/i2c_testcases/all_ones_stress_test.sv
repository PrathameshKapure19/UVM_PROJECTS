class all_ones_stress_test extends base_test;
	`uvm_component_utils(all_ones_stress_test)

	vir_all_ones_stress_wr_seq seqh_wr;
	vir_all_ones_stress_rd_seq seqh_rd;

	function new(string name = "all_ones_stress_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
			no_of_writes = 128;
			no_of_reads = 128;
			super.build_phase(phase);
	endfunction
	task run_phase(uvm_phase phase);
		seqh_wr = vir_all_ones_stress_wr_seq::type_id::create("seqh_wr");
		seqh_rd = vir_all_ones_stress_rd_seq::type_id::create("seqh_rd");

		phase.raise_objection(this);
		seqh_wr.start(envh.vseqrh);
		seqh_rd.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass
