
class master_monitor extends uvm_monitor;

  `uvm_component_utils(master_monitor)
  
  virtual i2c_if.M_MON_MP vif;
  
  i2c_trans xtn,data2sb;
  
  master_config m_cfg;
  
  uvm_analysis_port #(i2c_trans) ap;
  
  function new(string name="master_monitor",uvm_component parent);
    super.new(name,parent);
    ap=new("ap",this);
    endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
      `uvm_fatal(get_full_name(),"config getting failed");
    	xtn=i2c_trans::type_id::create("xtn");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    vif=m_cfg.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    forever
	begin
		fork
			read_monitor();
			write_monitor();
			rst_monitor();
		join_any
		//disable fork;
		`uvm_info(get_type_name(),$sformatf("sampling %s",xtn.sprint),UVM_LOW)
      		data2sb=new xtn;
     		ap.write(data2sb);
	end
  endtask
  

task read_monitor;
	 @(vif.m_mon_cb);
	wait(vif.m_mon_cb.wr==0 && vif.m_mon_cb.rst==0 && vif.m_mon_cb.done==1);
	xtn.wr=vif.m_mon_cb.wr;
	xtn.rst=vif.m_mon_cb.rst;
	xtn.addr=vif.m_mon_cb.addr;
   	xtn.din=vif.m_mon_cb.din;

	xtn.datard=vif.m_mon_cb.datard;

endtask

task write_monitor;
	 @(vif.m_mon_cb);
	wait(vif.m_mon_cb.wr==1 && vif.m_mon_cb.rst==0 && vif.m_mon_cb.done==1);
	xtn.wr=vif.m_mon_cb.wr;
	xtn.rst=vif.m_mon_cb.rst;
	xtn.addr=vif.m_mon_cb.addr;
   	xtn.din=vif.m_mon_cb.din;
		
	
	xtn.datard=vif.m_mon_cb.datard;
	
endtask

task rst_monitor;
	 @(vif.m_mon_cb);
	@(posedge vif.m_mon_cb.rst);
	xtn.wr=vif.m_mon_cb.wr;
	xtn.rst=vif.m_mon_cb.rst;
	xtn.addr=vif.m_mon_cb.addr;
   	xtn.din=vif.m_mon_cb.din;
		
	xtn.datard=vif.m_mon_cb.datard;
endtask

/*
  task monitor;
fork
begin
   @(vif.m_mon_cb);
	wait(vif.m_mon_cb.rst==0 && (vif.m_mon_cb.wr==0 || vif.m_mon_cb.wr==1));
	xtn.wr=vif.m_mon_cb.wr;
	xtn.rst=vif.m_mon_cb.rst;
	if(vif.m_mon_cb.rst==1)begin
		repeat(1)@(vif.m_mon_cb);end
	else
		repeat(21)@(vif.m_mon_cb);//wait(vif.m_mon_cb.done==1);
	
   	
   	
   	xtn.addr=vif.m_mon_cb.addr;
   	xtn.din=vif.m_mon_cb.din;
		
	
	xtn.datard=vif.m_mon_cb.datard;
	

        `uvm_info(get_type_name(),$sformatf("sampling %s",xtn.sprint),UVM_LOW)
      data2sb=new xtn;
     ap.write(data2sb);
    @(vif.m_mon_cb);end
begin
	@(posedge vif.m_mon_cb.rst);
	xtn.rst=vif.m_mon_cb.rst;
	xtn.addr=vif.m_mon_cb.addr;
   	xtn.din=vif.m_mon_cb.din;
		
	
	xtn.datard=vif.m_mon_cb.datard;
	 `uvm_info(get_type_name(),$sformatf("sampling %s",xtn.sprint),UVM_LOW)
      data2sb=new xtn;
     ap.write(data2sb);@(negedge vif.m_mon_cb.rst);
	end
	join_any
	disable fork;
  endtask*/
  
endclass
        

