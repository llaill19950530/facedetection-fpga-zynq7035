//--------------------------------------------------------------------------------------------
//
// Generated by X-HDL VHDL Translator - Version 2.0.0 Feb. 1, 2011
// ?? ?? 29 2018 17:05:26
//
//      Input file      : 
//      Component name  : demux_1_2
//      Author          : 
//      Company         : 
//
//      Description     : 
//
//
//--------------------------------------------------------------------------------------------


module demux_1_2(sel, a, q0, q1);
   parameter               DATA_WIDTH = 4;
   input                   sel;
   input [DATA_WIDTH-1:0]  a;
   output [DATA_WIDTH-1:0] q0;
   reg [DATA_WIDTH-1:0]    q0;
   output [DATA_WIDTH-1:0] q1;
   reg [DATA_WIDTH-1:0]    q1;
   
   
   
   always @(a or sel)
   begin: mux0
      
      if (sel == 1'b1)
      begin
         q0 <= {DATA_WIDTH{1'b0}};
         q1 <= a;
      end
      else
      begin
         q0 <= a;
         q1 <= {DATA_WIDTH{1'b0}};
      end
   end
   
endmodule
