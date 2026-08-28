
module decoder3to8 (
    input [2:0] addr,
    output reg [7:0] dec_out
);
    always @(*) begin
        dec_out = 8'b0;
        dec_out[addr] = 1'b1;  
    end
endmodule
module ram8x8_controller (
    input clk,
    input we,             
    input [2:0] addr,      
    input [7:0] din,       
    output reg [7:0] dout  
);
    reg [7:0] ram [7:0];   
    wire [7:0] select;
   
    decoder3to8 dec(.addr(addr), .dec_out(select));
    integer i;
    always @(posedge clk) begin
        if (we) begin
            
            for (i = 0; i < 8; i = i + 1) begin
                if (select[i])
                    ram[i] <= din;
            end
        end
        
        dout <= ram[addr];
    end
endmodule