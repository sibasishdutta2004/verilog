`timescale 1ns/1ns

`include "hamming_code_sender.v"
`include "hamming_code_reciever.v"

module hamming_code_tb;
    reg clk;
    reg rst;
    reg [6:0]data_in;
    wire [11:1]send;             //Note: It is wire cuz every output from every module(verilog file) must be of wire and not reg type
    reg [11:1]channel;           
    reg [11:1]recieved;
    wire[6:0]data_out;

    hamming_code_sender sut(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .send(send)
    );

    hamming_code_reciever rut(
        .clk(clk),
        .rst(rst),
        .data_out(data_out),
        .recieved(recieved)
    );

    initial
        begin
            {clk,rst,data_in}=0;   
        end

    always #5 clk=~clk;

    initial                            //Using GTKWave
        begin
            $dumpfile("hamming_code.vcd");
            $dumpvars(0,hamming_code_tb);
            #100;
            $finish;
        end

    initial
        begin
            data_in =$random;         //Random 7 bit binary number
            #10;
            channel=send;
            #10;
            recieved=channel^ 11'b00000100000;

            #30;

            data_in =$random;         //Random 7 bit binary number
            #10;
            channel=send;
            #10;
            recieved=channel;
        end

endmodule