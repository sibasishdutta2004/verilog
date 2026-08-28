
`include "RAM_8x8.v"

module tb_ram8x8_controller;
    reg clk;
    reg we;
    reg [2:0] addr;
    reg [7:0] din;
    wire [7:0] dout;
    ram8x8_controller UUT (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );
    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        
        $dumpfile("RAM_8x8.vcd");    
        $dumpvars(0, tb_ram8x8_controller);  

        we = 0; addr = 3'b000; din = 8'h00;
        
        #10 we = 1; addr = 3'b000; din = 8'hAA; // Write 0xAA to address 0
        #10 addr = 3'b001; din = 8'h55;         // Write 0x55 to address 1
        #10 addr = 3'b010; din = 8'hFF;         // Write 0xFF to address 2
        #10 we = 0;
        
        #10 addr = 3'b000; 
        #20 addr = 3'b001; 
        #20 addr = 3'b010;
        #20;
        $finish; 
    end
endmodule