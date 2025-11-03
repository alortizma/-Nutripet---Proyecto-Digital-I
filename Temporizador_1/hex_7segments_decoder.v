module hex_7seg_decoder
    // Parameters section
    #(parameter COMMON_ANODE_CATHODE = 1 )// 0 for common Anode / 1 for common cathode
(
    // Ports section
    input  [3:0] in,
    output o_a,
    output o_b,
    output o_c,
    output o_d,
    output o_e,
    output o_f,
    output o_g
    //output dot // optional - NOT used on DE1-SoC board
);

    // Internal logic
    reg a, b, c, d, e, f, g;

    // Use concatenation to pass values to all outputs at the same time
    always @(*) begin
        case (in)
            4'd0: {a,b,c,d,e,f,g} = 7'b0000001; // common cathode value
            4'd1: {a,b,c,d,e,f,g} = 7'b1001111;
            4'd2: {a,b,c,d,e,f,g} = 7'b0010010;
            4'd3: {a,b,c,d,e,f,g} = 7'b0000110;
            4'd4: {a,b,c,d,e,f,g} = 7'b1001100;
            4'd5: {a,b,c,d,e,f,g} = 7'b0100100;
            4'd6: {a,b,c,d,e,f,g} = 7'b0100000;
            4'd7: {a,b,c,d,e,f,g} = 7'b0001111;
            4'd8: {a,b,c,d,e,f,g} = 7'b0000000;
            4'd9: {a,b,c,d,e,f,g} = 7'b0000100;
            4'd10: {a,b,c,d,e,f,g} = 7'b0001000;
            4'd11: {a,b,c,d,e,f,g} = 7'b1100000;
            4'd12: {a,b,c,d,e,f,g} = 7'b0110001;
            4'd13: {a,b,c,d,e,f,g} = 7'b1000010;
            4'd14: {a,b,c,d,e,f,g} = 7'b0110000;
            4'd15: {a,b,c,d,e,f,g} = 7'b0111000;
            default: {a,b,c,d,e,f,g} = 7'b1111111;  // best practice
        endcase
    end

    assign {o_a, o_b, o_c, o_d, o_e, o_f, o_g} = COMMON_ANODE_CATHODE ? {a,b,c,d,e,f,g} : ~{a,b,c,d,e,f,g};

    // If you want the dot open assign 0 to it otherwise 1
    // assign dot = 1'b1;

endmodule
