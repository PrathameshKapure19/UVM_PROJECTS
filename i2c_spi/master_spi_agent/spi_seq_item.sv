class spi_seq_item extends uvm_sequence_item;

	`uvm_object_utils(spi_seq_item)
	
	randc bit [11:0] din;
	rand bit newd;
	bit [11:0] dout;
	bit done;
	
	constraint VALID_DATA
	{
		din inside{[0:4096]};
	}
	function new(string name = "spi_seq_item");
		super.new(name);
	endfunction:new


	function void do_print (uvm_printer printer);
		//super.do_print(printer);
		printer.print_field("din",din,$bits(din),UVM_HEX);
		printer.print_field("newd",newd,1,UVM_BIN);
		printer.print_field("done",done,1,UVM_BIN);
		printer.print_field("dout",dout,$bits(dout),UVM_HEX);
	endfunction:do_print
	
endclass:spi_seq_item
