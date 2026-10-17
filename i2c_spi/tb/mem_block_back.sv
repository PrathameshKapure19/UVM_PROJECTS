class mem_block_back extends uvm_reg_block;
  `uvm_object_utils(mem_block_back)

  rand reg_mem regs[128];
  uvm_reg_map mem_map;

  function new(string name = "mem_block_back");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build();

    mem_map = create_map("mem_map", 0, 1, UVM_LITTLE_ENDIAN);

    // Root HDL path of the DUT
    add_hdl_path("top.DUT");

    for (int i = 0; i < 128; i++) begin
      regs[i] = reg_mem::type_id::create($sformatf("regs[%0d]", i));

      regs[i].configure(this,null,"");
      regs[i].build();

      mem_map.add_reg(regs[i], i, "RW");

      // Map each RAL register to the RTL memory location
      regs[i].add_hdl_path_slice($sformatf("mem[%0d]", i), 0, 8);
    end

    lock_model();

  endfunction

endclass
