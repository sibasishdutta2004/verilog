`timescale 1ns/1ps

`include"AXI_lite_slave.v"

module tb_axi_lite;
    reg aclk;
    reg aresetn;
    reg [31:0] awaddr;
    reg awvalid;
    wire awready;
    reg [31:0] wdata;
    reg [3:0] wstrb;
    reg wvalid;
    wire wready;
    wire [1:0] bresp;
    wire bvalid;
    reg bready;
    reg [31:0] araddr;
    reg arvalid;
    wire arready;
    wire [31:0] rdata;
    wire [1:0] rresp;
    wire rvalid;
    reg rready;

    axi_lite_slave uut (
        .aclk(aclk), .aresetn(aresetn),
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready),
        .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready),
        .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready)
    );

    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

    initial begin
        // VCD file generation
        $dumpfile("AXI_lite_slave.vcd");
        $dumpvars(0, tb_axi_lite);

        $display("Starting AXI Lite transactions...");

        araddr = 32'h04;
        awaddr  = 32'h04;
        wdata   = 32'h100;
        aresetn = 0;
        arvalid = 0;
        rready  = 0;
        awvalid = 0;
        wvalid  = 0;
        bready  = 0;

        #10 aresetn = 1;

        // Multiple Write Transactions
        repeat (3) begin
            @(posedge aclk);
            awaddr  = awaddr + 32'h04;
            awvalid = 1;
            wdata   = wdata + 32'h100;
            wstrb   = 4'b1111;
            wvalid = 1;
            bready = 1;

            $display("Write Transaction: Addr = %h, Data = %h", awaddr, wdata);
            @(posedge aclk);
            //  @(posedge aclk);
            awvalid = 0;
            wvalid = 0;
            bready = 0;
            awvalid = 0;
            wvalid = 0;
            bready = 0;
        end

        // Multiple Read Transactions
        repeat (3) begin
            @(posedge aclk);
            araddr = araddr + 32'h04;
            arvalid = 1;
            rready = 1;
            @(posedge aclk);
            @(negedge aclk);
            $display("Read Transaction: Addr = %h, Data = %h", araddr, rdata);

            arvalid = 0;
            rready = 0;
        end

        #50 $finish;
    end
endmodule