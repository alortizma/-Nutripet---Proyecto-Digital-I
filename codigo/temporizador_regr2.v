module timer_2
#( parameter CLOCK_FREQ = 9)//32'd50_000_000 ) // 50MHz frecuencia del reloj de la FPGA
(
    // Puertos
    input clk,
    input rst_n,
    output [5:0] o_seconds, // 0–59 segundos
    output [5:0] o_minutes, // 0–59 minutos
    output [6:0] o_hours    // 0–99 horas 
);

localparam ONE_SECOND = CLOCK_FREQ - 1; // Número de ciclos del reloj equivalentes a un segundo

//Parámetros configurables del contador regresivo
parameter [5:0] INIT_HORAS   = 6'd0;
parameter [5:0] INIT_MINUTOS = 6'd0;
parameter [5:0] INIT_SEGUNDOS = 6'd5;

// Lógica interna
reg [5:0] seconds_cnt;  // 0–59 segundos
reg [5:0] minutes_cnt;  // 0–59 minutos
reg [6:0] hours_cnt;    // 0–99 horas (8’d99 es el valor más grande que se puede representar en 7 segementos)
reg [31:0] counter_1sec; // cuenta cada ciclo del reloj (max valor 2**32 > 4.2bln)

// Código para el temporizador
always @(posedge clk or negedge rst_n) // Si el pin no tiene lógica negada entonces cambiar el negedge por posedge y el if(!rst_n) por if(rst)
begin
    if(!rst_n) begin
        counter_1sec <= 32'b0;
        seconds_cnt  <= INIT_SEGUNDOS;
        minutes_cnt  <= INIT_MINUTOS;
        hours_cnt    <= INIT_HORAS;

    end else begin
        //Bloque del temporizador
        if (counter_1sec == ONE_SECOND) begin
            counter_1sec <= 0;

            if (seconds_cnt == 0) begin // decrementa el contador de segundos

                if(INIT_MINUTOS == 0 && INIT_HORAS == 0)begin
                    seconds_cnt <= INIT_SEGUNDOS;
                end else begin
                    seconds_cnt <= 6'd59;
                end
                               
                if (minutes_cnt == 0) begin // decrementa el contador de minutos
                    
                    if(INIT_HORAS == 0)begin
                        minutes_cnt <= INIT_MINUTOS;
                    end else begin
                        minutes_cnt <= 6'd59;
                    end

                    if (hours_cnt == 0) begin // decrementa el contador de horas desde el valor programado (maximo valor: 23:59:59)
                        hours_cnt <= INIT_HORAS;
                    end else begin
                        hours_cnt <= hours_cnt - 1'b1;
                    end
                end else begin
                    minutes_cnt <= minutes_cnt - 1'b1;
                end

            end else begin
                seconds_cnt <= seconds_cnt - 1'b1;
            end

        end else begin
            counter_1sec <= counter_1sec + 1'b1;
        end
    end
end

// Output assignments
assign o_seconds = seconds_cnt;
assign o_minutes = minutes_cnt;
assign o_hours   = hours_cnt;

endmodule
