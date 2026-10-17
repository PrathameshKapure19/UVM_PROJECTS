class mem_adapter extends uvm_reg_adapter;

  `uvm_object_utils(mem_adapter)

  function new(string name="mem_adapter");
    super.new(name);

    supports_byte_enable = 0;
    provides_responses   = 0;
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

	    i2c_trans xtn;
	    xtn = i2c_trans::type_id::create("xtn");
	    xtn.addr = rw.addr;
	    xtn.din = rw.data;
	    xtn.wr   = (rw.kind == UVM_WRITE);
	    return xtn;

  endfunction


  virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);

	    i2c_trans xtn;

	    if(!$cast(xtn,bus_item))
	      `uvm_fatal("ADAPTER","Cast Failed")

	    rw.addr   = xtn.addr;
	    if(xtn.wr)
	    	rw.data   = xtn.din;
	    else
			rw.data = xtn.datard;
	    	
	    rw.kind   = xtn.wr ? UVM_WRITE : UVM_READ;
	    rw.status = UVM_IS_OK;
  
  endfunction

endclass
