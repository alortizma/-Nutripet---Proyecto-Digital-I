module timer_top
#(parameter CLOCK_FREQ = 32'd50_000_000)
(
    input clk,
    input rst_n,
    output [6:0] o_SEG,     
    output [5:0] o_DIG      
);

    wire [5:0] o_seconds;
    wire [5:0] o_minutes;
    wire [6:0] o_hours;

    wire [11:0] seconds_bcd;
    wire [11:0] minutes_bcd;
    wire [11:0] hours_bcd;

    timer #(.CLOCK_FREQ(CLOCK_FREQ)) TMRO (
        .clk(clk), .rst_n(rst_n),
        .o_seconds(o_seconds),
        .o_minutes(o_minutes),
        .o_hours(o_hours)
    );

    bin2bcd B2D_SEC (.clk(clk), .rst_n(rst_n), .i_bin({2'b0, o_seconds}), .o_bcd(seconds_bcd));
    bin2bcd B2D_MIN (.clk(clk), .rst_n(rst_n), .i_bin({2'b0, o_minutes}), .o_bcd(minutes_bcd));
    bin2bcd B2D_HOUR(.clk(clk), .rst_n(rst_n), .i_bin({1'b0, o_hours}),   .o_bcd(hours_bcd));

    wire [3:0] digit[5:0];
    assign digit[0] = seconds_bcd[3:0];
    assign digit[1] = seconds_bcd[7:4];
    assign digit[2] = minutes_bcd[3:0];
    assign digit[3] = minutes_bcd[7:4];
    assign digit[4] = hours_bcd[3:0];
    assign digit[5] = hours_bcd[7:4];

    display_mux6 dispMux(
        .clk(clk),
        .rst_n(rst_n),
        .i_digit0(digit[0]),
        .i_digit1(digit[1]),
        .i_digit2(digit[2]),
        .i_digit3(digit[3]),
        .i_digit4(digit[4]),
        .i_digit5(digit[5]),
        .o_seg(o_SEG),
        .o_dig(o_DIG)
    );

endmodule
