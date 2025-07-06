
class apb_monitor extends uvm_monitor;

        //Factory registration
        `uvm_component_utils (apb_monitor)

        virtual intf.APB_MON_MP vif;

        apb_agent_config apb_cfg;

        //Analysis port to send the data to SB
        uvm_analysis_port #(apb_xtn) monitor_port;

        apb_xtn xtn;

        extern function new(string name="apb_monitor",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

//---------Constructor----------//
function apb_monitor::new(string name="apb_monitor",uvm_component parent);
        super.new(name,parent);
        monitor_port=new("monitor_port",this);
endfunction

//-------Build Phase----------//
function void apb_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_agent_config",apb_cfg))
                `uvm_fatal("MONITOR","cannot get config data");
        super.build_phase(phase);
endfunction

function void apb_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
	vif=apb_cfg.vif;
endfunction

//////---Run Phase-----/////
task apb_monitor::run_phase(uvm_phase phase);
       forever
                begin
                        collect_data();
                end
endtask

///----collect data------/////
task apb_monitor::collect_data();
       
        xtn = apb_xtn::type_id::create("xtn");

     //   while(vif.apb_mon_cb.Penable!==0)
       //    @(vif.apb_mon_cb);
 wait(vif.apb_mon_cb.Penable)
 
                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite; //An automatic var. or elem. of a dynamic var. (xtn) may not be the LHS of a non-blocking assignment.

                xtn.Pselx = vif.apb_mon_cb.Pselx;//collect control info

        if(xtn.Pwrite == 1)
		xtn.Pwdata = vif.apb_mon_cb.Pwdata; //collect data
        else
                xtn.Prdata = vif.apb_mon_cb.Prdata;

        $display("paddr=%b",vif.apb_mon_cb.Paddr);
	`uvm_info("APB MON","PRINITING FROM APB MONITOR",UVM_LOW)
      xtn.print();
        repeat(2)       
        @(vif.apb_mon_cb); //give 1 cycle delay - Setup + enable
	
	//

        monitor_port.write(xtn);

        
endtask
