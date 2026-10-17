
class master_driver extends uvm_driver#(i2c_trans);
  `uvm_component_utils(master_driver)          
  
  virtual i2c_if.M_DRV_MP vif;
  
  master_config m_cfg;
  
  function new(string name="master_driver",uvm_component parent);
    super.new(name,parent);
    endfunction
  
  function void build_phase(uvm_phase phase);
    
    if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
      `uvm_fatal(get_full_name(),"config getting failed");
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    vif=m_cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(req);
        send_to_dut(req); 
        seq_item_port.item_done;
      end
  endtask
  /*
  task reset_dut();
    @(vif.m_drv_cb);
    vif.m_drv_cb.rst<=1'b1;
    repeat(2)
    @(vif.m_drv_cb);
    vif.m_drv_cb.rst<=1'b0;	`uvm_info(get_type_name(),$sformatf("driving %s",req.sprint),UVM_LOW)
  endtask*/
  
  task send_to_dut(i2c_trans xtn);
 
	fork
	begin
		wait(vif.m_drv_cb.rst==0);
	  	vif.m_drv_cb.rst<=xtn.rst;
    		vif.m_drv_cb.wr<=xtn.wr;
		vif.m_drv_cb.addr<=xtn.addr;
		vif.m_drv_cb.din<=xtn.din;
		`uvm_info(get_type_name(),$sformatf("driving %s",req.sprint),UVM_LOW)
   
		@(vif.m_drv_cb);
	
  		if(xtn.rst)
		begin
			repeat(2)@(vif.m_drv_cb);
			vif.m_drv_cb.rst<=1'b0;
		end
		else
			@(posedge vif.m_drv_cb.done);
		vif.m_drv_cb.wr <= 1'bx;
		xtn.datard = vif.m_drv_cb.datard;
		xtn.done=vif.m_drv_cb.done;
	end
	begin
		@(posedge vif.m_drv_cb.rst);
		vif.m_drv_cb.wr<=xtn.wr;
  		vif.m_drv_cb.addr<=0;
    		vif.m_drv_cb.din<=0;
		@(negedge vif.m_drv_cb.rst);
	
	end
	join_any
	disable fork;
		
  endtask
  
endclass
