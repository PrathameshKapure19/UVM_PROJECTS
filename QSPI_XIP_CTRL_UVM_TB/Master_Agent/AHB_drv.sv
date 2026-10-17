class AHB_drv extends uvm_driver#(AHB_seq_item);
`uvm_component_utils(AHB_drv)

virtual AHB_intf.AHB_DRV ahb_drv_if;

AHB_cfg m_cfg;

AHB_seq_item data_queue[$];

function new(string name = "AHB_drv",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	if(!uvm_config_db#(AHB_cfg)::get(this,"","AHB_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Failed to get configuration")
endfunction
function void connect_phase(uvm_phase phase);
	ahb_drv_if = m_cfg.vif;	
endfunction

task run_phase(uvm_phase phase);
@(posedge ahb_drv_if.HCLK);
	
           fork
	    addr_phase();	 
	    data_phase();
	   join


endtask

task addr_phase();
AHB_seq_item item;
forever begin	
seq_item_port.get_next_item(item);


   ahb_drv_if.HADDR     <= item.HADDR;
   ahb_drv_if.HWRITE    <= item.HWRITE;
   ahb_drv_if.HSIZE     <= item.HSIZE;
   ahb_drv_if.HBURST    <= item.HBURST;
   ahb_drv_if.HPROT     <= item.HPROT;
   ahb_drv_if.HTRANS    <= item.HTRANS;
   ahb_drv_if.HMASTLOCK <= item.HMASTLOCK;
   ahb_drv_if.HSEL      <= item.HSEL;

data_queue.push_back(item);

while(!ahb_drv_if.HREADY)
begin
	@(posedge ahb_drv_if.HCLK);
end

	

if(ahb_drv_if.HRESP)
begin
	ahb_drv_if.HTRANS <= 2'b00;
	
end
@(posedge ahb_drv_if.HCLK);

seq_item_port.item_done();

end
endtask

task data_phase();

AHB_seq_item item;
forever begin		
	wait (data_queue.size() > 0)
		item = data_queue.pop_front();
	@(posedge ahb_drv_if.HCLK);
	while(!ahb_drv_if.HREADY)
	begin	
         @(posedge ahb_drv_if.HCLK);
	end


       	 if(item.HWRITE == 1'b1)
         begin
	      ahb_drv_if.HWDATA <= item.HWDATA;
         end
         else if(item.HWRITE == 1'b0)
         begin
              item.HRDATA <= ahb_drv_if.HRDATA;
	 end

  end  
endtask



endclass
