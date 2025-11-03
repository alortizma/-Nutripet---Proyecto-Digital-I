module lcd_display(
    input clk,
    input rst_n,
    input [11:0] bcd_hours,   
    input [11:0] bcd_minutes, 
    input [11:0] bcd_seconds, 
    output reg rs,
    output reg en,
    output rw,
    output reg [7:0] dat
);

assign rw = 1'b0; 

reg [5:0] state;
reg [15:0] counter;
reg [7:0] text [0:15]; 

initial begin
    dat = 0;
    rs = 0;
    en = 0;
    state = 0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= 0;
        counter <= 0;
        rs <= 0;
        en <= 0;
    end else begin
        case(state)
            0: begin 
                dat <= 8'h38; 
                rs <= 0;
                en <= 1; state <= 1;
            end
            1: begin en <= 0; state <= 2; end
            2: begin
                dat <= 8'h0C; 
                rs <= 0; en <= 1; state <= 3;
            end
            3: begin en <= 0; state <= 4; end
            4: begin
                dat <= 8'h01; 
                rs <= 0; en <= 1; state <= 5;
            end
            5: begin en <= 0; state <= 10; end

            10: begin
                text[0]  <= (bcd_hours[11:8]   + 8'd48);
                text[1]  <= (bcd_hours[7:4]    + 8'd48);
                text[2]  <= ":";
                text[3]  <= (bcd_minutes[11:8] + 8'd48);
                text[4]  <= (bcd_minutes[7:4]  + 8'd48);
                text[5]  <= ":";
                text[6]  <= (bcd_seconds[11:8] + 8'd48);
                text[7]  <= (bcd_seconds[7:4]  + 8'd48);
                state <= 11;
            end

            11: begin
                dat <= 8'h80; 
                rs <= 0; en <= 1; state <= 12;
            end
            12: begin en <= 0; state <= 13; end

            13: begin
                dat <= text[counter[3:0]];
                rs <= 1; en <= 1;
                counter <= counter + 1;
                if(counter == 7) state <= 14;
            end
            14: begin en <= 0; state <= 10; counter <= 0; end
        endcase
    end
end
endmodule
