class newd_test extends base_test;
	`uvm_component_utils(newd_test)

	vir_newd_seq seqh_4;
	function new(string name = "newd_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		spi_ms_drv::type_id::set_type_override(test_driver::get_type());
		super.build_phase(phase);
		no_of_seq_item = 1;
	endfunction
	
	task run_phase(uvm_phase phase);
		seqh_4 = vir_newd_seq::type_id::create("seqh_4");
		phase.raise_objection(this);
		seqh_4.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass
