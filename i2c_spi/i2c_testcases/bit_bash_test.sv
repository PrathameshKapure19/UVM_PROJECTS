class bit_bash_test extends base_test;

	`uvm_component_utils(bit_bash_test)

	function new(string name = "bit_bash_seq",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		uvm_reg_bit_bash_seq seqh;
		seqh = uvm_reg_bit_bash_seq::type_id::create("seqh");
		phase.raise_objection(this);
		seqh.model = mem_blk_h;
		seqh.start(null);
		phase.drop_objection(this);
	endtask
endclass
