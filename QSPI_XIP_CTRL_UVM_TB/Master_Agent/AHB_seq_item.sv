class AHB_seq_item extends uvm_sequence_item;
`uvm_object_utils(AHB_seq_item)

function new(string name = "AHB_seq_item");
	super.new(name);
endfunction

rand bit [31:0] HADDR;
rand bit  	HWRITE;
rand bit [2:0]  HSIZE;
rand bit [2:0] 	HBURST;
rand bit [3:0]  HPROT;
rand bit [1:0]  HTRANS;
rand bit [31:0] HWDATA;
rand bit  	HSEL;
rand bit        HMASTLOCK;

bit [31:0] HRDATA;
bit HREADYOUT;
bit HREADY;
bit HRESP;

bit [31:0] start_addr; 
int        burst_len;    

constraint haddr_c
{
	HADDR inside {[32'h0000_0000:32'h000F_FFFF]};
}

// ===== NEW: helper functions =====

// bytes per beat, from HSIZE (0->1, 1->2, 2->4, 3->8 ...)
function int size_bytes();
    case (HSIZE)
        3'b000: return 1;
        3'b001: return 2;
        3'b010: return 4;
        3'b011: return 8;
        3'b100: return 16;
        3'b101: return 32;
        3'b110: return 64;
        3'b111: return 128;
        default: return 0;
    endcase
endfunction// INCR type: INCR, INCR4, INCR8, INCR16
function bit is_incr();
	return (HBURST inside {3'b001, 3'b011, 3'b101, 3'b111});
endfunction

// WRAP type: WRAP4, WRAP8, WRAP16
function bit is_wrap();
	return (HBURST inside {3'b010, 3'b100, 3'b110});
endfunction

// INCR: next address is simply current + size
function bit [31:0] get_next_incr_addr(bit [31:0] current_addr);
	return current_addr + size_bytes();
endfunction

// WRAP: increment, but wrap back to the block start at the block end
function bit [31:0] get_next_wrap_addr(bit [31:0] current_addr);
	bit [31:0] block_size, block_start, block_end;

	block_size  = burst_len * size_bytes();
	block_start = (start_addr / block_size) * block_size;
	block_end   = block_start + block_size;

	if (current_addr + size_bytes() == block_end)
		return block_start;
	else
		return current_addr + size_bytes();
endfunction

// Single entry point: picks INCR or WRAP based on HBURST
function bit [31:0] get_next_addr(bit [31:0] current_addr);

    if (is_wrap())
        return get_next_wrap_addr(current_addr);

    else if (is_incr())
        return get_next_incr_addr(current_addr);

    else
        return current_addr; 

endfunction
function void  do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("HADDR",HADDR,$bits(HADDR),UVM_HEX);
	printer.print_field("HWRITE",HWRITE,1,UVM_BIN);
	printer.print_field("HSIZE",HSIZE,$bits(HSIZE),UVM_BIN);
	printer.print_field("HBURST",HBURST,$bits(HBURST),UVM_BIN);
	printer.print_field("HPROT",HPROT,$bits(HPROT),UVM_BIN);
	printer.print_field("HTRANS",HTRANS,$bits(HTRANS),UVM_BIN);
	printer.print_field("HWDATA",HWDATA,$bits(HWDATA),UVM_HEX);
	printer.print_field("HSEL",HSEL,1,UVM_BIN);
	printer.print_field("HREADY",HREADY,1,UVM_BIN);
	printer.print_field("HRDATA",HRDATA,$bits(HRDATA),UVM_HEX);
	printer.print_field("HREADYOUT",HREADYOUT,1,UVM_BIN);
	printer.print_field("HRESP",HRESP,1,UVM_BIN);
endfunction

endclass:AHB_seq_item
