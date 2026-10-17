
interface AHB_intf();
logic HCLK;
logic [31:0]HADDR;
logic [2:0] HBURST;
logic 	    HMASTLOCK;
logic [3:0] HPROT;
logic [2:0] HSIZE;
logic [1:0] HTRANS;
logic [31:0]HWDATA;
logic 	    HWRITE;
logic [31:0]HRDATA;
logic       HREADY;
logic 	    HREADYOUT;
logic       HRESP;
logic       HSEL;

endinterface
