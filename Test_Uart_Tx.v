`timescale 1ns/1ps   // 50MHZ (20 ns) clk [for each 100 ps we have 20 ns (one clk cycle)] 20ns/100ps
//the simulation takes  136000 ns
module Test_Uart_Tx();
	reg 		clock, rst, send ,stop_bits, data_length;
	reg   [1:0]	baud_rate;
	reg   [7:0] data_in; 
	reg   [1:0] parity_type;
	
	wire  	data_out, p_parity_out, tx_active, tx_done;

uart_tx_top DUT1(clock, rst, send, baud_rate, data_in, parity_type, stop_bits, data_length, 
                 data_out, p_parity_out, tx_active, tx_done );      



// system clock
initial begin
    clock = 1; forever #0.5  clock = ~clock;
end

// reset system at the begining
initial begin
    rst = 1;    #2  rst = 0;
end

// the test block
initial begin
//---------------1---------------// 111111111111 (12) // 0
    send=0;
    baud_rate=2'b00;
    data_length=1;
    parity_type= 2'b01;
    stop_bits=1;
    data_in = 8'b11001100;
    #1000;       // 2604
//---------------2---------------// 11010101010 (11) // 0
    send=1;
    baud_rate=2'b00;
    data_length=1;
    parity_type= 2'b01;
    stop_bits=0;
    data_in = 8'b01010101;
    #17228;   //18228
//---------------3---------------// 11001100110 (11) // 1
    send=1;
    baud_rate=2'b00;
    data_length=1;
    parity_type= 2'b11;
    stop_bits=1;
    data_in = 8'b00110011;
    #16926;   //35154
//---------------4---------------// 11000111000 (10) //0
    send=1;
    baud_rate=2'b00;
    data_length=0;
    parity_type= 2'b01;
    stop_bits=1;
    data_in = 8'b00011100;
    #16926;   //52080
//---------------5---------------// 1100011110 (10) //1
    send=1;
    baud_rate=2'b00;
    data_length=0;
    parity_type= 2'b11;
    stop_bits=1;
    data_in = 8'b00001111;
    #15624;   //67704
//---------------6---------------// 11000001110 (11) //0
    send=1;
    baud_rate=2'b01;
    data_length=1;
    parity_type= 2'b00;
    stop_bits=1;
    data_in = 8'b00000111;
    #8463;   //76167
//---------------7---------------//110000100100  (12) //0
    send=1;
    baud_rate=2'b01;
    data_length=1;
    parity_type= 2'b10;
    stop_bits=1;
    data_in = 8'b00010010;
    #9114;   //85281
//---------------8---------------//1110011000  (10) //0
    send=1;
    baud_rate=2'b01;
    data_length=0;
    parity_type= 2'b00;
    stop_bits=1;
    data_in = 8'b11001100;
    #7812;   //93093
//---------------9---------------//11011000110  (11) //0
    send=1;
    baud_rate=2'b01;
    data_length=0;
    parity_type= 2'b10;
    stop_bits=1;
    data_in = 8'b11100011;
    #8463;   //101556
//---------------10--------------//101011000  (9) //0
    send=1;
    baud_rate=2'b01;
    data_length=0;
    parity_type= 2'b11;
    stop_bits=0;
    data_in = 8'b10101100;
    #7161;   //108717
//---------------11--------------//1110000110  (10) //0
    send=1;
    baud_rate=2'b10;
    data_length=1;
    parity_type= 2'b00;
    stop_bits=0;
    data_in = 8'b11000011;
    #3912;   //112629
//---------------12--------------//10101100100  (11) //0
    send=1;
    baud_rate=2'b10;
    data_length=1;
    parity_type= 2'b10;
    stop_bits=0;
    data_in = 8'b10110010;
    #4238;   //116867
//---------------13--------------//1101011110  (10) //0
    send=1;
    baud_rate=2'b10;
    data_length=0;
    parity_type= 2'b00;
    stop_bits=0;
    data_in = 8'b10101111;
    #3586;   //120453
//---------------14--------------//1111111110  (10) //0
    send=1;
    baud_rate=2'b10;
    data_length=0;
    parity_type= 2'b10;
    stop_bits=0;
    data_in = 8'b11111111;
    #3912;   //124365
//---------------15--------------//111000000000  (12) //0
    send=1;
    baud_rate=2'b11;
    data_length=1;
    parity_type= 2'b01;
    stop_bits=1;
    data_in = 8'b00000000;
    #2282;   //126647
//---------------16--------------//11100111000 (11) //1
    send=1;
    baud_rate=2'b11;
    data_length=1;
    parity_type= 2'b11;
    stop_bits=1;
    data_in = 8'b10011100;
    #2119;   //128766
//---------------17--------------//11010000110  (11) //0
    send=1;
    baud_rate=2'b11;
    data_length=0;
    parity_type= 2'b01;
    stop_bits=1;
    data_in = 8'b11000011;
    #2119;   //130885
//---------------18--------------//1101000110  (10) //0
    send=1;
    baud_rate=2'b11;
    data_length=0;
    parity_type= 2'b11;
    stop_bits=1;
    data_in = 8'b10100011;
    #1956;   //132841
//-----------------------------
    send=0;
    #3160;   //136000
    $stop;
end
initial begin
    	$monitor("time:%6d  data_out:%1b  p_parity_out:%1b  tx_active:%1b  tx_done:%1b ",
			    $time      ,data_out     ,p_parity_out     ,tx_active     ,tx_done    );
end
endmodule