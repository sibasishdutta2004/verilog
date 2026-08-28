module hamming_code_reciever(
    input clk,
    input rst,
    input [11:1]recieved,
    output reg [6:0] data_out
);

    reg [3:0]parity;
    reg [11:1]c_recieved;                      //Look for a better case where we dont need this register cuz its inefficient

    always@(posedge clk or posedge rst) begin

        if(rst)   begin
            data_out[6:0]=7'bxxxxxxx; 
        end
        
        else      begin
            parity[3]= recieved[11]^recieved[10]^recieved[9]^recieved[8];
            parity[2]= recieved[7]^recieved[6]^recieved[5]^recieved[4];
            parity[1]= recieved[11]^recieved[10]^recieved[7]^recieved[6]^recieved[3]^recieved[2];
            parity[0]= recieved[11]^recieved[9]^recieved[7]^recieved[5]^recieved[3]^recieved[1];

            if(parity==4'b0000)    begin
                data_out[6:0]={recieved[11],recieved[10],recieved[9],recieved[7],recieved[6],recieved[5],recieved[3]};
            end

            else     begin
                c_recieved=recieved;
                c_recieved[parity]=~recieved[parity];
                data_out[6:0]={c_recieved[11],c_recieved[10],c_recieved[9],c_recieved[7],c_recieved[6],c_recieved[5],c_recieved[3]};
            end

        end

    end
endmodule