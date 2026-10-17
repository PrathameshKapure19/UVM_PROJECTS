/*class reg_block extends uvm_reg_block;
	`uvm_object_utils(reg_block)

	rand reg_mem mem;
	uvm_reg_map reg_map;

	function new(string name="reg_block");
		super.new(name,"UVM_NO_COVERAGE");
	endfunction

	function void build();
		mem=reg_integer_file::type_id::create("mem");
		mem.configure(this,"");
		mem.add_hdl_path_slice("IRF.reg_file",0,32);
		add_hdl_path("top.DUV.DUT","RTL");
		reg_map=create_map("reg_map",'h0,4,UVM_LITTLE_ENDIAN,0);
		reg_map.add_mem(reg_file,5'h0,"RW");
		lock_model();

	endfunction

endclass
*/
/*
class mem_block extends uvm_reg_block;

  `uvm_object_utils(mem_block)

  rand reg_mem mem_h;

  uvm_reg_map mem_map;

  function new(string name="mem_block");
    super.new(name,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();


    mem_map = create_map("mem_map",'h0,1,UVM_LITTLE_ENDIAN);


    mem_h = reg_mem::type_id::create("mem_h");


    mem_h.configure(this);


   // mem_h.build();
																	
	//mem_map.set_auto_predict(1);		
    mem_map.add_mem(mem_h,'h00,"RW");

    lock_model();

  endfunction

endclass

*/



class mem_block extends uvm_reg_block;
  `uvm_object_utils(mem_block)

  rand reg_mem regs[128];
uvm_reg_map mem_map;

  function new(string name = "mem_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build();
    mem_map = create_map("mem_map", 0, 1, UVM_LITTLE_ENDIAN);
    for (int i = 0; i < 128; i++) begin
      regs[i] = reg_mem::type_id::create($sformatf("regs[%0d]", i));
      regs[i].configure(this);
      regs[i].build();
      mem_map.add_reg(regs[i], i, "RW");
    end
	lock_model();
  endfunction
endclass
