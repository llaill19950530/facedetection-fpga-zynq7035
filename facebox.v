//--------------------------------------------------------------------------------------------
//
// Generated by X-HDL VHDL Translator - Version 2.0.0 Feb. 1, 2011
// ?? ?? 29 2018 17:05:39
//
//      Input file      : 
//      Component name  : facebox
//      Author          : 
//      Company         : 
//
//      Description     : 
//
//
//--------------------------------------------------------------------------------------------


module faceBox(reset, clk_subwin, clk_faceBox, start_draw, scale, x_pos_subwin, y_pos_subwin, subwin_done, subwin_detection, img_wraddress, img_wrdata, img_wren, done_draw);
   input            reset;
   input            clk_subwin;
   input            clk_faceBox;
   input            start_draw;
   input [3:0]      scale;
   input [8:0]      x_pos_subwin;
   input [7:0]      y_pos_subwin;
   input            subwin_done;
   input [15:0]     subwin_detection;
   output [16:0]    img_wraddress;
   output [11:0]    img_wrdata;
   output           img_wren;
   output           done_draw;
   reg              done_draw;
   
   
   wire             info_wren;
   wire [36:0]      info_wrdata;
   wire [36:0]      info_rddata;
   
   wire [9:0]       count_box_in;
   wire             count_box_in_en;
   wire             count_box_in_reset;
   wire [13:0]      count_box_out;
   reg              count_box_out_en;
   reg              count_box_out_reset;
   wire [8:0]       count_box_dim;
   reg              count_box_dim_en;
   reg              count_box_dim_reset;
   
   wire [15:0]      detection;
   wire [3:0]       scale_s;
   wire [8:0]       x_pos_subwin_s;
   wire [7:0]       y_pos_subwin_s;
   
   wire [12:0]      x_box;
   wire [11:0]      y_box;
   wire [8:0]       dim_box;
   
   reg [16:0]       img_wraddress_s;
   reg              img_wren_s;
   
   reg              sel_inc_num;
   reg [8:0]        inc_num;
   wire [20:0]      box_base_address;
   reg              img_wraddress_reset;
   reg              wraddress_accum_en;
   wire             box_detection;
   
   wire [20:0]      mult_temp;
   wire [7:0]       mult_temp2;
   wire [12:0]      add_temp;
   
   parameter [3:0]  STATE_TYPE_s_RESET = 0,
                    STATE_TYPE_s_setup_info_rdaddress = 1,
                    STATE_TYPE_s_buff_setup = 2,
                    STATE_TYPE_s_TOP = 3,
                    STATE_TYPE_s_RIGHT = 4,
                    STATE_TYPE_s_LEFT = 5,
                    STATE_TYPE_s_BOTTOM = 6,
                    STATE_TYPE_s_check_box_out_count = 7,
                    STATE_TYPE_s_DONE = 8;
   reg [3:0]        current_state;
   reg [3:0]        next_state;
   
   parameter [1:0]  STATE_TYPE2_s_RESET = 0,
                    STATE_TYPE2_s_img_buff_latch = 1;
   wire [1:0]       cs_logDetection;
   wire [1:0]       ns_logDetection;
   
   assign count_box_in_reset = reset;
   assign info_wren = subwin_done;
   assign count_box_in_en = subwin_done;
   
   assign info_wrdata = {subwin_detection, scale, x_pos_subwin, y_pos_subwin};
   
   
   counter #(10) box_in_counter(
   .clk(clk_subwin), 
   .reset(count_box_in_reset), 
   .en(count_box_in_en), 
   .count(count_box_in)
   );
   
   
   counter #(14) box_out_counter(
   .clk(clk_faceBox), 
   .reset(count_box_out_reset), 
   .en(count_box_out_en), 
   .count(count_box_out)
   );
   
   
   counter2 #(9) box_dim_counter(
   .clk(clk_faceBox), 
   .reset(count_box_dim_reset), 
   .en(count_box_dim_en), 
   .count(count_box_dim)
   );
   
   
   faceBox_buff faceBox_ram(
   .dina(info_wrdata), 
   .addrb(count_box_out[13:4]), 
   .clkb(clk_faceBox), 
   .addra(count_box_in), 
   .clka(clk_subwin), 
   .ena(info_wren),
   .wea(1'b1),
   .enb(1'b1), 
   .doutb(info_rddata)
   );
   
   
   always @(posedge clk_faceBox)
   begin
      if (sel_inc_num == 1'b0)
         inc_num <= 1;
      else
         inc_num <= 320;
   end
   
   
   always @(posedge clk_faceBox )
      
      begin
         if (img_wraddress_reset == 1'b1)
            img_wraddress_s <= box_base_address[16:0];
         else if (wraddress_accum_en == 1'b1)
            img_wraddress_s <= img_wraddress_s + inc_num;
      end

   
   assign box_detection = detection[count_box_out[3:0]];
   
   
   always @(posedge clk_faceBox or posedge reset)
   begin
      if (reset == 1'b1)
         current_state <= STATE_TYPE_s_RESET;
      else 
         current_state <= next_state;
   end
   
   
   always @(posedge clk_faceBox	 or posedge reset)
   begin 	
   	if (reset == 1'b1) begin
      img_wraddress_reset <= 1'b0;
      sel_inc_num <= 1'b0;
      img_wren_s <= 1'b0;
      wraddress_accum_en <= 1'b0;
      count_box_dim_reset <= 1'b0;
      count_box_dim_en <= 1'b0;
      count_box_out_reset <= 1'b0;
      count_box_out_en <= 1'b0;
      done_draw <= 1'b0;
      end
     else	 case (current_state)
         STATE_TYPE_s_RESET :
            begin
               count_box_out_reset <= 1'b1;
               
               if (start_draw == 1'b1)
               begin
                  if (count_box_in == 0)
                     next_state <= STATE_TYPE_s_DONE;
                  else
                     next_state <= STATE_TYPE_s_setup_info_rdaddress;
               end
               else
                  next_state <= STATE_TYPE_s_RESET;
            end
         
         STATE_TYPE_s_setup_info_rdaddress :
            next_state <= STATE_TYPE_s_buff_setup;
         
         STATE_TYPE_s_buff_setup :
            begin
               img_wraddress_reset <= 1'b1;
               if (box_detection == 1'b0)
                  next_state <= STATE_TYPE_s_TOP;
               else
                  next_state <= STATE_TYPE_s_check_box_out_count;
            end
         
         STATE_TYPE_s_TOP :
            begin
               img_wren_s <= 1'b1;
               sel_inc_num <= 1'b0;
               
               if (count_box_dim < dim_box)
               begin
                  wraddress_accum_en <= 1'b1;
                  count_box_dim_en <= 1'b1;
                  next_state <= STATE_TYPE_s_TOP;
               end
               else
               begin
                  count_box_dim_reset <= 1'b1;
                  next_state <= STATE_TYPE_s_RIGHT;
               end
            end
         
         STATE_TYPE_s_RIGHT :
            begin
               img_wren_s <= 1'b1;
               sel_inc_num <= 1'b1;
               
               if (count_box_dim < dim_box)
               begin
                  wraddress_accum_en <= 1'b1;
                  count_box_dim_en <= 1'b1;
                  next_state <= STATE_TYPE_s_RIGHT;
               end
               else
               begin
                  count_box_dim_reset <= 1'b1;
                  img_wraddress_reset <= 1'b1;
                  next_state <= STATE_TYPE_s_LEFT;
               end
            end
         
         STATE_TYPE_s_LEFT :
            begin
               img_wren_s <= 1'b1;
               sel_inc_num <= 1'b1;
               
               if (count_box_dim < dim_box)
               begin
                  wraddress_accum_en <= 1'b1;
                  count_box_dim_en <= 1'b1;
                  next_state <= STATE_TYPE_s_LEFT;
               end
               else
               begin
                  count_box_dim_reset <= 1'b1;
                  next_state <= STATE_TYPE_s_BOTTOM;
               end
            end
         
         STATE_TYPE_s_BOTTOM :
            begin
               img_wren_s <= 1'b1;
               sel_inc_num <= 1'b0;
               
               if (count_box_dim < dim_box)
               begin
                  wraddress_accum_en <= 1'b1;
                  count_box_dim_en <= 1'b1;
                  next_state <= STATE_TYPE_s_BOTTOM;
               end
               else
               begin
                  count_box_dim_reset <= 1'b1;
                  next_state <= STATE_TYPE_s_check_box_out_count;
               end
            end
         
         STATE_TYPE_s_check_box_out_count :
            if (count_box_out[13:4] == count_box_in - 1)
               next_state <= STATE_TYPE_s_DONE;
            else
            begin
               count_box_out_en <= 1'b1;
               count_box_dim_reset <= 1'b1;
               next_state <= STATE_TYPE_s_setup_info_rdaddress;
            end
         
         STATE_TYPE_s_DONE :
            begin
               done_draw <= 1'b1;
               next_state <= STATE_TYPE_s_RESET;
            end
      endcase
   end
   
   assign detection = info_rddata[36:21];
   assign scale_s = info_rddata[20:17];
   assign x_pos_subwin_s = info_rddata[16:8];
   assign y_pos_subwin_s = info_rddata[7:0];
   
   assign dim_box = (5'd23 * scale_s);
   assign x_box = x_pos_subwin_s * scale_s;
   assign y_box = y_pos_subwin_s * scale_s;
   assign mult_temp = (y_box * 9'd320);
   assign mult_temp2 = ((count_box_out[3:0]) * scale_s);
   assign add_temp = (x_box + mult_temp2);
   assign box_base_address = (mult_temp + add_temp);
   
   assign img_wrdata = 12'b111100000000;
   assign img_wren = img_wren_s;
   assign img_wraddress = img_wraddress_s;
   
endmodule