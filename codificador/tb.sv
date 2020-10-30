`timescale 1ns/1ps

import encoder_fec_pkg::*;

module tb;

parameter shift_1_bit = 1;
parameter prob_1_shift = 5;
parameter shift_2_bits = 0;
parameter prob_2_shift = 0;

logic clk=0;
logic rst_n=0;
logic en=0;
logic req=0;
logic ack;
message_data_t data_in;
message_data_t data_out;

message_data_t data_queue[$];

encoder_fec dut(
	.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.req(req),
	.data_in(data_in),
	.ack(ack),
	.data_out(data_out)
);


always begin
	# HALF_CLK_PERIOD clk = ~clk;
end

task send_data();
	forever begin
		@(posedge clk);
		req = 1;
		data_in = $urandom()%255;
		data_queue.push_front(data_in);
	end
endtask: send_data


task check_data();
	message_data_t expected_message;
	forever begin
		@(posedge clk);
		if (ack) begin
			expected_message = data_queue.pop_back();
			assert (data_out == expected_message) else begin
				$fatal ("Missmatch decoded message expected: %0b, real: %0b", expected_message, data_out);
			end
		end
	end
endtask: check_data;

task shift_bit;
	int shift;
	int bit_shift;
	logic [15:0] shifter;
	
	forever begin
		@(negedge clk);
		shifter = 0;
		if (shift_1_bit) begin
			shift=$urandom()%100;
			if (shift<prob_1_shift) begin
				bit_shift=$urandom()%16;
				shifter[bit_shift] = 1;
				
				/*
				if (shift_2_bits) begin
					shift=$urandom()%100;
					if (shift<prob_2_shift) begin
						bit_shift=$urandom()%16;
						shifter[bit_shift] = 1;
					end
				end
				*/
				
				force dut.modulated_message[3] = dut.modulated_message[3]^shifter[15:12];
				force dut.modulated_message[2] = dut.modulated_message[2]^shifter[11:8];
				force dut.modulated_message[1] = dut.modulated_message[1]^shifter[7:4];
				force dut.modulated_message[0] = dut.modulated_message[0]^shifter[3:0];
			end
		end
		@(posedge clk);
		#5;
		release dut.modulated_message;
	end

endtask: shift_bit

initial begin
	#20;
	rst_n = 1;
	en = 1;
	fork
		begin		//send data
			send_data();
		end
	begin		//receive data
		shift_bit();
	end
		begin		//compare data
			check_data();
		end
	join_none
	#500000;
	$finish;
end

endmodule 