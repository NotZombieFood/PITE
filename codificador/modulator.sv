import encoder_fec_pkg::*;

module modulator(
    input clk,
    input rst_n,
    input en,
    input req,
    input encoded_message_data_t data_in,
    output logic ack,
    output modulated_message_data_t data_out[0:3]
);

	

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			ack <= 0;
			{data_out[3], data_out[2], data_out[1], data_out[0]} <= 0;
		end else if (en & req) begin
			ack <= 1;
			{data_out[3], data_out[2], data_out[1], data_out[0]} <= data_in;
		end else begin
			ack <= 0;
		end
	end

endmodule //modulator