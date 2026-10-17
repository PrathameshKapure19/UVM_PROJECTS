
module top;
import uvm_pkg::*;
import tb_pkg::*;

bit HCLK = 0;

bit HRESETn;

logic [3:0] din,dout,douten;

wire sck;

always #5 HCLK = ~HCLK;


QSPI_intf inf1(sck);
EF_QSPI_XIP_CTRL_AHBL DUT
(
//AHB lite interface
.HSEL(inf0.HSEL),
.HCLK(HCLK),
.HRESETn(HRESETn),
.HADDR(inf0.HADDR),
.HTRANS(inf0.HTRANS),
.HWRITE(inf0.HWRITE),
.HREADY(inf0.HREADY),
.HREADYOUT(inf0.HREADYOUT),
.HRDATA(inf0.HRDATA),

//QSPI interface
.ce_n(inf1.CS),
.din(din),
.dout(dout),
.douten(douten),
.sck(sck)
);

AHB_intf inf0();

assign inf0.HCLK = HCLK;

assign inf1.IO = (douten == 4'b1111)      ? dout:
		 (inf1.slv_IO_oe == 1'b1) ? inf1.slv_IO_drv:
  		 4'bzzzz;

assign din = inf1.IO;

initial begin
 HRESETn = 1'b0;
 @(posedge HCLK);
 HRESETn = 1'b1;
end

assign inf0.HREADY = inf0.HREADYOUT;

initial begin
    uvm_config_db#(virtual AHB_intf)::set(null,"*","AHB_intf",inf0);

    uvm_config_db#(virtual QSPI_intf)::set(null,"*","QSPI_intf",inf1);

    run_test();
end


endmodule
