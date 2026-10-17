interface i2c_if(input clk);
  
  logic wr;
  logic rst;
  logic done;
  logic [6:0]addr;
  logic [7:0]din,datard;
  logic [3:0] state;
  
  clocking m_drv_cb@(posedge clk);
    output wr;
    output addr;
    output din;
    input done;
    inout rst;
    input datard;
    input state;
  endclocking
  
  clocking m_mon_cb@(posedge clk);
    input wr;
    input addr;
    input din;
    input done;
    input rst;input datard;
    input state;
  endclocking
  

  
  modport M_DRV_MP(clocking m_drv_cb);
    modport M_MON_MP(clocking m_mon_cb);
        
endinterface

