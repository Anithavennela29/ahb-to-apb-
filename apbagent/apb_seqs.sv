////////-Base sequence-----////
class base_sequence_apb extends uvm_sequence #(apb_xtn);

        `uvm_object_utils(base_sequence_apb)

        extern function new(string name = "base_sequence_apb");
endclass

function base_sequence_apb::new(string name = "base_sequence_apb");
        super.new(name);
endfunction

