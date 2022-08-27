module frame_gen(rst, data_in, parity_type, parity_out, stop_bits, data_length, frame_out);
  input  rst, parity_out, data_length, stop_bits;
  input [7:0]data_in;
  input [1:0]parity_type;
  output reg [11:0]frame_out;

always@(*) begin
frame_out = 12'b111111111111;
if(rst)
    frame_out = 12'b111111111111;
else begin
    if(data_length) //data_length==1 [8 bit data] 
    begin
        if(parity_type==2'b01 || parity_type==2'b10)  //there is parity_out
        begin
            if(stop_bits)//stop_bits==1 , we have 2 stop signals [2'b11]
                frame_out ={2'b11,parity_out,data_in[7:0],1'b0};  // 12

            else if(!stop_bits) //stop_bits==0 , we have 1 stop signals [1'b1]
                frame_out ={1'b1,1'b1,parity_out,data_in[7:0],1'b0}; //11
        end

        else if (parity_type==2'b00 || parity_type==2'b11) //there is no parity_out here
        begin
            if(stop_bits)//stop_bits==1 , we have 2 stop signals [2'b11]
                frame_out ={1'b1,2'b11,data_in[7:0],1'b0}; //11

            else if(!stop_bits)//stop_bits==0 , we have 1 stop signals [1'b1]
                frame_out ={2'b11,1'b1,data_in[7:0],1'b0}; //10
        end
    end

    else if(!data_length)//data_length==0 [7 bit data]
    begin
        if(parity_type==2'b01 || parity_type==2'b10) //there is parity_out
        begin
            if(stop_bits)//stop_bits==1 , we have 2 stop signals [2'b11]
                frame_out ={1'b1,2'b11,parity_out,data_in[6:0],1'b0}; //11

            else if(!stop_bits)//stop_bits==0 , we have 1 stop signals [1'b1]
                frame_out ={2'b11,1'b1,parity_out,data_in[6:0],1'b0}; //10
        end
        
        else if (parity_type==2'b00 || parity_type==2'b11) //there is no parity_out here
        begin
            if(stop_bits)//stop_bits==1 , we have 2 stop signals [2'b11]
                frame_out ={2'b11,2'b11,data_in[6:0],1'b0}; //10

            else if(!stop_bits)//stop_bits==0 , we have 1 stop signals [1'b1]
                frame_out ={3'b111,1'b1,data_in[6:0],1'b0}; //9
        end
    end
end
end
endmodule