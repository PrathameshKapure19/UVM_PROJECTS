class single_write_spi_test extends base_test;
	`uvm_component_utils(single_write_spi_test)

	vir_single_write_spi_seq seqh0;

	function new(string name = "single_write_spi_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_seq_item = 1;
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		seqh0 = vir_single_write_spi_seq::type_id::create("seqh0");
		phase.raise_objection(this);
		seqh0.start(envh.vseqrh);
		phase.drop_objection(this);		
	endtask
endclass

