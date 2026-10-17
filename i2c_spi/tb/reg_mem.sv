/*class reg_mem extends uvm_mem;
	`uvm_object_utils(reg_mem)
	
	function new(string name="reg_mem");	
		super.new(name,128,8,"RW","UVM_NO_COVERAGE");
	endfunction
endclass*/


class reg_mem extends uvm_reg;
  `uvm_object_utils(reg_mem)
  rand uvm_reg_field data;

  function new(string name = "reg_mem");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 8, 0, "RW", 0, 8'h0, 1, 1, 0);
  endfunction
endclass
