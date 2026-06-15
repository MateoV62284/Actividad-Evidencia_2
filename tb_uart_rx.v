`timescale 1ns/1ps

module tb_uart_rx;

    reg clk = 0;
    reg rst = 0;
    reg rx  = 1;

    wire [7:0] data_out;
    wire rx_done;

    localparam CLK_PERIOD = 10;

    // DUT
    uart_rx DUT (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    // Generador de reloj
    always #(CLK_PERIOD/2) clk = ~clk;

    // Estímulos
    initial begin
        // Configuración para generar las ondas
        $dumpfile("tb_uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        // RESET
        rst = 1'b1;
        #30;

        rst = 1'b0;
        #30;

        // Recepción de xAA
        $display("Enviando trama xAA");

        rx = 1'b0; #CLK_PERIOD; // START

        rx = 1'b0; #CLK_PERIOD; // bit0
        rx = 1'b1; #CLK_PERIOD; // bit1
        rx = 1'b0; #CLK_PERIOD; // bit2
        rx = 1'b1; #CLK_PERIOD; // bit3
        rx = 1'b0; #CLK_PERIOD; // bit4
        rx = 1'b1; #CLK_PERIOD; // bit5
        rx = 1'b0; #CLK_PERIOD; // bit6
        rx = 1'b1; #CLK_PERIOD; // bit7

        rx = 1'b1; #CLK_PERIOD; // STOP

        @(posedge rx_done);

        $display("Byte recibido correctamente");
        $display("Dato recibido = %h", data_out);

        #50;

        // Recepción de x55
        $display("Enviando trama x55");

        rx = 1'b0; #CLK_PERIOD; // START

        rx = 1'b1; #CLK_PERIOD; // bit0
        rx = 1'b0; #CLK_PERIOD; // bit1
        rx = 1'b1; #CLK_PERIOD; // bit2
        rx = 1'b0; #CLK_PERIOD; // bit3
        rx = 1'b1; #CLK_PERIOD; // bit4
        rx = 1'b0; #CLK_PERIOD; // bit5
        rx = 1'b1; #CLK_PERIOD; // bit6
        rx = 1'b0; #CLK_PERIOD; // bit7

        rx = 1'b1; #CLK_PERIOD; // STOP

        @(posedge rx_done);

        $display("Segunda recepción completada");
        $display("Dato recibido = %h", data_out);

        #50;

        $display("SIMULACION FINALIZADA");

        $finish;

    end

endmodule