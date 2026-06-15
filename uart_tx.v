module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] data,

    output reg        tx,
    output reg        tx_done
);

    // Definición de estados
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] current_state;

    // Registro para almacenar el dato
    reg [7:0] data_reg;

    // Contador de bits
    reg [2:0] bit_count;

    // FSM principal
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            current_state <= IDLE;
            data_reg      <= 8'b0;
            bit_count     <= 3'b0;
            tx            <= 1'b1;
            tx_done       <= 1'b0;

        end else begin

            // Valor por defecto
            tx_done <= 1'b0;

            case (current_state)

                IDLE: begin
                    tx <= 1'b1;

                    if (tx_start) begin
                        data_reg      <= data;
                        bit_count     <= 3'b0;
                        current_state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    current_state <= DATA;
                end

                DATA: begin
                    tx <= data_reg[bit_count];

                    if (bit_count == 3'd7) begin
                        current_state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    tx_done <= 1'b1;
                    current_state <= IDLE;
                end

                default: begin
                    current_state <= IDLE;
                end

            endcase

        end

    end

endmodule