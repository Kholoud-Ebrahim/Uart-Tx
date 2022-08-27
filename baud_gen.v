module baud_gen(clock, baud_rate, baud_out); 
    input clock;
    input [1:0]	baud_rate;
    output reg  baud_out;

    reg [11:0]counter_stop;
    reg [11:0]counter=0;

always @(posedge clock) begin
    if (counter >= counter_stop)
        counter <= 12'b0;
	else
	    counter <= counter +1;
	
    if(counter <= (counter_stop)/2)
        baud_out <= 1'b1;
    else
        baud_out <= 1'b0;
end
always @(*) begin
    case (baud_rate)
        2'b00:	// 2400 baud     // counter_stop=(50*10^6)/(16*baud rate)-1
            counter_stop = 1301;							
        2'b01:	// 4800 baud
            counter_stop = 650;	
        2'b10:	// 9600 baud									
            counter_stop = 325;	
        2'b11:	//19200 baud
            counter_stop =	162;
        default:
            counter_stop = 12'bx;
    endcase
end
endmodule
