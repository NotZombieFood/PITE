import encoder_fec_pkg::*;

module demodulator(
    input clk,
    input rst_n,
    input en,
    input req,
    input modulated_message_data_t data_in[0:3],
    output logic ack,
    output demodulated_message_data_t data_out
);

	

	always_ff @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			ack <= 0;
			data_out <= 0;
		end else if (req & en) begin
			ack <= 1;
			data_out <= {data_in[3], data_in[2], data_in[1], data_in[0]};
		end else begin
			ack <= 0;
		end
	end


endmodule //demodulator