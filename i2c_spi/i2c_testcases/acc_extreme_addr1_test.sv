class acc_extreme_addr1_test extends base_test;
	`uvm_component_utils(acc_extreme_addr1_test)
	vir_acc_extreme_addr1_write seqh_addr_wr_1;
	vir_acc_extreme_addr1_read seqh_addr_rd_1;
	vir_single_write_spi_seq seqh0;

	function new(string name ="acc_extreme_addr1_test",uvm_component parent);
		super.new(name,parent);
         	no_of_writes = 1;
		no_of_reads = 1;
		no_of_seq_item = 1;

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		seqh_addr_wr_1 = vir_acc_extreme_addr1_write::type_id::create("seqh_addr_wr_1");
		seqh_addr_rd_1 = vir_acc_extreme_addr1_read::type_id::create("seqh_addr_rd_1");
		seqh0 = vir_single_write_spi_seq::type_id::create("seqh0");
		phase.raise_objection(this);
		fork
		begin
		 seqh_addr_wr_1.start(envh.vseqrh);
		
		 seqh_addr_rd_1.start(envh.vseqrh);
		end
		 seqh0.start(envh.vseqrh);	
		join
		#20;

		phase.drop_objection(this);
	endtask
endclass


