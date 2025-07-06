class ahb_apb_bridge_test extends uvm_test;

	`uvm_component_utils(ahb_apb_bridge_test)

	ahb_apb_env_config m_cfg;
	ahb_apb_env e_cfg;

	ahb_agent_config ahb_cfg[];
	apb_agent_config apb_cfg[];

	int no_of_ahb_agents=1;
	int no_of_apb_agents=1;
	
 //virtual_sequencer seqrh;
	extern function new(string name="ahb_apb_bridge_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
       extern function void start_of_simulation_phase(uvm_phase phase);

	//extern task run_phase(uvm_phase);

endclass

//----------Constructor-----------//
function ahb_apb_bridge_test:: new(string name="ahb_apb_bridge_test",uvm_component parent);
	super.new(name,parent);
endfunction

//-----------Build Phase----------//
function void ahb_apb_bridge_test:: build_phase(uvm_phase phase);
	super.build_phase(phase);	

	m_cfg = ahb_apb_env_config::type_id::create("ahb_apb_env_config", this);

       m_cfg.ahb_cfg=new[no_of_ahb_agents];
       m_cfg.apb_cfg=new[no_of_apb_agents];

	//these sh0uld be written before declaring dynamic array	
	
	ahb_cfg=new[no_of_ahb_agents];
	apb_cfg=new[no_of_apb_agents];
	
	foreach(apb_cfg[i])
	begin
		apb_cfg[i]=apb_agent_config::type_id::create($sformatf("apb_cfg[%0d]",i));
		
              if(!uvm_config_db #(virtual intf)::get(this,"",$sformatf("svif%0d",i),apb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");

		apb_cfg[i].is_active=UVM_ACTIVE;
		m_cfg.apb_cfg[i]=apb_cfg[i];
	 
	end

	

       foreach(ahb_cfg[i])
	begin
	      ahb_cfg[i]=ahb_agent_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
		
            if(!uvm_config_db #(virtual intf)::get(this,"",$sformatf("mvif%0d",i),ahb_cfg[i].vif))
		`uvm_fatal("TEST","cannot get config data");

		ahb_cfg[i].is_active=UVM_ACTIVE;
		m_cfg.ahb_cfg[i]=ahb_cfg[i];
	end

	
	m_cfg.no_of_ahb_agents=no_of_ahb_agents;
	m_cfg.no_of_apb_agents=no_of_apb_agents;
	e_cfg = ahb_apb_env::type_id::create("e_cfg", this);	
	uvm_config_db#(ahb_apb_env_config) ::set(this,"*","ahb_apb_env_config",m_cfg);

endfunction

function void ahb_apb_bridge_test:: start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology;
endfunction



class test_1 extends ahb_apb_bridge_test;

        `uvm_component_utils(test_1)

       single_transfer_sequence t_seqh;
	
        extern function new(string name = "test_1", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_1::new(string name = "test_1", uvm_component parent);
        super.new(name, parent);
endfunction


////---------build_phase----------///////
function void test_1::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

/////////-------run_phase---------////////
task test_1::run_phase(uvm_phase phase);

        phase.raise_objection(this);
	repeat(3)
		begin
        t_seqh = single_transfer_sequence::type_id::create("t_seqh");

        t_seqh.start(e_cfg.ahb_top.agt[0].ahb_seqr);
	end		
		#100;
        phase.drop_objection(this);
endtask


class test_2 extends ahb_apb_bridge_test;

        `uvm_component_utils(test_2)

       increment_transfer_sequence t_seqh;
	
        extern function new(string name = "test_2", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_2::new(string name = "test_2", uvm_component parent);
        super.new(name, parent);
endfunction


////---------build_phase----------///////
function void test_2::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

/////////-------run_phase---------////////
task test_2::run_phase(uvm_phase phase);

        phase.raise_objection(this);
        repeat(1)
        begin

        t_seqh = increment_transfer_sequence::type_id::create("t_seqh");
        t_seqh.start(e_cfg.ahb_top.agt[0].ahb_seqr);
        
		end 

         #100;
        phase.drop_objection(this);
endtask




class test_3 extends ahb_apb_bridge_test;

        `uvm_component_utils(test_3)

        wrap_transfer_sequence t_seqh;
	
        extern function new(string name = "test_3", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_3::new(string name = "test_3", uvm_component parent);
        super.new(name, parent);
endfunction


////---------build_phase----------///////
function void test_3::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

/////////-------run_phase---------////////
task test_3::run_phase(uvm_phase phase);

        phase.raise_objection(this);
        repeat(1)
        begin

        t_seqh = wrap_transfer_sequence::type_id::create("t_seqh");
        t_seqh.start(e_cfg.ahb_top.agt[0].ahb_seqr);
        
		end 

         #100;
        phase.drop_objection(this);
endtask
