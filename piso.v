module piso(rst, frame_out, parity_type, stop_bits, data_length, send, 
             baud_out, data_out, p_parity_out, tx_active, tx_done);
			 
    input baud_out, rst, send, stop_bits, data_length;
    input [11:0] frame_out;
    input [1:0] parity_type;
    output reg 	data_out; 		//Serial data_out.
    output reg 	p_parity_out; 	//parallel odd parity out,[0] frame parity.
    output reg 	tx_active; 		//[1]:transmitting, [0]:idle.
    output reg 	tx_done ;		//[1]: done, [0] not.

reg [1:0]state ;
reg p_parallel_odd;
reg [3:0] ones_sum;
reg [7:0]data_only;
integer Bit_Index, MSB , ii;
parameter s_idle    = 2'b00,
          s_TX_start= 2'b01,
          s_TX_data = 2'b10;

always @(posedge baud_out, posedge rst) begin
  if(rst)begin
    state        <= s_idle; 
    data_out     <= 1'b1; 
	p_parity_out <= 1'b0;
    tx_active    <= 1'b0;
    tx_done      <= 1'b0;
	Bit_Index    <= 1;
  end
  
  else begin 
	case (state)
    // Idle
        s_idle: begin
            data_out    <= 1'b1;  // Drive Line High for Idle.
            tx_active   <= 1'b0;
            tx_done     <= 1'b0;
			Bit_Index   <= 1;
			p_parity_out<= 1'b0;

            if (send && (frame_out[0]==0))
                state   <= s_TX_start;
            else
                state   <= s_idle;	
        end
		
	//-----------------------------------------------------------------
    // Send out Start Bit. Start bit = frame_out[0] = 0
        s_TX_start: begin  
            tx_active    <= 1'b1;
            tx_done      <= 1'b0;
			Bit_Index    <= 1;
			p_parity_out <= p_parallel_odd; 
            data_out     <= frame_out[0];
			if (send)
                state    <= s_TX_data;
            else
                state    <= s_idle;
        end
		
	//-----------------------------------------------------------------
    // send the data, parity, only one stop bit if we have 2 
    //                        no stop bit if we have 1
        s_TX_data: begin 
		  if (send) begin
            if(data_length) begin //[8 bit data] 
                if(parity_type==2'b01 || parity_type==2'b10) begin //parity_out bit exist
                    if(stop_bits) begin //2 stop signals [2'b11]
                        // overall 12 bit 
						if (Bit_Index<= 11) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;  
                            p_parity_out<= 1'b0;  
                        end	
					end
					
					else begin//1 stop signal [1'b1]
                        // overall 11 bit 
                        if (Bit_Index  <= 10) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;    
                            p_parity_out<= 1'b0;
                        end	
                    end
                end

				else begin //parity_out bit not exist
                    if(stop_bits) begin  //2 stop signals [2'b11]
                        // overall 11 bit 
                        if (Bit_Index  <= 10) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;
                            p_parity_out <= p_parallel_odd;	
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;   
                            p_parity_out<= 1'b0; 
                        end	
                    end
                    else begin//1 stop signal [1'b1]
                        // overall 10 bit 
                        if (Bit_Index  <= 9) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;
                            p_parity_out <= p_parallel_odd;	
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1; 
                            p_parity_out<= 1'b0;   
                        end	
                    end
                end  			
			end
			
			else begin //[7 bit data]           
				if(parity_type==2'b01 || parity_type==2'b10) begin //parity_out bit exist
                    if(stop_bits) begin //2 stop signals [2'b11]
                        // overall 11 bit 
						if (Bit_Index  <= 10) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;    
                            p_parity_out<= 1'b0;
                        end	
					end
					
					else begin//1 stop signal [1'b1]
                        // overall 10 bit 
                        if (Bit_Index  <= 9) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;    
                            p_parity_out<= 1'b0;
                        end	
                    end
                end
				else begin //parity_out bit not exist
                    if(stop_bits) begin  //2 stop signals [2'b11]
                        // overall 10 bit 
                        if (Bit_Index  <= 9) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;  
                            p_parity_out<= 1'b0;  
                        end	
                    end
                    else begin//1 stop signal [1'b1]
                        // overall 9 bit 
                        if (Bit_Index  <= 8) begin
                            tx_active  <= 1'b1;
                            tx_done    <= 1'b0;
							data_out   <= frame_out[Bit_Index];
							state      <= s_TX_data;
							Bit_Index  <= Bit_Index+1;	
                            p_parity_out <= p_parallel_odd;
						end
						else begin 
                            tx_active  <= 1'b0;
                            tx_done    <= 1'b1;
                            data_out   <= 1'b1;
                            state      <= s_idle;
                            Bit_Index  <= 1;  
                            p_parity_out<= 1'b0;  
                        end	
                    end
                end  			
			end		
          end

		  else state  <= s_idle;  
        end
    //-----------------------------------------------------------------	
	// default state	
        default:begin
            data_out     <= 1'b1;  // Drive Line High for Idle.
            tx_active    <= 1'b0;
			tx_done      <= 1'b0;
			p_parity_out <= 1'b0;
			state        <= s_idle;
        end

    endcase
  end
end

always @(*) begin 
    data_only = frame_out[8:1];
    if(data_length) begin  MSB = 7;  ones_sum =4'b0000;  end
    else            begin  MSB = 6;  ones_sum =4'b0000;  end
  
    if(rst) begin
        p_parallel_odd = 1'b0;
        ii=0;
    end
    else begin
        case(parity_type) //[8 bit data] 
        2'b11: begin
		    for(ii=0; ii<= MSB; ii=ii+1)
		    begin
			    if (data_only[ii])
				    ones_sum = ones_sum +1;
		    end
		    if (ones_sum & 4'b0001)
			    p_parallel_odd =1'b0;
		    else
			    p_parallel_odd =1'b1;
		end
		
	    default:
		    p_parallel_odd = 1'b0;
        endcase
    end
end
endmodule