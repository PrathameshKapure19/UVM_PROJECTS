class AHB_mon extends uvm_monitor;

`uvm_component_utils(AHB_mon)

 virtual AHB_intf ahb_mon_if;
 
 AHB_cfg m_cfg;

 AHB_seq_item data_queue[$];

AHB_seq_item item;

 uvm_analysis_port#(AHB_seq_item) ap;
 
 function new(string name = "AHB_mon",uvm_component parent);
 	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(AHB_cfg)::get(this,"","AHB_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Failed to get Configuration")
	ap = new("ap",this);
 endfunction

function void connect_phase(uvm_phase phase);
	ahb_mon_if = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
@(posedge ahb_mon_if.HCLK);



 	monitor_addr();
	monitor_data();		
endtask
task monitor_addr();

forever begin
 if (ahb_mon_if.HREADY == 1'b1 && ahb_mon_if.HSEL == 1'b1 && (ahb_mon_if.HTRANS == 2'b10 || ahb_mon_if.HTRANS == 2'b11))
 begin

            item = AHB_seq_item::type_id::create("item");

            item.HADDR     = ahb_mon_if.HADDR;
            item.HWRITE    = ahb_mon_if.HWRITE;
            item.HSIZE     = ahb_mon_if.HSIZE;
            item.HBURST    = ahb_mon_if.HBURST;
            item.HPROT     = ahb_mon_if.HPROT;
            item.HTRANS    = ahb_mon_if.HTRANS;
            item.HMASTLOCK = ahb_mon_if.HMASTLOCK;
            item.HSEL      = ahb_mon_if.HSEL;
	    data_queue.push_back(item);
end
	while (!ahb_mon_if.HREADY)
      	begin	
                @(posedge ahb_mon_if.HCLK);
      	end


		@(posedge ahb_mon_if.HCLK);
end
endtask

task monitor_data();
AHB_seq_item item,data2scb;
forever begin
	wait(data_queue.size() > 0)
		item = data_queue.pop_front();
	@(posedge ahb_mon_if.HCLK);
	while(!ahb_mon_if.HREADY)
	begin	
         @(posedge ahb_mon_if.HCLK);
	end
	if (item.HWRITE)
              item.HWDATA = ahb_mon_if.HWDATA;
        else if(!item.HWRITE)
              item.HRDATA = ahb_mon_if.HRDATA;
	data2scb = new item;     
	ap.write(data2scb);


end
endtask		
endclass


