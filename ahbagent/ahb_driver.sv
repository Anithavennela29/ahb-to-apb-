//AHB_Driver

class ahb_driver extends uvm_driver #(ahb_xtn);
	
	//factory registration
	`uvm_component_utils (ahb_driver)
	
	//interface
	virtual intf.AHB_DR_MP vif;
	
	//ahb_xtn xtn;

	ahb_agent_config ahb_cfg;
	
	extern function new (string name = "ahb_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
        extern task send_to_dut();

endclass

//-----------Constructor----------//
function ahb_driver::new (string name = "ahb_driver", uvm_component parent);
	super.new (name, parent);
endfunction: new

//-----------Build Phase---------//
function void ahb_driver::build_phase (uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
		`uvm_fatal("CONFIG","Cannot get() m_cfg from uvm_config_db. Have you set it?")

endfunction: build_phase

//----------Connect Phase---------//
function void ahb_driver::connect_phase (uvm_phase phase);
//	super.connect_phase(phase);
	
	//interface connection
	vif=ahb_cfg.vif;
	
endfunction: connect_phase


task ahb_driver::run_phase(uvm_phase phase);
//super.run_phase(phase);
        //Active low reset
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0;

        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;

        forever
                begin
//	$display("11111111111111111111111111111111122222222222222222222222222");


                        seq_item_port.get_next_item(req); //get the data from sequencer
//	$display("111111111111111111111111111111111");

                       // req.print();
                        send_to_dut();
                        seq_item_port.item_done();
                end
endtask


///----send to dut------/////
task ahb_driver::send_to_dut();
        //req.print();
        //drive addr and control info
        //wait(vif.ahb_drv_cb.Hreadyout)
        while(vif.ahb_drv_cb.Hreadyout !== 1)
                @(vif.ahb_drv_cb);
        
	//$display("111222222222222222222222222222222221111");

        vif.ahb_drv_cb.Hwrite  <= req.Hwrite;
        vif.ahb_drv_cb.Hburst  <= req.Hburst;
        vif.ahb_drv_cb.Htrans  <= req.Htrans;
        vif.ahb_drv_cb.Hsize   <= req.Hsize;
        vif.ahb_drv_cb.Haddr   <= req.Haddr;
        vif.ahb_drv_cb.Hreadyin<= 1'b1;
		
        @(vif.ahb_drv_cb);

        //wait till Hreadyout goes high - the moment it goes high drive Hwdata
        
        wait(vif.ahb_drv_cb.Hreadyout)
         //while(vif.ahb_drv_cb.Hreadyout !== 1)
               // @(vif.ahb_drv_cb);

        if(req.Hwrite)
                vif.ahb_drv_cb.Hwdata<=req.Hwdata;
        else
                vif.ahb_drv_cb.Hwdata<=32'b0;
 
       // `uvm_info("AHB_DRIVER", "Displaying ahb_driver data", UVM_LOW)
         req.print();

        //After driving Hwdata, we should immediately drive the address in the same cycle, so endtask w/o any delay

endtask

