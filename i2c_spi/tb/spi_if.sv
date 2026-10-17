interface spi_if(input logic sclk);

 logic [11:0] din;
 logic newd;
 logic [11:0] dout;
 logic done;
 

clocking ms_drv_cb@(posedge sclk);
	default input #1 output #0;
	output din;
	output newd;
	
	input done;
endclocking:ms_drv_cb

clocking ms_mon_cb@(posedge sclk);
	default input#1 output #0;
	input din;
	input newd;
	input dout;
	input done;
endclocking:ms_mon_cb 

modport MS_DRV(clocking ms_drv_cb,input sclk);
modport MS_MON(clocking ms_mon_cb,input sclk);

endinterface:spi_if
