package i2c_test_pkg;

 import uvm_pkg::*;
 `include "uvm_macros.svh"
 import tb_pkg::*;

`include "ral_single_write_test.sv"
`include "ral_single_read_test.sv"
`include "ral_write_test.sv"
`include "ral_read_test.sv"
`include "reset_test.sv"
`include "rst_btw_test.sv"
`include "acc_extreme_addr1_test.sv"
`include "acc_extreme_addr2_test.sv"
`include "all_ones_i2c_test.sv"
`include "all_zero_i2c_test.sv"
`include "default_value_test.sv"
`include "full_mem_acc_test.sv"
`include "rst_after_ack1_test.sv"
`include "rst_after_ack2_test.sv"
`include "bit_bash_test.sv"

`include "all_ones_stress_test.sv"
`include "all_zero_stress_test.sv"
`include "stress_rd_test.sv"
`include "direct_test.sv"
endpackage
