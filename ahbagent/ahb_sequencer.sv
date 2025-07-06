////AHB SEQUENCER////
class ahb_sequencer extends uvm_sequencer #(ahb_xtn);

        `uvm_component_utils(ahb_sequencer)

        extern function new(string name = "ahb_sequencer", uvm_component parent=null);

	
endclass

/////----Constructor----/////
function ahb_sequencer::new(string name = "ahb_sequencer", uvm_component parent=null);
        super.new(name,parent);
endfunction
