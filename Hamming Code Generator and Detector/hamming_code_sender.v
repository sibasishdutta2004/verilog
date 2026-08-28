module hamming_code_sender(
    input clk,
    input rst,
    input [6:0]data_in,
    output reg [11:1] send
);

    always@(posedge clk or posedge rst) begin          

        if(rst)   begin
            send[11:1]=11'bxxxxxxxxxxx;
        end
                                                //Note: Even parity is considered
        else      begin
            {send[11],send[10],send[9],send[7],send[6],send[5],send[3]}= data_in[6:0];
            send[8]=send[11]^send[10]^send[9];
            send[4]=send[5]^send[6]^send[7];
            send[2]=send[11]^send[10]^send[7]^send[6]^send[3];
            send[1]=send[11]^send[9]^send[7]^send[5]^send[3];
        end

    end

endmodule