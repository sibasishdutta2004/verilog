module axi_lite_slave (
    input wire aclk,
    input wire aresetn,
    // Write Address Channel
    input wire [31:0] awaddr,
    input wire awvalid,
    output reg awready,
    // Write Data Channel
    input wire [31:0] wdata,
    input wire [3:0] wstrb,
    input wire wvalid,
    output reg wready,
    // Write Response Channel
    output reg [1:0] bresp,
    output reg bvalid,
    input wire bready,
    // Read Address Channel
    input wire [31:0] araddr,
    input wire arvalid,
    output reg arready,
    // Read Data Channel
    output reg [31:0] rdata,
    output reg [1:0] rresp,
    output reg       rvalid,
    input wire       rready
);

reg [31:0] mem [0:255];
reg [7:0]  wr_addr;  // Latched write address
reg [7:0]  rd_addr;  // Latched read address

always @(posedge aclk) begin
    if (!aresetn) begin
        awready <= 0;
        wready  <= 0;
        bvalid  <= 0;
        arready <= 0;
        rvalid  <= 0;
    end else begin
        // Write Address Latching
        if (awvalid && !awready) begin
            awready <= 1;
            wr_addr <= awaddr[7:0];  // Latch write address
        end else begin
            awready <= 0;
        end

        // Write Data and Response
        if (wvalid && awready) begin
            wready <= 1;
            mem[wr_addr] <= wdata;  // Write to latched address
            bresp <= 2'b00;
            bvalid <= 1;
        end
        if (bvalid && bready) begin
            bvalid <= 0;
        end

        // Read Address Latching
        if (arvalid && !arready) begin
            arready <= 1;
            rd_addr <= araddr[7:0];  // Latch read address
        end else begin
            arready <= 0;
        end

        // Read Data
        if (arready) begin
            rdata <= mem[rd_addr];  // Read from latched address
            rresp <= 2'b00;
            rvalid <= 1;
        end
        if (rvalid && rready) begin
            rvalid <= 0;
        end
    end
end
endmodule