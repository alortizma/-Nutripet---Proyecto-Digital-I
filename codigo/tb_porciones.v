//modificar los valores del temporizadodr en el archivo del módulo.
`timescale 1ns / 1ps
`include "porciones.v"
module tb_porciones();

    // Señales internas
    reg clk;
    reg rst_n;
    reg tick_fin;
    wire [2:0] porciones_f;

    // Parámetros del reloj
    localparam CLOCK_PERIOD = 20; // 20 ns

    // Instancia del módulo a probar
    porciones uut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_fin(tick_fin),
        .porciones_f(porciones_f)
    );

    // Generador de reloj
    always #(CLOCK_PERIOD/2) clk = ~clk;

    // Estímulos
    initial begin
        // Inicialización
       clk = 0;
       rst_n = 0;
       tick_fin = 1;
       #40;           // espera dos ciclos de reloj
       rst_n = 1; 
       #1400;
       tick_fin = 1;
       #500;
       tick_fin = 0;
       #500;
       rst_n = 0;
       #40
       rst_n = 1;

        // Simular más tiempo
        #4000;
        
    end

    
    initial begin
    $dumpfile("tb_porciones.vcd");
    $dumpvars(-1, uut);
    #6000 $finish;
  end

endmodule
