module elevator_controller(
    input clk,
    input rst,
    input [3:0]floor_req,
    input emergency_stop,                      //Synchronous emergency stop
    output reg move_u,
    output reg move_d,
    output reg motor_stop,
    output reg [1:0]current_floor
);

parameter idle=2'b00,move_up=2'b01,move_down=2'b10,emergency=2'b11;

reg[1:0]current_state,next_state;

reg[1:0]target_floor;

//priority logic                               //floor_req[3:0]--->target_floor[1:0] using decoder logic
always@(*)begin
    target_floor=current_floor;                //Two buttons at same time suppose 1 & 3,then 1 is gonna have priority 
    if(floor_req[0])
        target_floor=2'd0;
    else if(floor_req[1])
        target_floor=2'd1;
    else if(floor_req[2])
        target_floor=2'd2;
    else if(floor_req[3])
        target_floor=2'd3;
end

//present state logic
always@(posedge clk)begin
    if(rst)
        current_state<=idle;
    else
        current_state<=next_state;
end

//floor tracking logic
always @(posedge clk) begin
    if (rst)
        current_floor <= 2'd0;
    else begin
        if (current_state == move_up && current_floor < 2'd3)
            current_floor <= current_floor + 1'b1;
        else if (current_state == move_down && current_floor > 2'd0)
            current_floor <= current_floor - 1'b1;
    end
end

//next state logic
always@(*)begin 
    next_state=current_state;

    if(emergency_stop)
        next_state=emergency;
    else begin

        case(current_state)
            idle:
                if(target_floor>current_floor)
                    next_state=move_up;
                else if(target_floor<current_floor)
                    next_state=move_down;

            move_up:
                if(target_floor == current_floor)
                    next_state = idle;
                else if(target_floor < current_floor)
                    next_state = move_down;
                else
                    next_state = move_up;

            move_down:
                if(target_floor == current_floor)
                    next_state = idle;
                else if(target_floor > current_floor)
                    next_state = move_up;
                else
                    next_state = move_down;

            emergency:
                if(emergency_stop)
                    next_state=emergency;
                else
                    next_state=idle;
        endcase   
    end
end

//output logic
always@(*)begin 
    move_u=1'b0;
    move_d=1'b0;
    motor_stop=1'b0;

    case(current_state)
        move_up:
            move_u=1'b1;
        move_down:
            move_d=1'b1;
        emergency:
            motor_stop=1'b1;
        idle:
            motor_stop=1'b1;
    endcase
end
endmodule