class Base_test extends uvm_test;

`uvm_component_utils(Base_test)

environment env_h;

env_cfg m_cfg;

AHB_cfg p_cfg;

QSPI_cfg s_cfg;

flash_mem_cfg mem_cfg_h;

AHB_seq1 seq_h;


bit has_master_agent = 1;
bit has_slave_agent  = 1;
bit has_scoreboard   = 1;
int no_of_seq_item   = 2;

function new(string name = "Base_test",uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	env_h = environment::type_id::create("env_h",this);
	m_cfg = env_cfg::type_id::create("m_cfg",this);	
	mem_cfg_h = flash_mem_cfg::type_id::create("mem_cfg_h");

        //MASTER AHB Lite Agent configuration.
	p_cfg = AHB_cfg::type_id::create("p_cfg");
	p_cfg.is_active = UVM_ACTIVE;
	if(!uvm_config_db#(virtual AHB_intf)::get(this,"","AHB_intf",p_cfg.vif))
		`uvm_fatal(get_type_name(),"failed to get AHB Lite interface")
	m_cfg.p_cfg = p_cfg;

	//QSPI slave Agent configuration.
	s_cfg = QSPI_cfg::type_id::create("s_cfg");
	s_cfg.is_active = UVM_ACTIVE;	
	if(!uvm_config_db#(virtual QSPI_intf)::get(this,"","QSPI_intf",s_cfg.qspi_if))
		`uvm_fatal(get_type_name(),"failed to get QSPI Lite interface")

	m_cfg.s_cfg = s_cfg;
	m_cfg.mem_cfg_h = mem_cfg_h;//setting mem_cfg_h in QSPI_cfg.
	m_cfg.has_scoreboard  = has_scoreboard;
	m_cfg.has_master_agent= has_master_agent;
	m_cfg.has_slave_agent = has_slave_agent;
	m_cfg.no_of_seq_item  = no_of_seq_item;

	uvm_config_db#(env_cfg)::set(this,"*","env_cfg",m_cfg);

endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction:end_of_elaboration_phase
endclass

class cache_miss_test extends Base_test;

`uvm_component_utils(cache_miss_test)

AHB_seq1 seq1_h;

function new(string name = "cache_miss_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		no_of_seq_item = 2;

		super.build_phase(phase);
		

endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction:end_of_elaboration_phase


task run_phase(uvm_phase phase);
	seq1_h = AHB_seq1::type_id::create("seq1_h");
	phase.raise_objection(this);
	seq1_h.start(env_h.m_agt_h.seqr_h);
	#100;
	phase.drop_objection(this);
endtask
endclass



class multiple_addr extends Base_test;

`uvm_component_utils(multiple_addr)

AHB_seq2 seq2_h;

function new(string name = "multiple_addr",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		no_of_seq_item = 10;

		super.build_phase(phase);
		

endfunction
function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction:end_of_elaboration_phase


task run_phase(uvm_phase phase);
	seq2_h = AHB_seq2::type_id::create("seq2_h");
	phase.raise_objection(this);
	seq2_h.start(env_h.m_agt_h.seqr_h);
	#15;
	phase.drop_objection(this);
endtask
endclass

class cache_line_test extends Base_test;
	`uvm_component_utils(cache_line_test)
	AHB_seq3 seq3_h;
	function new(string name = "cache_line_test",uvm_component parent);
			super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		no_of_seq_item = 8;
		super.build_phase(phase);
		
	endfunction
	task run_phase(uvm_phase phase);
		seq3_h = AHB_seq3::type_id::create("seq2_h");
		phase.raise_objection(this);
		seq3_h.start(env_h.m_agt_h.seqr_h);
		phase.drop_objection(this);
	endtask
endclass

class AHB_INCR4_test extends Base_test;
`uvm_component_utils(AHB_INCR4_test)
AHB_seq4 seq4_h;
function new(string name = "AHB_INCR4_test",uvm_component parent);
			super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	no_of_seq_item = 4;
	super.build_phase(phase);
		
endfunction
task run_phase(uvm_phase phase);
	seq4_h = AHB_seq4::type_id::create("seq4_h");
	phase.raise_objection(this);
	seq4_h.start(env_h.m_agt_h.seqr_h);
	#15;
	phase.drop_objection(this);
endtask
endclass

class AHB_INCR8_test extends Base_test;
`uvm_component_utils(AHB_INCR8_test)
AHB_seq5 seq5_h;
function new(string name = "AHB_INCR8_test",uvm_component parent);
			super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	no_of_seq_item = 8;
	super.build_phase(phase);
		
endfunction
task run_phase(uvm_phase phase);
	seq5_h = AHB_seq5::type_id::create("seq5_h");
	phase.raise_objection(this);
	seq5_h.start(env_h.m_agt_h.seqr_h);
	#20;
	phase.drop_objection(this);
endtask
endclass



class AHB_WRAP4_test extends Base_test;
`uvm_component_utils(AHB_WRAP4_test)
AHB_seq7 seq7_h;
function new(string name = "AHB_WRAP4_test",uvm_component parent);
			super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	no_of_seq_item = 4;
	super.build_phase(phase);
		
endfunction
task run_phase(uvm_phase phase);
	seq7_h = AHB_seq7::type_id::create("seq7_h");
	phase.raise_objection(this);
	seq7_h.start(env_h.m_agt_h.seqr_h);
	#15;
	phase.drop_objection(this);
endtask
endclass

class AHB_WRAP8_test extends Base_test;
`uvm_component_utils(AHB_WRAP8_test)
AHB_seq7 seq7_h;
function new(string name = "AHB_WRAP8_test",uvm_component parent);
			super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	no_of_seq_item = 8;
	super.build_phase(phase);
		
endfunction
task run_phase(uvm_phase phase);
	seq7_h = AHB_seq7::type_id::create("seq8_h");
	phase.raise_objection(this);
	seq7_h.start(env_h.m_agt_h.seqr_h);
	#20;
	phase.drop_objection(this);
endtask
endclass





