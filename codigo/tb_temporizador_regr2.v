//modificar los valores del temporizadodr en el archivo del módulo.
`timescale 1ns / 1ps
`include "temporizador_regr2.v"
module tb_timer();

    // Señales internas
    reg clk;
    reg rst_n;
    wire [5:0] o_seconds;
    wire [5:0] o_minutes;
    wire [5:0] o_hours;

    // Parámetros del reloj
    localparam CLOCK_PERIOD = 20; // 20 ns

    // Instancia del módulo a probar
    timer_2 #(
        .CLOCK_FREQ(10)  
            // <<< valor reducido para simulación (10 ciclos = 1 "segundo")
        
    ) 
    uut (
        .clk(clk),
        .rst_n(rst_n),
        .o_seconds(o_seconds),
        .o_minutes(o_minutes),
        .o_hours(o_hours)
    );

    // Generador de reloj
    always #(CLOCK_PERIOD/2) clk = ~clk;

    // Estímulos
    initial begin
        // Inicialización
       clk = 0;
       rst_n = 0;
       #40;           // espera dos ciclos de reloj
       rst_n = 1; 
       #1400;
       rst_n = 0;
       #40
       rst_n = 1;
       #500;
       rst_n = 0;
       #40
       rst_n = 1;

        // Simular más tiempo
        #18000;
        
    end

    
    initial begin
    $dumpfile("tb_temporizador_regr2.vcd");
    $dumpvars(-1, uut);
    #20000 $finish;
  end

endmodule
