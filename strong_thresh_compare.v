//--------------------------------------------------------------------------------------------
//
// Generated by X-HDL VHDL Translator - Version 2.0.0 Feb. 1, 2011
// ?? ?? 29 2018 17:22:40
//
//      Input file      : 
//      Component name  : strong_thresh_compare
//      Author          : 
//      Company         : 
//
//      Description     : 
//
//
//--------------------------------------------------------------------------------------------


module strong_thresh_compare(
   strong_accumulator_result,
   strong_thresh,
   q
);
   input [21:0] strong_accumulator_result;		// 22 bit signed
   input [11:0] strong_thresh;		// 12 bit signed
   output       q;		// assert '1' for strong_accumulator_result > strong_thresh
   reg          q;
   
   
   // vj_cpp calculates by:
   // if (stage_sum < 0.4*stage_thresh_array[i])
   // {return -i} //this breaks the classifier cascade
   
   // our vhdl implementation will avoid fraction multiplicaiton
   // ... achieved by multiplying inputs by constant decimal values
   // ... since 0.4=4/10 ... compare(strong_accumulator_result*10 > strong_thresh*4)
   // ... compare result true = '1', else '0'
   
   wire [26:0]  result_mult0;		// 27 bit signed
   wire [15:0]  result_mult1;		// 16 bit signed
   
   assign result_mult0 = (signed_xhdl0(strong_accumulator_result) * to_signed(6, 5));
   assign result_mult1 = (signed_xhdl0(strong_thresh) * to_signed(7, 4));
   
   
   always @(result_mult0 or result_mult1)
      if (signed_xhdl0(result_mult0) > signed_xhdl0(result_mult1))
         q <= 1'b1;
      else
         q <= 1'b0;
   
endmodule
