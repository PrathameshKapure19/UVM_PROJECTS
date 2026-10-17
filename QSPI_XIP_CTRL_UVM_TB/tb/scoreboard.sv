class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

 uvm_tlm_analysis_fifo#(AHB_seq_item) AHB_exp;

 AHB_seq_item  item1;

 uvm_event scb_event;

 env_cfg m_cfg;
 function new(string name = "scoreboard",uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Failed to get configuration")
	scb_event = new("scb_event");
	AHB_exp  = new("AHB_exp",this);
 endfunction

 task run_phase(uvm_phase phase);
	forever	begin
		AHB_exp.get(item1);
		check_data(item1);
		//scb_event.trigger();	
	end
	
	
 endtask

function bit [31:0] expected_value(input bit [23:0] addr);
bit [31:0]expected_word;
	expected_word = m_cfg.mem_cfg_h.read_word(addr);
	return expected_word;
endfunction 

 task check_data(AHB_seq_item item1);
 bit [31:0] expected_data;
expected_data = expected_value(item1.HADDR[23:0]);
	if(item1.HRDATA == expected_data)
	begin
   		`uvm_info(get_type_name(),$sformatf("ADDRESS = %0h|DATA Matched|ACTUAL_DATA = %0h|EXPECTED_DATA = %0h|",item1.HADDR,item1.HRDATA,expected_data),UVM_LOW)
	end
	else
	begin
   		`uvm_error(get_type_name(),$sformatf("ADDRESS = %0h|DATA Mismatched|ACTUAL_DATA = 0x%0h|EXPECTED_DATA = 0x%0h|",item1.HADDR,item1.HRDATA,expected_data))
	end
 
 endtask
 
 
endclass
