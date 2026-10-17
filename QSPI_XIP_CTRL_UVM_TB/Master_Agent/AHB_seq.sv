class AHB_seq extends uvm_sequence#(AHB_seq_item);
    `uvm_object_utils(AHB_seq)

     AHB_seq_item req;
   
     env_cfg m_cfg;

    function new(string name = "AHB_seq");
	super.new(name);
    endfunction

    task body();
	if(!uvm_config_db#(env_cfg)::get(null,get_full_name(),"env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Failed to get configuration.")

	

    endtask

endclass

class AHB_seq1 extends AHB_seq;
`uvm_object_utils(AHB_seq1)

AHB_seq_item req;

	function new(string name = "AHB_seq1");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0 ;i < m_cfg.no_of_seq_item;i++)
		begin
			req = AHB_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize()
			with{ 
				HSEL == 1'b1;
			 	HWRITE == 1'b0;
				if(i == 0)
					HTRANS == 2'b10;
				else
					HTRANS == 2'b00;
			});
			finish_item(req);
		end
	endtask

endclass

class AHB_seq2 extends AHB_seq;
`uvm_object_utils(AHB_seq2)

AHB_seq_item req;

	function new(string name = "AHB_seq2");
		super.new(name);
	endfunction
	
	task body();
		super.body();
		for(int i = 0; i < m_cfg.no_of_seq_item;i++)
		begin
			req = AHB_seq_item::type_id::create("req");
			start_item(req);
			assert(req.randomize()with{HSEL == 1'b1; HWRITE == 1'b0;HTRANS == 2'b10;});
			finish_item(req);
		end
	endtask

endclass

class AHB_seq3 extends AHB_seq;

    `uvm_object_utils(AHB_seq3)

    AHB_seq_item req;

    function new(string name = "AHB_seq3");
        super.new(name);
    endfunction

    task body();

        super.body();

        for (int i = 0; i < m_cfg.no_of_seq_item; i++)
	 begin

            req = AHB_seq_item::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {
			HSEL == 1'b1;
			HWRITE == 1'b0;
			HADDR  == 32'h0001_0000 + (i * 4);

		if(i == 0)
			HTRANS == 2'b10;
		else
			HTRANS == 2'b11;

		
            });

            finish_item(req);

        end

    endtask

endclass

class AHB_seq4 extends AHB_seq;
`uvm_object_utils(AHB_seq4)

AHB_seq_item req;

rand bit [31:0] start_addr;

constraint c_start_addr {
	start_addr % 4 == 0;
	start_addr inside {[32'h0000_0000 : 32'h000F_FFFF]};
}

function new(string name = "AHB_seq4");
	super.new(name);
endfunction

task body();
	bit [31:0] addr;

	super.body();

	assert(this.randomize())
		else `uvm_fatal(get_type_name(), "Sequence randomize failed")

	addr = start_addr;

	for (int i = 0; i < m_cfg.no_of_seq_item; i++) begin
		req = AHB_seq_item::type_id::create("req");
		start_item(req);

		// context for get_next_addr()
		req.start_addr = start_addr;
		req.burst_len  = 4;

		assert(req.randomize() with {
			HSEL == 1'b1;
			HWRITE == 1'b0;
			HADDR  == addr;
			HSIZE  == 3'b010;       // word, same for all 4 beats
			HBURST == 3'b011;       // INCR4

			if (i == 0)
				 HTRANS == 2'b10;   // NONSEQ
			else    
				 HTRANS == 2'b11;   // SEQ
		});

		finish_item(req);

		addr = req.get_next_addr(addr);   // plain +4 for INCR
	end
endtask
endclass
class AHB_seq5 extends AHB_seq;
    `uvm_object_utils(AHB_seq5)

    AHB_seq_item req;

    rand bit [31:0] start_addr;

    constraint c_start_addr {
        start_addr inside {[32'h0000_0000 : 32'h000F_FFFF]}; 
    }

    function new(string name = "AHB_seq5");
        super.new(name);
    endfunction

    task body();
        bit [31:0] addr;

        super.body();

        assert(this.randomize());

        addr = start_addr;

        for (int i = 0; i < 8; i++) begin

            req = AHB_seq_item::type_id::create($sformatf("req_%0d", i));

            start_item(req);
            req.start_addr = start_addr;   // first address of the burst
            req.burst_len  = 8;

            assert(req.randomize() with {
                HSEL   == 1'b1;
		HWRITE == 1'b0;
                HADDR  == addr;
                HSIZE  == 3'b010;          // word
                HBURST == 3'b101;          // INCR8

                if (i == 0) 
			HTRANS == 2'b10;   // NONSEQ
                else        
			HTRANS == 2'b11;   // SEQ
            });

            finish_item(req);
            addr = req.get_next_addr(addr);
        end
    endtask

endclass
class AHB_seq6 extends AHB_seq;
	`uvm_object_utils(AHB_seq6)
	function new(string name = "AHB_seq6");
		super.new(name);
	endfunction
rand bit [31:0] start_addr;  


constraint c_start_addr {
	start_addr inside {[32'h0000_0000 : 32'h000F_FFFF]};
	start_addr[1:0] == 0;
}

task body();
	bit [31:0] addr;

	super.body();

	assert(this.randomize());

	addr = start_addr;

	for (int i = 0; i < m_cfg.no_of_seq_item; i++) begin
		req = AHB_seq_item::type_id::create("req");
		start_item(req);
		req.start_addr = start_addr;
		req.burst_len  = 4;

		assert(req.randomize() with {
			HADDR  == addr;
			HSIZE  == 3'b010;       
			HBURST == 3'b010;       
			HSEL == 1'b1;
			HWRITE == 1'b0;
			if (i == 0) 
				HTRANS == 2'b10;
			else 
				HTRANS == 2'b11; 
	});
			finish_item(req);
		addr = req.get_next_addr(addr);
	end
endtask
endclass

class AHB_seq7 extends AHB_seq;
`uvm_object_utils(AHB_seq7)
AHB_seq_item req;
function new(string name = "AHB_seq7");
	super.new(name);
endfunction
rand bit [31:0] start_addr;  


constraint c_start_addr {
	
	start_addr inside {[32'h0000_0000 : 32'h000F_FFFF]};
	start_addr[1:0] == 0;
}

task body();
	bit [31:0] addr;

	super.body();

	assert(this.randomize());

	addr = start_addr;

	for (int i = 0; i < m_cfg.no_of_seq_item; i++) begin
		req = AHB_seq_item::type_id::create("req");
		start_item(req);
		req.start_addr = start_addr;
		req.burst_len  = 8;

		assert(req.randomize() with {
			HADDR  == addr;
			HSIZE  == 3'b010;       
			HBURST == 3'b100;       
			HSEL == 1'b1;
			HWRITE == 1'b0;
			if (i == 0) 
				HTRANS == 2'b10;
			else 
				HTRANS == 2'b11; 
	});
		finish_item(req);
		addr = req.get_next_addr(addr);
	end
endtask	
endclass
