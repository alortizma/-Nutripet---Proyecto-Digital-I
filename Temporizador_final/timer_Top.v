module top_timer(
    input clk,
    input rst_n,
    output rs,
    output rw,
    output en,
    output [7:0] dat
);

wire [5:0] sec, min;
wire [6:0] hr;

wire [11:0] bcd_sec, bcd_min, bcd_hr;

// --- Temporizador ---
timer u_timer(
    .clk(clk),
    .rst_n(rst_n),
    .o_seconds(sec),
    .o_minutes(min),
    .o_hours(hr)
);

// --- Conversión BCD ---
bin2bcd bcd_s(.clk(clk), .rst_n(rst_n), .i_bin({2'b0,sec}), .o_bcd(bcd_sec));
bin2bcd bcd_m(.clk(clk), .rst_n(rst_n), .i_bin({2'b0,min}), .o_bcd(bcd_min));
bin2bcd bcd_h(.clk(clk), .rst_n(rst_n), .i_bin({1'b0,hr}),  .o_bcd(bcd_hr));

// --- LCD Display ---
lcd_display lcd(
    .clk(clk),
    .rst_n(rst_n),
    .bcd_hours(bcd_hr),
    .bcd_minutes(bcd_min),
    .bcd_seconds(bcd_sec),
    .rs(rs),
    .rw(rw),
    .en(en),
    .dat(dat)
);

endmodule
