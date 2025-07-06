class ahb_apb_env_config extends uvm_object;

        `uvm_object_utils(ahb_apb_env_config)

        int no_of_ahb_agents = 1;
        int no_of_apb_agents = 1;
        bit has_scoreboard = 1;
        bit has_virtual_sequencer = 1;


        ahb_agent_config ahb_cfg[];
        apb_agent_config apb_cfg[];

        extern function new(string name = "ahb_apb_env_config");
endclass

function ahb_apb_env_config::new(string name = "ahb_apb_env_config");
        super.new(name);
endfunction
