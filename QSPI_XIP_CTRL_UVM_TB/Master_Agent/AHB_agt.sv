class AHB_agt extends uvm_agent;

     `uvm_component_utils(AHB_agt)

	AHB_drv drv_h;
	AHB_mon mon_h;
	AHB_seqr seqr_h;
	AHB_cfg m_cfg;	
   
      function new(string name = "AHB_agt",uvm_component parent);
             super.new(name,parent);
      endfunction

      function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(AHB_cfg)::get(this,"","AHB_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Failed to get configuration")

		mon_h = AHB_mon::type_id::create("mon_h",this);

		if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drv_h  = AHB_drv::type_id::create("AHB_drv",this);
			seqr_h = AHB_seqr::type_id::create("AHB_seqr",this);
		end
	endfunction

       function void connect_phase(uvm_phase phase);
		if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drv_h.seq_item_port.connect(seqr_h.seq_item_export);
		end
       endfunction



     

endclass
