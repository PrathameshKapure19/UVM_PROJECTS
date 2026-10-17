module spi_assertion(
input logic sclk,
input rst,
input logic newd,
input done,
input mosi,
input ms_cs,
input sl_cs,
input [1:0] ms_state,
input logic sl_state
);

parameter IDLE = 2'b00;

parameter SEND = 2'b10;


//-----------------------------------------------------------
// After detecting newd with valid data CS
// in master become low.
//-----------------------------------------------------------

property Master_cs_low_on_newd;
	@(posedge sclk)
	(newd == 1'b1) |=>  !ms_cs;
endproperty

a_cs_low_on_newd: assert property(Master_cs_low_on_newd)
	$display("[%0t] Master CS got low after newd getting high",$time);
       
else 
      $error("[%0t] Master CS did not go low after newd getting  high",$time);

//--------------------------------------------------------------
// After newd is asserted and SPI transmission
// is completed then done should be high in slave.
//--------------------------------------------------------------

property p_spi_transfer_complete;

        @(posedge sclk)
	(sl_cs == 1'b0 && sl_state == 1'b0) |=> ##13( done == 1'b1);

endproperty

a_spi_transfer_complete: assert property(p_spi_transfer_complete)
	$display("[%0t] SPI Done Signal Asserted Successfully",$time);
else 
        $error("[%0t] SPI Done signal did not asserted successfully",$time);

//--------------------------------------------------------------
// After SPI transmission is completed
// CS goes high in slave.
//--------------------------------------------------------------

property master_cs_high_transfer_complete;

	@(posedge sclk)
	(newd && ms_state == IDLE) |=> ##13 (ms_cs == 1'b1);
endproperty

master_condition: assert property(master_cs_high_transfer_complete)
	$display("[%0t] Master CS became High After transfer got complete.",$time);
else
	$error("[%0t]Master CS did not became high after transfer completion failed",$time);
//---------------------------------------------------------------
// After newd is detected the FSM state should change to
// send state in spi master.
//---------------------------------------------------------------

property master_state_change;
	@(posedge sclk)
	(ms_state == IDLE && newd) |=> (ms_state == SEND);
endproperty

master_p_state_change_ms: assert property(master_state_change)
	$display("[%0t] Master State change assertion successful for master",$time);
else
	$error("[%0t] Master state change assertion failed for master",$time);

//-----------------------------------------------------------------
// Slave CS becomse High After Transfer is completed in master
//-----------------------------------------------------------------
property slave_cs_high_transfer_complete;

	@(posedge sclk)
	(sl_cs == 1'b0 && sl_state == 1'b0) |=> ##13 (sl_cs == 1'b1);
endproperty

slave_conditon: assert property(slave_cs_high_transfer_complete)
	$display("[%0t] Slave CS became High After transfer got complete.",$time);
else
	$error("[%0t] Slave CS did not became high After transfer got complete.",$time);

//-------------------------------------------------------------------
// Slave changes to detect_state When cs signal is detected low
//------------------------------------------------------------------

property sl_state_transition;
	@(posedge sclk)
	 (sl_cs == 1'b0 && sl_state == 1'b0) |=> (sl_state == 1'b1);

endproperty

a_sl_state_transition: assert property(sl_state_transition)
	$display("[%0t] Slave state transition is successfull.",$time);
else
	$error("[%0t] Slave state transistion is not successful",$time);



endmodule:spi_assertion
