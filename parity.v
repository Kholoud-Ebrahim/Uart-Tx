module parity(rst, data_in, data_length, parity_type, parity_out);
  input [7:0]data_in;
  input rst, data_length;
  input [1:0]parity_type;
  output reg parity_out;
integer MSB , ii;
reg [3:0] ones_sum;

always @(*) begin 
  if(data_length) begin  
    MSB = 7;
    ones_sum =4'b0000;
  end
  else begin
    MSB = 6;
    ones_sum =4'b0000;
  end
  
  if(rst)
    parity_out = 1'b0;
  else begin
    case(parity_type) //[8 bit data] 
    2'b01: 
		begin
		for(ii=0; ii<= MSB; ii=ii+1)
		begin
			if (data_in[ii])
				ones_sum = ones_sum +1;
		end
		if (ones_sum & 4'b0001)
			parity_out =1'b0;
		else
			parity_out =1'b1;
		end
		
	  2'b10:
		begin
		for(ii=0; ii<= MSB ;ii=ii+1)
		begin
			if (data_in[ii])
				ones_sum = ones_sum +1;
		end
		if (!(ones_sum & 4'b0001))
			parity_out  = 1'b0;
		else
			parity_out  = 1'b1;
		end

	default:
		parity_out = 1'b0;
    endcase
  end

end
endmodule