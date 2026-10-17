class write_spi_test extends base_test;
	`uvm_component_utils(write_spi_test)

	vir_write_spi_seq seqh1;

	function new(string name = "write_spi_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		no_of_seq_item = 10;
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		seqh1 = vir_write_spi_seq::type_id::create("seqh1");
		phase.raise_objection(this);
		seqh1.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass

