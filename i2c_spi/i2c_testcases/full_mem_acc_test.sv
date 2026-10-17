class full_mem_acc_test extends base_test;
	`uvm_component_utils(full_mem_acc_test)

	vir_full_mem_acc_seq seq_acc;

	function new(string name = "full_mem_acc_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_writes = 128;
		no_of_reads  = 128;
		no_of_seq_item = 1;
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		seq_acc = vir_full_mem_acc_seq::type_id::create("seq_acc");
		phase.raise_objection(this);
		seq_acc.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask

		
endclass



