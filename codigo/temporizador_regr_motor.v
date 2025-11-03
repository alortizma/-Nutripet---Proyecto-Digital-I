module timerMotor 
#( parameter CLOCK_FREQ = 32'd50_000_000 ) // 50MHz frecuencia del reloj de la FPGA
(
    // Puertos
    input clk,
    input rst_n,
    output [5:0] o_seconds, // 0–59 segundos
    output [5:0] o_minutes, // 0–59 minutos
    output [5:0] o_hours,   // 0–23 horas
    output [3:0] M //señal que mueve el motor M
);

parameter ONE_SECOND = CLOCK_FREQ - 1; // Número de ciclos del reloj equivalentes a un segundo

//Parámetros configurables del contador regresivo
parameter [5:0] INIT_HORAS   = 6'd0;
parameter [5:0] INIT_MINUTOS = 6'd0;
parameter [5:0] INIT_SEGUNDOS = 6'd1;
parameter [2:0] INIT_PORCIONES = 3'd6;
parameter [9:0] INIT_CICLOSM = 10'd683; //683 ciclos para que complete 60°
parameter [3:0] INIT_MOTOR = 4'b0000;


//Contadores
reg [2:0] porciones = INIT_PORCIONES; // Número de porciones -> Número de temporizadores
reg [31:0] counter_1sec; // cuenta cada ciclo del reloj (max valor 2**32 > 4.2bln)
reg [5:0] seconds_cnt;  // 0–59 segundos
reg [5:0] minutes_cnt;  // 0–59 minutos
reg [5:0] hours_cnt;    // 0–23 horas 
reg [9:0] ciclos_motor; // contador de 683 ciclos del motor
reg estado_motor; // valor de 1 bit, que determina si el motor está prendido o apagado

// Señales del submódulo motor
wire [3:0] M_seq;        // secuencia que genera el submódulo motor
//Instanciación del motor
motor motor_inst(.clk(clk), .M(M_seq));

// Código para el temporizador
always @(posedge clk or negedge rst_n) // Si el pin no tiene lógica negada entonces cambiar el negedge por posedge y el if(!rst_n) por if(rst)

if(!rst_n) begin // detener o reiniciar
            counter_1sec <= 0;
            seconds_cnt  <= INIT_SEGUNDOS;
            minutes_cnt  <= INIT_MINUTOS;
            hours_cnt    <= INIT_HORAS;
            porciones    <= INIT_PORCIONES;
            ciclos_motor <= 10'd0;
            estado_motor <= 1'b0;

    end else begin
        if (estado_motor) begin
            if (ciclos_motor >= INIT_CICLOSM) begin
                estado_motor <= 1'b0;     // apagar motor
                ciclos_motor <= 10'd0;
            end else begin
            ciclos_motor <= ciclos_motor + 1'b1;
            end
        end 
        if (porciones == 0) begin 
            seconds_cnt <= 0; // se queda mostrando 00:00:00. (Mandar notificación por bluetooth)
            minutes_cnt <= 0;
            hours_cnt <= 0;
            counter_1sec <= 0;
        end else begin
            //Chequeo que el contador llegó a 0 sabiendo que las porciones no se han acabado    BLOQUE M
            if (seconds_cnt == 0 && minutes_cnt == 0 && hours_cnt == 0)begin
                counter_1sec <= 0;
                seconds_cnt  <= INIT_SEGUNDOS;
                minutes_cnt  <= INIT_MINUTOS;
                hours_cnt    <= INIT_HORAS;
                porciones    <= porciones - 1;
                //Mover el motor
                estado_motor <= 1; //encendido

            end else begin
                //Bloque del temporizador
                if (counter_1sec == ONE_SECOND) begin
                    counter_1sec <= 0;

                    if (seconds_cnt == 0) begin // decrementa el contador de segundos
                        seconds_cnt <= 6'd59;

                        if (minutes_cnt == 0) begin // decrementa el contador de minutos
                            minutes_cnt <= 6'd59;

                            if (hours_cnt == 0) begin // decrementa el contador de horas desde el valor programado (maximo valor: 23:59:59)
                                hours_cnt <= 6'd0;
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
// Salida real: si estado_motor=1, se conecta la secuencia; si no, envia 0.
assign M = (estado_motor) ? M_seq : INIT_MOTOR;

assign o_seconds = seconds_cnt;
assign o_minutes = minutes_cnt;
assign o_hours   = hours_cnt;

endmodule
