//AHB_Monitor

class ahb_monitor extends uvm_monitor;
	
	//factory registration
	`uvm_component_utils (ahb_monitor)
	
	//interface
	virtual intf.AHB_MON_MP vif;
	
//	ahb_xtn xtn;

	ahb_agent_config ahb_cfg;
	
	//Analysis port to send the data to SB
	uvm_analysis_port #(ahb_xtn) monitor_port;
	
	extern function new (string name = "ahb_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
        extern task collect_data();
endclass: ahb_monitor

//-----------Constructor----------//
function ahb_monitor::new (string name = "ahb_monitor", uvm_component parent);
	super.new (name, parent);
	monitor_port = new("monitor_port", this);
endfunction: new

//-----------Build Phase---------//
function void ahb_monitor::build_phase (uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
		`uvm_fatal("CONFIG","Cannot get() m_cfg from uvm_config_db. Have you set it?")
endfunction: build_phase

//----------Connect Phase---------//
function void ahb_monitor::connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	
	//interface connection
	vif=ahb_cfg.vif;
	
endfunction: connect_phase

//////---Run Phase-----/////
task ahb_monitor::run_phase(uvm_phase phase);
super.run_phase(phase);
        forever
                begin

                        collect_data();
                end
endtask

//----collect data------/////
task ahb_monitor::collect_data();

        ahb_xtn xtn;
        xtn = ahb_xtn::type_id::create("xtn");
        //@(vif.ahb_mon_cb);
        wait(vif.ahb_mon_cb.Hreadyout === 1'b1);
    wait(vif.ahb_mon_cb.Htrans === 2'b10 | vif.ahb_mon_cb.Htrans === 2'b11)
	//while(!(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11)))
          //  @(vif.ahb_mon_cb);
			//$display("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

        //while(vif.ahb_mon_cb.Htrans !== 2'b10 || vif.ahb_mon_cb.Htrans !== 2'b11)    ///changessssssssssssssssssssssssss
          //  @(vif.ahb_mon_cb);

       
			//$display("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");

         xtn.Htrans = vif.ahb_mon_cb.Htrans;
         xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
         xtn.Hsize  = vif.ahb_mon_cb.Hsize;
         xtn.Haddr  = vif.ahb_mon_cb.Haddr;
         xtn.Hburst = vif.ahb_mon_cb.Hburst;

         //the xtn will be either NS or S, first cycle - collect addr and control info
        @(vif.ahb_mon_cb);

         //while (vif.ahb_mon_cb.Hreadyout!==1)
           // @(vif.ahb_mon_cb);
         wait(vif.ahb_mon_cb.Hreadyout === 1'b1)
        if (vif.ahb_mon_cb.Hwrite == 1'b1)        
        xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
        else
        xtn.Hrdata = vif.ahb_mon_cb.Hrdata;


       `uvm_info("AHB_MONITOR", "Displaying ahb_monitor data", UVM_LOW)
        xtn.print();//no delay, in the same cycle control and addr shud be collected
        
        monitor_port.write(xtn); //Send to SB
       


endtask
