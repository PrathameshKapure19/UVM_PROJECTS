class QSPI_seq_item extends uvm_sequence_item;
`uvm_object_utils(QSPI_seq_item)
 
  function new(string name = "QSPI_seq_item");
		super.new(name);
  endfunction

  bit [23:0] addr;

  bit [32:0] data;

endclass
