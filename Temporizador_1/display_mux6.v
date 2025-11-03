module display_mux6 (
    input clk,
    input rst_n,
    input [3:0] i_digit0,
    input [3:0] i_digit1,
    input [3:0] i_digit2,
    input [3:0] i_digit3,
    input [3:0] i_digit4,
    input [3:0] i_digit5,
    output wire [6:0] o_seg,
    output reg [5:0] o_dig
);

    reg [2:0] scan_cnt = 0;  
    reg [3:0] current_digit;
    
    // velocidad de multiplexado (~1kHz total)
    reg [15:0] div;
    always @(posedge clk or negedge rst_n)
        if(!rst_n) div <= 0;
        else       div <= div + 1;

    always @(posedge div[12] or negedge rst_n) begin
        if(!rst_n) scan_cnt <= 0;
        else       scan_cnt <= scan_cnt + 1;
    end

    always @(*) begin
        // Inicializamos todos los dígitos a '0' al principio
        o_dig = 6'b111111;  // Todos apagados al principio

        // Usamos un contador para actualizar el dígito más a la derecha (último)
        case(scan_cnt)
            0: begin o_dig[0] = 0; current_digit = i_digit0; end  // Primer dígito (más a la izquierda)
            1: begin o_dig[1] = 0; current_digit = i_digit1; end  // Segundo dígito
            2: begin o_dig[2] = 0; current_digit = i_digit2; end  // Tercer dígito
            3: begin o_dig[3] = 0; current_digit = i_digit3; end  // Cuarto dígito
            4: begin o_dig[4] = 0; current_digit = i_digit4; end  // Quinto dígito
            5: begin o_dig[5] = 0; current_digit = i_digit5; end  // Sexto dígito (más a la derecha)
            default: begin o_dig = 6'b111111; current_digit = 4'd0; end  // Fallback (reseteamos en caso de error)
        endcase
    end


    hex_7seg_decoder #(.COMMON_ANODE_CATHODE(1)) DEC (
        .in(current_digit),
        .o_a(o_seg[0]), .o_b(o_seg[1]), .o_c(o_seg[2]),
        .o_d(o_seg[3]), .o_e(o_seg[4]), .o_f(o_seg[5]),
        .o_g(o_seg[6])
    );

endmodule
