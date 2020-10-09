`timescale 1ns/1ps

import encoder_fec_pkg::*;

module encoder_decoder_tb;

logic clk=0;
logic rst_n=0;
logic en=0;
logic req_enc=0;
logic ack_enc, ack_dec;
encoded_message_data_t encoded_message;
message_data_t data_in;
message_data_t data_out;

message_data_t data_queue[$];

encoder enc(
	.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.req(req_enc),
	.data_in(data_in),
	.ack(ack_enc),
	.data_out(encoded_message)
);

decoder dec(
	.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.req(ack_enc),
	.data_in(encoded_message),
	.ack(ack_dec),
	.data_out(data_out)
);

always begin
	# HALF_CLK_PERIOD clk = ~clk;
end

task send_data();
	forever begin
		@(posedge clk);
		req_enc = 1;
		data_in = $urandom()%255;
		data_queue.push_front(data_in);
	end
endtask: send_data
/*
task receive_data();
	forever begin
		@(posedge clk);
		if (ack_enc) begin
			req_dec = 1;
		end else begin
			req_dec = 0;
		end
	end
endtask: receive_data
*/

task check_data();
	message_data_t expected_message;
	forever begin
		@(posedge clk);
		if (ack_dec) begin
			expected_message = data_queue.pop_back();
			assert (data_out == expected_message) else begin
				$fatal ("Missmatch decoded message expected: %0b, real: %0b", expected_message, data_out);
			end
		end
	end
endtask: check_data;

initial begin
	#20;
	rst_n = 1;
	en = 1;
	fork
		begin		//send data
			send_data();
		end
		//begin		//receive data
		//	receive_data();
		//end
		begin		//compare data
			check_data();
		end
	join_none
	#10000;
	$finish;
end

endmodule 