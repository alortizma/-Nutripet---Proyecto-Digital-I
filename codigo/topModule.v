module topModule(
    input clk,
    input rst_n,
    output [5:0] segundos,
    output [5:0] minutos,
    output [6:0] horas,
    output [2:0] porciones_f,
    output [3:0] M
);

parameter [9:0] INIT_CICLOSM = 10'd683;
parameter [3:0] INIT_MOTOR   = 4'b0000;

reg fin_anterior;
wire fin_actual;
wire tick_fin;
wire [3:0] M_seq;
reg [9:0] ciclos_motor;
reg motor_activo;

// Instancia del temporizador
timer_2 temporizador(
    .clk(clk),
    .rst_n(rst_n),
    .o_seconds(segundos),
    .o_minutes(minutos),
    .o_hours(horas)
);

// Detección del final del tiempo 
assign fin_actual = (segundos == 0 && minutos == 0 && horas == 0);

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        fin_anterior <= 1'b0;
    else
        fin_anterior <= fin_actual;

assign tick_fin = fin_actual & ~fin_anterior;

// Instancia del contador de porciones
porciones num_porciones(
    .clk(clk),
    .rst_n(rst_n),
    .tick_fin(tick_fin),
    .porciones_f(porciones_f)
);

// Instancia del motor 
motor motor_inst(.clk(clk), .M(M_seq));

// Control del motor
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        motor_activo <= 1'b0;
        ciclos_motor <= 10'd0;
    end else if (tick_fin) begin
        motor_activo <= 1'b1;
        ciclos_motor <= 10'd0;
    end else if (motor_activo) begin
        if (ciclos_motor < INIT_CICLOSM)
            ciclos_motor <= ciclos_motor + 1'b1;
        else
            motor_activo <= 1'b0;
    end
end

assign M = (motor_activo) ? M_seq : INIT_MOTOR;

endmodule
