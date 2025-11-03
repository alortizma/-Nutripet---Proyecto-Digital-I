module bin2bcd(
    input  clk,
    input  rst_n,
    input  [7:0] i_bin,   // from 8'h00 to 8'hFF
    output reg [11:0] o_bcd  // from 12'h000 to 8'h255
);

    // Internal variables
    reg [11:0] scratch_space;
    reg [3:0] i;
    reg [7:0] bin_ff;

    // Input pipeline register
    always @(posedge clk) begin
        // Pipeline stage that isolates the bin2bcd large combinational circuit
        if(!rst_n) begin
            bin_ff <= 0;   // use synchronous reset_n
        end else begin
            bin_ff <= i_bin;
        end
    end

    // Always block – implement the Double Dabble algorithm
    always @(*) begin
        scratch_space = 0;  // The scratch space is initialized to all zeros

        for (i = 0; i < 4'd8; i = i + 1'b1) begin // loops according to i_bin number of bits
            scratch_space = {scratch_space[10:0], bin_ff[7-i]}; // shift 1 bit starting from the MSB

            // If a hex digit of scratch_space is more than 4, add 3 to it
            if(i < 4'd7 && scratch_space[3:0] > 4'd4) begin
                scratch_space[3:0] = scratch_space[3:0] + 4'd3;
            end
            if(i < 4'd7 && scratch_space[7:4] > 4'd4) begin
                scratch_space[7:4] = scratch_space[7:4] + 4'd3;
            end
            if(i < 4'd7 && scratch_space[11:8] > 4'd4) begin
                scratch_space[11:8] = scratch_space[11:8] + 4'd3;
            end
        end
    end

    // Output pipeline register
    always @(posedge clk) begin
        // Pipeline stage that isolates the bin2bcd large combinational circuit
        if(!rst_n) begin
            o_bcd <= 0;   // use synchronous reset_n
        end else begin
            o_bcd <= scratch_space;
        end
    end

endmodule
