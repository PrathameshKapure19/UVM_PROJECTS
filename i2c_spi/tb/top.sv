module top;

  import uvm_pkg::*;
  import tb_pkg::*;
  import i2c_test_pkg::*;
  import spi_test_pkg::*;

  bit clk = 0;
  bit rst;
  always #5 clk = ~clk;


  i2c_mem DUT (
    .clk    (clk),
    .rst    (in0.rst),
    .wr     (in0.wr),
    .addr   (in0.addr),
    .din    (in0.din),
    .datard (in0.datard),
    .done   (in0.done)
  );

  
  spi_top DUT1 (
    .clk  (clk),
    .rst  (rst),
    .newd (vif.newd),
    .din  (vif.din),
    .dout (vif.dout),
    .done (vif.done)
  );

 bind spi_top spi_assertion assertion_h (
    .sclk(sclk),
    .rst(rst),
    .newd(newd),
    .done(s1.done),
    .mosi(m1.mosi),
    .ms_cs(m1.cs),
    .sl_cs(s1.cs),
    .ms_state(m1.state),
    .sl_state(s1.state)
);

bind i2c_mem i2c_assertion assertion_h1(
	.clk(clk),
	.rst(rst),
	.wr(DUT.wr),
	.sdat(DUT.sdat),
	.ms_state(DUT.state),
	.sl_state(DUT.nstate),
	.ms_count(DUT.count),
	.sl_count(DUT.countn),
	.en(DUT.en),
	.sda(DUT.sda),
	.update(DUT.update),
	.scl(DUT.scl),
	.addrn(DUT.addrn)
);

  
  spi_if vif(DUT1.sclk);
  i2c_if in0(clk);

  
  initial begin
  	

  	uvm_config_db#(virtual i2c_if)::set(null, "*", "i2c_if", in0);
  	uvm_config_db#(virtual spi_if)::set(null, "*", "spi_if", vif);

  	

  	run_test();

  	
  end

 
  initial begin
    rst = 1'b1;
    in0.rst = 1'b0;
    @(posedge clk);

    rst = 1'b0;
    
  end
	assign in0.state = DUT.state;

endmodule
