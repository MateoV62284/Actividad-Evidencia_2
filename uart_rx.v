module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,

    output reg [7:0] data_out,
    output reg       rx_done
);

    // Estados de la FSM
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] current_state;

    // Registro para almacenar el dato recibido
    reg [7:0] data_reg;

    // Contador de bits
    reg [2:0] bit_count;

    // FSM principal
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            current_state <= IDLE;
            data_reg      <= 8'b0;
            bit_count     <= 3'b0;

            data_out      <= 8'b0;
            rx_done       <= 1'b0;

        end else begin

            rx_done <= 1'b0;

            case (current_state)

                // Espera de una transmisión
                IDLE: begin
                    if (rx == 1'b0)
                        current_state <= START;
                end

                // Confirmación del bit de inicio
                START: begin
                    bit_count <= 3'b0;
                    current_state <= DATA;
                end

                // Recepción de datos
                DATA: begin

                    data_reg[bit_count] <= rx;

                    if (bit_count == 3'd7)
                        current_state <= STOP;
                    else
                        bit_count <= bit_count + 1'b1;

                end

                // Verificación del bit de parada
                STOP: begin

                    if (rx == 1'b1) begin
                        data_out <= data_reg;
                        rx_done  <= 1'b1;
                    end

                    current_state <= IDLE;

                end

                default: begin
                    current_state <= IDLE;
                end

            endcase

        end

    end

endmodule