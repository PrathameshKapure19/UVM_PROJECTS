module i2c_assertion(
input clk,
input rst,
input wr,
input sdat,
input [3:0] ms_state,
input [3:0] sl_state,
input integer ms_count,
input integer sl_count,
input en,
input sda,
input update,
input scl,
input [7:0] addrn
);

parameter idle = 0, start = 1, send_addr = 2, get_ack1 = 3, send_data = 4, get_ack2= 5, read_data = 6, complete = 7, get_addr = 8, send_ack1 = 9, get_data = 10, send_ack2 = 11 ;

//-------------------------------------------------------------------
//Master FSM  Assertion for fsm state transition from idle to start
//-------------------------------------------------------------------
property master_state_transition_1;
	@(posedge clk)
	disable iff(rst)
	(ms_state == idle) |=> (ms_state == start);
endproperty

a_state_start: assert property(master_state_transition_1)
	$display("[%0t] Master FSM State transtion from idle to start successfull",$time);
else
	$error("[%0t] Master FSM failed in state transition",$time);
//----------------------------------------------------------------------------------------------------------
//Assertion for Master FSM when count reaches to its max value then FSM transition to get_ack1 from send_Addr
//----------------------------------------------------------------------------------------------------------

property master_state_transition_2;
	@(posedge clk)
	disable iff(rst)
        (ms_state == send_addr && ms_count ==7 ) |=> ##1 (ms_state == get_ack1);
endproperty

a_state_get_ack1: assert property(master_state_transition_2)
	$display("[%0t] After address FSM transition to get ack on address sent",$time);
else
	$error("[%0t] Fsm Transtion to get_ack1 was failed.",$time);
//-----------------------------------------------------------------------------------------
//Assertion For checking whether Master Fsm state changes to send_data in a write test case
//-----------------------------------------------------------------------------------------

property master_enter_send_data;
	@(posedge clk)
	disable iff(rst)

	(sda == 1'b0 && wr == 1'b1 && ms_state == get_ack1) |=> (ms_state == send_data)
endproperty

a_state_transition_to_send_data: assert property (master_enter_send_data)
	$display("[%0t] For write Transaction FSM transitions to send_data state",$time);
else
	$error("[%0t] FSM Transition in case of writing data is not successful",$time);
//----------------------------------------------------------------------------------------
//Assertion For Checking After getting second acknowledgement Master FSM transitions to
//complete state
//----------------------------------------------------------------------------------------

