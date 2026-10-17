class direct_test extends base_test;
	`uvm_component_utils(direct_test)
	vir_direct_seq seqh;
	
	function new(string name = "direct_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	task run_phase(uvm_phase phase);
		seqh = vir_direct_seq::type_id::create("seqh");
		phase.raise_objection(this);
		seqh.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass
