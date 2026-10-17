class flash_mem_cfg extends uvm_object;
`uvm_object_utils(flash_mem_cfg)

 localparam int MEM_SIZE = 1024*1024;

 bit [7:0] mem [int];

typedef bit [255:0] cache_line;

cache_line cache_mem [bit[3:0]];

bit [14:0] cache_tag [bit[3:0]];

bit cache_valid [bit[3:0]];


 function new(string name = "flash_mem_cfg");
	super.new(name);
 endfunction

 task init();
	for(int i = 0;i < MEM_SIZE;i++)
	begin
		mem[i] = 8'hFF;
	end
 endtask

 task write_byte ();
	for(int i = 0; i < MEM_SIZE;i++)
	begin
		mem[i] = $random;
	end
 endtask
function bit[3:0] read_nibble(input bit [23:0] addr,int nibble_index);
	if((nibble_index % 2) == 0)
		return mem[addr + (nibble_index / 2)][7:4];
	else
		return mem[addr + (nibble_index / 2)][3:0];
	
endfunction

task cache_read(input bit [23:0] addr);
	bit [3:0] index;
	bit [14:0] tag;
	bit [255:0] line_data;

	index = addr[8:5];
	tag = addr[23:9];
	for(int i = 0 ; i < 32; i++)
	begin
		line_data[i*8 +:8] = mem[addr + i];
	end
	cache_mem[index] = line_data;
	cache_tag[index] = tag;
	cache_valid[index] = 1'b1;
endtask

 function bit [31:0] read_word(input bit [23:0] addr);

        bit [3:0]  index;
        bit [2:0]  word_sel;
        bit [14:0] tag;

        index    = addr[8:5];
        word_sel = addr[4:2];
        tag      = addr[23:9];

        if (!cache_mem.exists(index)) begin
            `uvm_error("CACHE",
                $sformatf("Cache index %0h does not exist", index))
            return 32'h0;
        end

        if (!cache_valid[index]) begin
            `uvm_error("CACHE",
                $sformatf("Cache index %0h is invalid", index))
            return 32'h0;
        end

        if (cache_tag[index] != tag) begin
            `uvm_error("CACHE",
                $sformatf("Cache tag mismatch at index %0h", index))
            return 32'h0;
        end

        return cache_mem[index][word_sel*32 +: 32];

    endfunction


endclass
