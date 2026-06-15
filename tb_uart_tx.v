`timescale 1ns/1ps

module tb_uart_tx;

    // Señales de prueba
    reg clk = 0;
    reg rst = 0;
    reg tx_start = 0;
    reg [7:0] data = 8'h00;

    wire tx;
    wire tx_done;

    // Periodo de reloj
    localparam CLK_PERIOD = 10;

    // Instancia del DUT
    uart_tx DUT (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data(data),
        .tx(tx),
        .tx_done(tx_done)
    );

    // Generador de reloj
    always #(CLK_PERIOD/2) clk = ~clk;

    // Estímulos
    initial begin
        // Configuración para generar las ondas
        $dumpfile("tb_uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        // RESET
        $display("Aplicando reset...");
        rst = 1'b1;
        #30;
        rst = 1'b0;
        #20;

        // PRIMERA TRANSMISION
        $display("Transmitiendo dato xAA");
        data = 8'hAA;
        tx_start = 1'b1;
        #CLK_PERIOD;
        tx_start = 1'b0;

        // Esperar fin de transmisión
        @(posedge tx_done);
        $display("Transmision 1 completada");
        #50;

        // SEGUNDA TRANSMISION
        $display("Transmitiendo dato x55");
        data = 8'h55;
        tx_start = 1'b1;
        #CLK_PERIOD;
        tx_start = 1'b0;

        @(posedge tx_done);
        $display("Transmision 2 completada");
        #50;

        // TERCERA TRANSMISION
        $display("Transmitiendo dato xF0");
        data = 8'hF0;
        tx_start = 1'b1;
        #CLK_PERIOD;
        tx_start = 1'b0;

        @(posedge tx_done);
        $display("Transmision 3 completada");
        #50;

        $display("SIMULACION FINALIZADA");
        $finish;
    end

endmodule