

interface QSPI_intf(input logic sck);

logic CS;
wire [3:0]IO;
logic [3:0] slv_IO_drv;
logic slv_IO_oe;

endinterface
