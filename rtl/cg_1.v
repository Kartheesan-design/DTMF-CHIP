module cg_1 (ck_in, enable , scan_en , ck_out);

    input   ck_in, enable;
    output  ck_out;
    inout  scan_en;
    
    reg    ck_out;
    wire   rstn;
assign rstn = !ck_in;

always @ (ck_in or enable or rstn)
       if (rstn)
          ck_out = 1'b0;
       else if (enable)
          ck_out = 1'b1;
endmodule

