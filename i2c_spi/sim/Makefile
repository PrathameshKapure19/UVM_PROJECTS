#--------------------------------------------------
# Library
#--------------------------------------------------
WORK = work

#--------------------------------------------------
# Include Directories
#--------------------------------------------------
INC = +incdir+../tb \
      +incdir+../master_i2c_agent \
      +incdir+../master_spi_agent \
      +incdir+../test \
      +incdir+../spi_testcases \
      +incdir+../i2c_testcases

#--------------------------------------------------
# RTL / TB Files
#--------------------------------------------------
RTL = ../rtl/i2c_rtl.sv \
      ../rtl/SPI.sv

TB = ../test/tb_pkg.sv \
     ../test/i2c_test_pkg.sv \
     ../test/spi_test_pkg.sv \
     ../tb/i2c_if.sv \
     ../tb/spi_if.sv \
     ../tb/spi_assertion.sv \
     ../tb/i2c_assertions.sv \
     ../tb/top.sv

#--------------------------------------------------
# Compile
#--------------------------------------------------
VLOG = vlog -cover bcesft -work $(WORK) $(INC)


#--------------------------------------------------
# GUI Simulation
#--------------------------------------------------
VSIM = vsim \
       -coverage \
       -voptargs=+acc \
       -sva \
       -assertdebug \
       -assertcounts \
       -assertfile assert_file.log \
       -wlf wave_file.wlf \
       -l test.log \
       -sv_seed random \
       -do "log -r /*"

#--------------------------------------------------
# Batch Simulation
#--------------------------------------------------
VBATCH = vsim \
         -c \
	 -coverage \
         -voptargs=+acc=rn \
         -sva \
         -assertdebug \
         -assertcounts \
	 -assertfile assert_file.log \
         -wlf wave_file.wlf \
         -l test.log \
         -sv_seed random -onfinish stop \
         -do "log -r /*; run -all;coverage save $@.ucdb;quit -f"
#-------------------------------------------------
#
#------------------------------------------------

coverage_report:
		vcover report \
		-details \
                -all    \
                -cvg \
                -output cover.txt  \
                cov.ucdb 

#--------------------------------------------------
# Library
#--------------------------------------------------
lib:
	vlib $(WORK)
	vmap $(WORK) $(WORK)

#--------------------------------------------------
# Compile
#--------------------------------------------------
compile: lib
	$(VLOG) $(RTL) $(TB)

#--------------------------------------------------
# Batch Tests For I2C
#--------------------------------------------------
run_reset:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=reset_test

run_ral_single_write:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=ral_single_write_test

run_ral_single_read:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=ral_single_read_test

run_ral_write:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=ral_write_test

run_ral_read:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=ral_read_test

run_ral_extreme_addr1:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=acc_extreme_addr1_test

run_ral_extreme_addr2:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=acc_extreme_addr2_test

run_all_ones_i2c:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_ones_i2c_test

run_all_zero_i2c: 
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_zero_i2c_test

run_rst_btw: 
	$(VBATCH) $(WORK).top +UVM_TESTNAME=rst_btw_test

run_default_value_read:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=default_value_test

run_full_mem_acc:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=full_mem_acc_test

run_rst_after_ack1: 
	$(VBATCH) $(WORK).top +UVM_TESTNAME=rst_after_ack1_test

run_rst_after_ack2:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=rst_after_ack2_test

run_all_ones_stress:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_ones_stress_test

run_all_zero_stress:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_zero_stress_test

run_stress_rd:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=stress_rd_test

run_direct_test:
	$(VBATCH) $(WORK).top +UVM_TESTNAME=direct_test







#---------------------------------------------------------------
# GUI Test for I2C
#---------------------------------------------------------------

TEST_1: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=reset_test

TEST_2:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=ral_single_write_test

TEST_3:clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=ral_single_read_test

TEST_4: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=ral_write_test

TEST_5: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=ral_read_test

TEST_6: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=all_ones_write_test

TEST_7: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=all_ones_read_test

TEST_8: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=acc_extreme_addr1_test

TEST_9: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=acc_extreme_addr2_test

TEST_10: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=rst_btw_test

TEST_11: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=default_value_test

TEST_12: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=full_mem_acc_test

TEST_13: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=rst_after_ack1_test

TEST_14: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=rst_after_ack2_test



#---------------------------------------------------------------
# Batch Test for SPI
#----------------------------------------------------------------
run_test_1: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=write_spi_test

run_test_2: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=single_write_spi_test

run_test_3: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_ones_test

run_test_4: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=all_zeros_test

run_test_5: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=newd_test

run_test_6: clean compile
	$(VBATCH) $(WORK).top +UVM_TESTNAME=alter_value_test



#---------------------------------------------------------------
# GUI Test for SPI
#---------------------------------------------------------------
TEST1: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=write_spi_test

TEST2: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=single_write_spi_test

TEST3: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=all_ones_test

TEST4: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=all_zeros_test


TEST5: clean compile
	$(VSIM) $(WORK).top +UVM_TESTNAME=newd_test


#--------------------------------------------------
# Clean
#--------------------------------------------------
clean:
	
	rm -rf work
	rm -rf transcript
	rm -rf *.log
	rm -rf *.wlf
	rm -rf *.ucdb
	rm -rf *.vstf
	rm -rf *.ini
	reset

TEST_FILE = run_reset \
	run_ral_single_write \
	run_ral_single_read \
	run_ral_write \
	run_ral_read \
	run_ral_extreme_addr1 \
	run_ral_extreme_addr2 \
	run_all_ones_i2c \
	run_all_zero_i2c \
	run_rst_btw \
	run_default_value_read \
	run_full_mem_acc \
	run_rst_after_ack1 \
	run_rst_after_ack2 \
	run_all_ones_stress \
	run_all_zero_stress \
	run_stress_rd \
	run_direct_test

regress:  clean compile \
	run_reset \
	run_ral_single_write \
	run_ral_single_read \
	run_ral_write \
	run_ral_read \
	run_ral_extreme_addr1 \
	run_ral_extreme_addr2 \
	run_all_ones_i2c \
	run_all_zero_i2c \
	run_rst_btw \
	run_default_value_read \
	run_full_mem_acc \
	run_rst_after_ack1 \
	run_rst_after_ack2 \
	run_all_ones_stress \
	run_all_zero_stress \
	run_stress_rd \
	run_direct_test

merge_coverage:
	vcover merge merge_coverage.ucdb $(addsuffix .ucdb,$(TEST_FILE))	
	vcover report -detail -all -cvg -output merge_coverage.txt merge_coverage.ucdb

