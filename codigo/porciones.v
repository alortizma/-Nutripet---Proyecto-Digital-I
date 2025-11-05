module porciones(

    //Puertos
    input clk,
    input rst_n,
    input tick_fin,
    output [2:0] porciones_f
);
// Parametro configurable de porciones
parameter [2:0] INIT_PORCIONES = 3'd6;

// Resgistro de porciones y contadores
reg [2:0] cont_porciones;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cont_porciones <= INIT_PORCIONES;
    else if (cont_porciones > 0 && tick_fin)
        cont_porciones <= cont_porciones - 1'b1;
end

assign porciones_f = cont_porciones;

endmodule