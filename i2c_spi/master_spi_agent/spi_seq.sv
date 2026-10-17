class spi_seq extends uvm_sequence#(spi_seq_item);

	`uvm_object_utils(spi_seq)
	
	env_config env_cfg;


	function new(string name = "spi_seq");
		super.new(name);
	endfunction:new
	
	task body();
		req = spi_seq_item::type_id::create("req") ;
		if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg))
			`uvm_fatal(get_full_name(),"config getting failed")

			
	endtask:body
endclass:spi_seq

class single_write_spi_seq extends spi_seq;
	`uvm_object_utils(single_write_spi_seq)
	
	function new (string name = "single_write_spi_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
			start_item(req);
			assert(req.randomize()with{newd == 1'b1;});
			finish_item(req);
		end
	endtask
endclass

class write_spi_seq extends spi_seq;
	`uvm_object_utils(write_spi_seq)

	function new (string name = "write_spi_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
		 start_item(req);
		 assert(req.randomize()with {newd == 1'b1;});
		 finish_item(req);
		end
	endtask
endclass

class all_ones_seq extends spi_seq;
	`uvm_object_utils(all_ones_seq)

	function new(string name = "all_ones_seq");
	  super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
			start_item(req);
			assert(req.randomize()with{newd == 1'b1;din == 12'hfff;});
			finish_item(req);	
		end
	endtask
endclass:all_ones_seq
class all_zeros_seq extends spi_seq;
	`uvm_object_utils(all_zeros_seq)

	function new(string name = "all_zeros_seq");
	  super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
			start_item(req);
			assert(req.randomize()with{newd == 1'b1;din == 12'h000;});
			finish_item(req);	
		end
	endtask
endclass:all_zeros_seq

class newd_seq extends spi_seq;
	`uvm_object_utils(newd_seq)
	function new(string name = "newd_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
			start_item(req);
			assert(req.randomize()with{newd == 1'b1;});
			finish_item(req);
		end
	endtask
endclass

class alter_value_seq extends spi_seq;
	`uvm_object_utils(alter_value_seq)
	function new(string name = "alter_value_seq");
		super.new(name);
	endfunction

	task body();
		super.body();
		repeat(env_cfg.no_of_seq_item)
		begin
			start_item(req);
			assert(req.randomize()with{newd == 1'b1;});
			finish_item(req);
		end
	endtask
endclass



