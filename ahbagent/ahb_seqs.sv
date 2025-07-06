class base_sequence_ahb extends uvm_sequence #(ahb_xtn);

        `uvm_object_utils(base_sequence_ahb)
    	
        extern function new(string name = "base_sequence_ahb");
endclass

function base_sequence_ahb::new(string name = "base_sequence_ahb");
        super.new(name);
endfunction

class single_transfer_sequence extends base_sequence_ahb;

    `uvm_object_utils(single_transfer_sequence)

    extern function new (string name = "single_transfer_sequence");
    extern task body();

endclass

    // Constructor to initialize the sequence with a name.
    function single_transfer_sequence::new (string name = "single_transfer_sequence");
        super.new(name);
    endfunction


    // Main sequence body to generate random AHB transactions.
    task single_transfer_sequence::body();
          // begin
//`uvm_info("SEQ", $sformatf("Running on sequencer: %s", get_sequencer().get_full_name()), UVM_NONE)

                //$display("single_seq");
           req = ahb_xtn::type_id::create("req");
                //$display("single_seq111111111111111111111111111111111");

           start_item(req);
               // $display("single_seq");

           req.randomize() with {Htrans==2;Hburst==0;Hwrite==0;};
     //      req.print();
           finish_item(req);

         //  end

    endtask



class increment_transfer_sequence extends base_sequence_ahb;

	`uvm_object_utils(increment_transfer_sequence)

	
                bit [31:0] haddr;
                bit hwrite;
                bit [2:0] hsize;
                bit [2:0] hburst;
                bit [9:0] hlength;


	extern function new(string name = "increment_transfer_sequence");
        extern task body();
endclass

function increment_transfer_sequence::new(string name = "increment_transfer_sequence");
        super.new(name);
endfunction


task increment_transfer_sequence::body();

        begin
        req = ahb_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize() with {Htrans == 2 && 
                                     Hburst inside {1,3,5,7};}); //first xtn is NS
        //$display("seq");                            
        //req.print();                             
        finish_item(req);
        

	//store in local variables
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        hlength= req.Hlength;

        for(int i=1; i<hlength; i++)
        begin
                       

                        start_item(req);

                        assert(req.randomize() with {Htrans == 3; 
                                                     Hsize==hsize;
                                                     Hburst == hburst;
                                                     Hwrite == hwrite; 
                                                     Haddr == haddr + (2**hsize);});
                        //req.print();                              
                        finish_item(req);
                       
                        haddr = req.Haddr;
          end
          
      end
                                                                   
endtask: body


class wrap_transfer_sequence extends base_sequence_ahb;

	`uvm_object_utils(wrap_transfer_sequence)

	
                bit [31:0] haddr;
                bit [31:0] start_address;
                bit [31:0] boundary_address;
                bit hwrite;
                bit [2:0] hsize;
                bit [2:0] hburst;
                bit [9:0] hlength;


	extern function new(string name = "wrap_transfer_sequence");
        extern task body();
endclass

function wrap_transfer_sequence::new(string name = "wrap_transfer_sequence");
        super.new(name);
endfunction


task wrap_transfer_sequence::body();

        begin
        req = ahb_xtn::type_id::create("req");

        start_item(req);
        assert(req.randomize() with {Htrans == 2 && 
                                     Hburst inside {2,4,6};}); //first xtn is NS
        //req.print();
        finish_item(req);

        

	//store in local variables
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        hlength= req.Hlength;


       start_address = int'((haddr / ((2**hsize) * hlength)) * ((2**hsize) * hlength));


       boundary_address=start_address+((2**hsize)*hlength);
       
       haddr = haddr + (2**hsize);

        for(int i=1; i<hlength; i++)
        begin
                       if(boundary_address==haddr)
                       haddr=start_address;

                       start_item(req);

                       assert(req.randomize() with {Htrans == 2'b11;
                                                    Hsize==hsize; 
                                                     Hburst == hburst;
                                                     Hwrite == hwrite; 
                                                     Haddr == haddr;});
                       //req.print();
                       finish_item(req);
                       
                       haddr = req.Haddr+(2**hsize);
          end
           
 end
                                                                   
endtask: body

