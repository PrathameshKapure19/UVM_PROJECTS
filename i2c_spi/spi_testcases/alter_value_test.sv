class alter_value_test extends base_test;
	`uvm_component_utils(alter_value_test)

	vir_alter_value_seq seqh_5;
		
	modify_data_cb cb;
	function new(string name = "alter_value_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		no_of_seq_item = 1;
	endfunction
	
	task run_phase(uvm_phase phase);
		seqh_5 = vir_alter_value_seq::type_id::create("seqh_5");
		phase.raise_objection(this);
		seqh_5.start(envh.vseqrh);
		#50;
		phase.drop_objection(this);
	endtask

	 function void end_of_elaboration_phase(uvm_phase phase);

      		super.end_of_elaboration_phase(phase);

     		cb = modify_data_cb::type_id::create("cb");

      		uvm_callbacks#(spi_ms_drv,spi_drv_cb)::add(envh.ms_ag_h[0].drv_h,cb);

   	endfunction

endclass
