`timescale 1ns / 1ps
`include "div_m.v"
`include "motor.v"
`include "porciones.v"
`include "temporizador_regr2.v"
`include "topModule.v"

module tb_topModule;

    // Entradas al DUT
    reg clk;
    reg rst_n;

    // Salidas del DUT
    wire [5:0] segundos;
    wire [5:0] minutos;
    wire [6:0] horas;
    wire [2:0] porciones_f;
    wire [3:0] M;

    // Instancia del módulo a probar (Device Under Test)
    topModule uut (
        .clk(clk),
        .rst_n(rst_n),
        .segundos(segundos),
        .minutos(minutos),
        .horas(horas),
        .porciones_f(porciones_f),
        .M(M)
    );

    // Generador de reloj: periodo de 10 ns (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Secuencia de estímulos
    initial begin
        // Inicialización
        rst_n = 0;
        #20;
        rst_n = 1;

        // Simulación principal: observa por unos milisegundos simulados
        #18000; // ajusta según tu escala de tiempo y divisor interno

        // Fin de la simulación
        $finish;
    end

    // Monitoreo de variables
    initial begin
    $dumpfile("tb_topModule.vcd");
    $dumpvars(-1, uut);
    #20000 $finish;
  end

endmodule
