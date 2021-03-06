//--------------------------------------------------------------------------------------------
//
// Generated by X-HDL VHDL Translator - Version 2.0.0 Feb. 1, 2011
// ?? ?? 29 2018 21:39:48
//
//      Input file      : 
//      Component name  : subwindow
//      Author          : 
//      Company         : 
//
//      Description     : 
//
//
//--------------------------------------------------------------------------------------------


module subwindow(reset, clk, en_strongAccum, en_var_norm, left_tree, right_tree, weak_thresh, strong_thresh, w0, w1, w2, ii_reg_we, ii_reg_address, ii_data, iix2_reg_we, iix2_reg_index, iix2_data, detection);
   input        reset;
   input        clk;
   input        en_strongAccum;
   input        en_var_norm;
   input [13:0] left_tree;
   input [13:0] right_tree;
   input [12:0] weak_thresh;
   input [11:0] strong_thresh;
   input [14:0] w0;
   input [14:0] w1;
   input [14:0] w2;
   input        ii_reg_we;
   input [3:0]  ii_reg_address;
   input [19:0] ii_data;
   input        iix2_reg_we;
   input [1:0]  iix2_reg_index;
   input [27:0] iix2_data;
   output       detection;
   
   
   wire [19:0]  r0;
   wire [19:0]  r1;
   wire [19:0]  r2;
   wire [19:0]  r3;
   wire [19:0]  r4;
   wire [19:0]  r5;
   wire [19:0]  r6;
   wire [19:0]  r7;
   wire [19:0]  r8;
   wire [19:0]  r9;
   wire [19:0]  r10;
   wire [19:0]  r11;
   
   wire [19:0]  p0;
   wire [19:0]  p1;
   wire [19:0]  p2;
   wire [19:0]  p3;
   wire [27:0]  ssp0;
   wire [27:0]  ssp1;
   wire [27:0]  ssp2;
   wire [27:0]  ssp3;
   
   wire [38:0]  result_feature;
   wire [21:0]  var_norm_factor;
   reg [21:0]   var_norm_factor_reg;
   wire [34:0]  var_norm_weak_thresh;
   reg          tree_mux_sel;
   reg [13:0]   tree_mux_result;
   reg [21:0]   strong_accumulator_result;
   reg          stage_detection;
   
   wire [26:0]  result_mult0;
   wire [15:0]  result_mult1;
   
   
   register_file #(4, 20) ii_reg(
   .clk(clk), 
   .write_en(ii_reg_we), 
   .write_reg_addr(ii_reg_address), 
   .write_data(ii_data), 
   .q0(r0), 
   .q1(r1), 
   .q2(r2), 
   .q3(r3), 
   .q4(r4), 
   .q5(r5), 
   .q6(r6), 
   .q7(r7), 
   .q8(r8), 
   .q9(r9), 
   .q10(r10), 
   .q11(r11)
   );
   
   
   register_file2 #(2, 20) ii_corner_reg(
   .clk(clk), 
   .write_en(iix2_reg_we), 
   .write_reg_addr(iix2_reg_index), 
   .write_data(ii_data), 
   .q0(p0), 
   .q1(p1), 
   .q2(p2), 
   .q3(p3)
   );
   
   
   register_file2 #(2, 28) iix2_corner_reg(
   .clk(clk), 
   .write_en(iix2_reg_we), 
   .write_reg_addr(iix2_reg_index), 
   .write_data(iix2_data), 
   .q0(ssp0), 
   .q1(ssp1), 
   .q2(ssp2), 
   .q3(ssp3)
   );
   
   
   feature_calc feature_calc0(
   .w0(w0), 
   .w1(w1), 
   .w2(w2), 
   .r0(r0), 
   .r1(r1), 
   .r2(r2), 
   .r3(r3), 
   .r4(r4), 
   .r5(r5), 
   .r6(r6), 
   .r7(r7), 
   .r8(r8), 
   .r9(r9), 
   .r10(r10), 
   .r11(r11), 
   .result_feature(result_feature)
   );
   
   
   var_norm_calc var_norm_calc0(
   .clk(clk), 
   .p0(p0), 
   .p1(p1), 
   .p2(p2), 
   .p3(p3), 
   .ssp0(ssp0), 
   .ssp1(ssp1), 
   .ssp2(ssp2), 
   .ssp3(ssp3), 
   .var_norm_factor(var_norm_factor)
   );
   
   
   always @(posedge clk )      
      begin
         if (en_var_norm == 1'b1)
            var_norm_factor_reg <= var_norm_factor;
      end

   
   assign var_norm_weak_thresh = weak_thresh * var_norm_factor_reg;
   
   
   always @(posedge	 clk)
   begin
      if (result_feature > var_norm_weak_thresh)
         tree_mux_sel <= 1'b1;
      else
         tree_mux_sel <= 1'b0;
   end
   
   
   always @(posedge clk)
   begin
      if (tree_mux_sel == 1'b1)
         tree_mux_result <= right_tree;
      else
         tree_mux_result <= left_tree;
   end
   
   
   always @(posedge	clk or posedge	reset )
   begin
      if (reset == 1'b1)
         strong_accumulator_result <= 22'b0;
      else if (en_strongAccum == 1'b1)
         strong_accumulator_result <= tree_mux_result + strong_accumulator_result;
   end
   
   assign result_mult0 = strong_accumulator_result[6:5];
   assign result_mult1 = strong_thresh[7:4];
   
   
   always @(posedge clk)
      if (result_mult0 > result_mult1)
         stage_detection <= 1'b1;
      else
         stage_detection <= 1'b0;
   
   assign detection = stage_detection;
   
endmodule
