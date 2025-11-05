`timescale 1ns / 1ps
`include "div_m.v"
`include "motor.v"
module tb_motor();

reg clk;
wire [3:0] M;


// Parámetros del reloj
localparam CLOCK_PERIOD = 20; // 20 ns

motor uut (
    .clk(clk),
    .M(M)
);

// Generador de reloj
always #(CLOCK_PERIOD/2) clk = ~clk;

initial begin
    clk = 0;
    #5000;
end

initial begin
    $dumpfile("tb_motor.vcd");
    $dumpvars(-1, uut);
    #5000 $finish;
end

endmodule