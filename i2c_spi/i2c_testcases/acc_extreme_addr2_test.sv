class acc_extreme_addr2_test extends base_test;
	`uvm_component_utils(acc_extreme_addr2_test)
	vir_acc_extreme_addr2_write seqh_addr_wr_2;
	vir_acc_extreme_addr2_read seqh_addr_rd_2;
	vir_single_write_spi_seq seqh0;

	function new(string name ="acc_extreme_addr2_test",uvm_component parent);
		super.new(name,parent);
         	no_of_writes = 1;
		no_of_reads = 1;
		no_of_seq_item = 1;
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		seqh_addr_wr_2 = vir_acc_extreme_addr2_write::type_id::create("seqh_addr_wr_2");
		seqh_addr_rd_2 = vir_acc_extreme_addr2_read::type_id::create("seqh_addr_rd_2");
		seqh0 = vir_single_write_spi_seq::type_id::create("seqh0");
		phase.raise_objection(this);
		fork
		begin
		 seqh_addr_wr_2.start(envh.vseqrh);
		 seqh_addr_rd_2.start(envh.vseqrh);
		end
	       	 seqh0.start(envh.vseqrh);
		join
		#20;
	
		phase.drop_objection(this);
	endtask
endclass