property master_fsm_enter_complete;
	@(posedge clk)
	disable iff(rst)
	(ms_state == get_ack2 && sda == 1'b0)|=> (ms_state == complete);
endproperty

master_fsm_in_complete:assert property(master_fsm_enter_complete)
	$display("[%0t] Data Transmission to slave is successful and After getting Ack2 Fsm Enters to Complete state",$time);
else
	$error("[%0t] Fsm failed in transitioning to complete state",$time);
//------------------------------------------------------------------------------------------------------
//Assertion For Transition back to idle state from complete state After successful Transaction execution
//------------------------------------------------------------------------------------------------------
property master_fsm_to_idle;
	@(posedge clk)
	disable iff(rst)
	(ms_state == complete && update == 1'b1) |=> (ms_state == idle);
endproperty

master_fsm_transition_to_idle:assert property(master_fsm_to_idle)
	$display("[%0t] Transaction is Executed successfully and FSM transition to idle state.",$time);
else
	$error("[%0t] Fsm Transitioning to idle state from complete Was not successful",$time);

//-----------------------------------------------------------------------------------------------------
//Assertion For Checking whether from read_data state Master FSM Transistions to complete state
//-----------------------------------------------------------------------------------------------------

property master_fsm_to_complete_after_read_data;
	@(posedge clk)
	disable iff(rst)
	(ms_state == read_data && ms_count == 9) |=> ##1 (ms_state == complete);
	
endproperty

master_fsm_transition_to_complete_state : assert property(master_fsm_to_complete_after_read_data)
	$display("[%0t] Fsm transitions from read_data state to complete state",$time);
else
	$error("[%0t] FSM transitioning failed to complete state",$time);

//---------------------------------------------------------------------
// Slave FSM : IDLE -> START
//---------------------------------------------------------------------
property slave_idle_to_start;
    @(posedge clk)
    disable iff(rst)
    (sl_state == idle && scl == 1'b1 && sdat == 1'b1) |=> (sl_state == start);
endproperty

a_slave_idle_to_start: assert property(slave_idle_to_start)
    $display("[%0t] Slave FSM transitioned from IDLE to START.", $time);
else
    $error("[%0t] Slave FSM failed to transition from IDLE to START.", $time);


//---------------------------------------------------------------------
// Slave FSM : START -> GET_ADDR
//---------------------------------------------------------------------
property slave_start_to_get_addr;
    @(posedge clk)
    disable iff(rst)
    (sl_state == start && scl && !sdat) |=> (sl_state == get_addr);
endproperty

a_slave_start_to_get_addr: assert property(slave_start_to_get_addr)
    $display("[%0t] Slave FSM transitioned from START to GET_ADDR.", $time);
else
    $error("[%0t] Slave FSM failed to transition to GET_ADDR.", $time);


//---------------------------------------------------------------------
// Slave FSM : GET_ADDR -> SEND_ACK1
//---------------------------------------------------------------------
property slave_get_addr_to_ack1;
    @(posedge clk)
    disable iff(rst)
    (sl_state == get_addr && sl_count == 7) |=> ##1 (sl_state == send_ack1);
endproperty

a_slave_get_addr_to_ack1: assert property(slave_get_addr_to_ack1)
    $display("[%0t] Slave FSM transitioned to SEND_ACK1.", $time);
else
    $error("[%0t] Slave FSM failed to enter SEND_ACK1.", $time);


//---------------------------------------------------------------------
// Slave FSM : SEND_ACK1 -> GET_DATA (Write)
//---------------------------------------------------------------------
property slave_ack1_to_get_data;
    @(posedge clk)
    disable iff(rst)
    (sl_state == send_ack1 && addrn[0] && ms_state == send_data) |=> (sl_state == get_data);
endproperty

a_slave_ack1_to_get_data: assert property(slave_ack1_to_get_data)
    $display("[%0t] Slave entered GET_DATA state.", $time);
else
    $error("[%0t] Slave failed to enter GET_DATA state.", $time);


//---------------------------------------------------------------------
// Slave FSM : SEND_ACK1 -> SEND_DATA (Read)
//---------------------------------------------------------------------
property slave_ack1_to_send_data;
    @(posedge clk)
    disable iff(rst)
    (sl_state == send_ack1 && !addrn[0] && ms_state == read_data) |=> (sl_state == send_data);
endproperty

a_slave_ack1_to_send_data: assert property(slave_ack1_to_send_data)
    $display("[%0t] Slave entered SEND_DATA state.", $time);
else
    $error("[%0t] Slave failed to enter SEND_DATA state.", $time);


//---------------------------------------------------------------------
// Slave FSM : GET_DATA -> SEND_ACK2
//---------------------------------------------------------------------
property slave_get_data_to_ack2;
    @(posedge clk)
    disable iff(rst)
    (sl_state == get_data && sl_count == 7) |=> ##1 (sl_state == send_ack2);
endproperty

a_slave_get_data_to_ack2: assert property(slave_get_data_to_ack2)
    $display("[%0t] Slave entered SEND_ACK2.", $time);
else
    $error("[%0t] Slave failed to enter SEND_ACK2.", $time);


//---------------------------------------------------------------------
// Slave FSM : SEND_DATA -> COMPLETE
//---------------------------------------------------------------------
property slave_send_data_to_complete;
    @(posedge clk)
    disable iff(rst)
    (sl_state == send_data && sl_count == 7) |=> ##1 (sl_state == complete);
endproperty

a_slave_send_data_to_complete: assert property(slave_send_data_to_complete)
    $display("[%0t] Slave entered COMPLETE after SEND_DATA.", $time);
else
    $error("[%0t] Slave failed to enter COMPLETE.", $time);


//---------------------------------------------------------------------
// Slave FSM : SEND_ACK2 -> COMPLETE
//---------------------------------------------------------------------
property slave_ack2_to_complete;
    @(posedge clk)
    disable iff(rst)
    (sl_state == send_ack2) |=> (sl_state == complete);
endproperty

a_slave_ack2_to_complete: assert property(slave_ack2_to_complete)
    $display("[%0t] Slave transitioned to COMPLETE.", $time);
else
    $error("[%0t] Slave failed to enter COMPLETE.", $time);


//---------------------------------------------------------------------
// Slave FSM : COMPLETE -> IDLE
//---------------------------------------------------------------------
property slave_complete_to_idle;
    @(posedge clk)
    disable iff(rst)
    (sl_state == complete && update) |=> (sl_state == idle);
endproperty

a_slave_complete_to_idle: assert property(slave_complete_to_idle)
    $display("[%0t] Slave returned to IDLE.", $time);
else
    $error("[%0t] Slave failed to return to IDLE.", $time);

endmodule:i2c_assertion
