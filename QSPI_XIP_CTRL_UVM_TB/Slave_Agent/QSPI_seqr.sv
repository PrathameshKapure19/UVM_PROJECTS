class QSPI_seqr extends uvm_sequencer#(QSPI_spi_item);
`uvm_component_utils(QSPI_seqr)

function new(string name = "QSPI_seqr",uvm_component parent);
	super.new(name,parent);
endfunction

endclass
