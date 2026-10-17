class default_value_test extends base_test;

	`uvm_component_utils(default_value_test)
		
	vir_default_seq_read seqh;

	function new(string name = "default_value_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_reads = 1; 
		no_of_seq_item = 1;
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		seqh = vir_default_seq_read::type_id::create("seqh");
		phase.raise_objection(this);
		seqh.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask
endclass
