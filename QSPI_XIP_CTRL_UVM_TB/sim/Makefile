WORK = work

INC = +incdir+../tb \
	+incdir+../Master_Agent \
	+incdir+../Slave_Agent \
	+incdir+../test 
 
RTL = ../rtl/EF_QSPI_XIP_CTRL_AHBL.v \
      ../rtl/EF_QSPI_XIP_CTRL.v \
      ../rtl/DMC.v

TB  = ../test/tb_pkg.sv \
      ../tb/AHB_intf.sv \
      ../tb/QSPI_intf.sv \
      ../tb/tb_top.sv 

VLOG = vlog $(work) $(INC)

VSIM = vsim \
	-voptargs=+acc \
        -wlf wave_file.wlf \
	-l test.log \
	-do "log -r /*"

VBATCH = vsim \
	-c \
	-voptargs=+acc \
	-wlf wave_file.wlf \
        -l test.log \
   	-do "log -r /*;run -all"
lib:
	vlib $(WORK)
	vmap $(WORK) $(WORK)

compile:lib
	$(VLOG) $(RTL) $(TB)
#Batch mode TEST
Test1:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=cache_miss_test

Test2:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=multiple_addr

Test3:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=cache_line_test

Test4:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=AHB_INCR4_test

Test5:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=AHB_INCR8_test

Test6:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=AHB_WRAP4_test

Test7:clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=AHB_WRAP8_test	
#GUI MODE test
test1:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=cache_miss_test

test2:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=multiple_addr

test3:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=cache_line_test

test4:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=AHB_INCR4_test

test5:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=AHB_INCR8_test

test6:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=AHB_WRAP4_test

test7:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=AHB_WRAP8_test


clean:
	rm -rf work
	rm -rf transcript
	rm -rf *.log
	rm -rf *.ini
	rm -rf *.wlf
	reset 
