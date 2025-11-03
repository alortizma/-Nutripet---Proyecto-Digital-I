module timer
#( parameter CLOCK_FREQ = 32'd50_000_000 ) // 50MHz frecuencia del reloj de la FPGA
(
    // Puertos
    input clk,
    input rst_n,
    output [5:0] o_seconds, // 0–59 segundos
    output [5:0] o_minutes, // 0–59 minutos
    output [6:0] o_hours    // 0–99 horas
);

localparam ONE_SECOND = CLOCK_FREQ - 1; // Número de ciclos del reloj equivalentes a un segundo

// Lógica interna
reg [5:0] seconds_cnt;  // 0–59 segundos
reg [5:0] minutes_cnt;  // 0–59 minutos
reg [6:0] hours_cnt;    // 0–99 horas (8’d99 es el valor más grande que se puede representar en 7 segementos)
reg [31:0] counter_1sec; // cuenta cada ciclo del reloj (max valor 2**32 > 4.2bln)

// Código para el temporizador
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        counter_1sec <= 0;
        seconds_cnt  <= 6'd0;
        minutes_cnt  <= 6'd2;
        hours_cnt    <= 7'd0;
    end else begin
        if (seconds_cnt==0 && minutes_cnt==0 && hours_cnt==0) begin
            seconds_cnt  <= 6'd0;
            minutes_cnt  <= 6'd2;
            hours_cnt    <= 7'd0;
            counter_1sec <= 0;
            end else begin
        if (counter_1sec == ONE_SECOND) begin
            counter_1sec <= 0;

            if (seconds_cnt == 0) begin // incrementa el contador de segundos
                seconds_cnt <= 6'd59;

                if (minutes_cnt == 0) begin // incremena el contador de minutos
                    minutes_cnt <= 6'd59;

                    if (hours_cnt == 0) begin // incrementa el contador de horas (will roll over after 99 hours)
                        hours_cnt <= 7'd99;
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
end

// Output assignments
assign o_seconds = seconds_cnt;
assign o_minutes = minutes_cnt;
assign o_hours   = hours_cnt;

endmodule
