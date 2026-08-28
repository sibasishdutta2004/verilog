`timescale 1ns/1ns

`include "Elevator_Controller.v"

module elevator_controller_tb;

reg clk;
reg rst;
reg[3:0]floor_req;
reg emergency_stop;

wire move_u;
wire move_d;
wire motor_stop;
wire[1:0]current_floor;

elevator_controller dut(clk,rst,floor_req,emergency_stop,move_u,move_d,motor_stop,current_floor);

always#5 clk =~clk;

initial                            //Using GTKWave
        begin
            $dumpfile("Elevator_Controller.vcd");
            $dumpvars(0,elevator_controller_tb);
            #200;
            $finish;
        end

//Test sequence
initial begin
    clk=0;
    rst=1;
    floor_req=4'b0000;
    emergency_stop=0;

    #20 rst=0;

    #10 floor_req=4'b0100;

    #20 floor_req=4'b0010;

    #20 floor_req=4'b1000;

    #20 floor_req=4'b1010; //Two buttons at same time

    #20 emergency_stop=1;

    #10 emergency_stop=0;

    #20 floor_req=4'b0001;

end
endmodule