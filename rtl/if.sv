interface intf(input bit clock);

        //Inputs or outputs:
                logic Hresetn, Hwrite; //clk,reset,transfer direction - master

                //transfer size - master
                logic [2:0] Hsize;

                //transfer type - master
                logic [1:0] Htrans;

                logic Hreadyin;
                //transfer done indicator - Slave
                logic Hreadyout;
                
                logic [31:0] Haddr;

                //burst type - master
                logic [2:0] Hburst;

                //transfer response - Slave
                logic [1:0] Hresp;

                //write data bus - master
                logic [31:0] Hwdata;

                //read data bus - slave
                logic [31:0] Hrdata;




        logic Penable, Pwrite; //APB strobe, APB transfer direction - master

        //APB read data bus - slave
        logic [31:0] Prdata;

        //APB write data bus - master
        logic [31:0] Pwdata;

        //APB addr bus - master
        logic [31:0] Paddr;

        //APB select - master
        logic [3:0] Pselx;



        //APB Driver
        clocking apb_drv_cb @(posedge clock);
                default input #1 output #1;
                output Prdata;
                input Penable;
                input Pwrite;
                input Pselx; 
        endclocking

        //APB monitor
        clocking apb_mon_cb @(posedge clock);
                default input #1 output #1;
                input Prdata;
                input Penable;
                input Pwrite;
                input Pselx;
                input Paddr;
                input Pwdata;
        endclocking
	
				
        //AHB DRIVER clocking block:
        clocking ahb_drv_cb@(posedge clock);
                default input #1 output #1;
                                output Hwrite;
                                output Hreadyin;
                                output Hwdata;
                                output Haddr;
                                output Htrans;
                                output Hburst;
                                output Hresetn;
                                output Hsize;
			        input Hrdata;
                                input Hreadyout;
        endclocking

        //AHB MONITOR clocking block:
                clocking ahb_mon_cb@(posedge clock);
                default input #1 output #1;
                                input Hwrite;
                                input Hreadyin;
                                input Hwdata;
                                input Haddr;
                                input Htrans;
                                input Hburst;
                                input Hresetn;
                                input Hsize;
                                input Hreadyout;
				input Hrdata;
        endclocking

       //DRIVER and monitor modport:
    modport APB_DR_MP (clocking apb_drv_cb);
    modport APB_MON_MP (clocking apb_mon_cb);
        modport AHB_DR_MP (clocking ahb_drv_cb);
        modport AHB_MON_MP (clocking ahb_mon_cb);


endinterface
