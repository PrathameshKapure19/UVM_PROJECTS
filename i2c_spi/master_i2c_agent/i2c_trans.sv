
class i2c_trans extends uvm_sequence_item;
  
  `uvm_object_utils(i2c_trans);
  
  rand bit rst;
  rand bit wr;
  randc bit[6:0]addr;
  randc bit[7:0]din;
  bit[7:0] datard;
  bit done;
  
	constraint VALID_ADDRESS
	{
		addr inside {[0:127]};
	}

	constraint VALID_DATA
	{
		din inside {[0:255]};
	}

  function new(string name="i2c_trans");
    super.new(name);
  endfunction
  
  function void do_print(uvm_printer printer);
    printer.print_field("write read enable",wr,1,UVM_BIN);
    printer.print_field("address",addr,7,UVM_HEX);
    printer.print_field("data in",din,8,UVM_HEX);
    printer.print_field("data out",datard,8,UVM_HEX);
    printer.print_field("done",done,1,UVM_BIN);
    printer.print_field("reset",rst,1,UVM_BIN);
  endfunction
  
endclass
