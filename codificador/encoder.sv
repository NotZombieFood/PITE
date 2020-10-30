import encoder_fec_pkg::*;

module encoder(
    input clk,
    input rst_n,
    input en,
    input req,
    input message_data_t data_in,
    output logic ack,
    output encoded_message_data_t data_out
);

logic [10:0] extended_data;
logic [4:0] p_bit;		//Parity bits

assign extended_data = {3'b0,data_in};
//Parity bits
assign p_bit[0] = ^{extended_data[10:0],p_bit[4:1]};
assign p_bit[1] = ^{extended_data[10],extended_data[8],extended_data[6],extended_data[4:3],extended_data[1:0]};
assign p_bit[2] = ^{extended_data[10:9], extended_data[6:5], extended_data[3:2], extended_data[0]};
assign p_bit[3] = ^{extended_data[10:7], extended_data[3:1]};
assign p_bit[4] = ^extended_data[10:4];

always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		data_out <= 0;
		ack <= 0;
	end else if (en & req) begin
		data_out <= {extended_data[10:4],p_bit[4],extended_data[3:1],p_bit[3],extended_data[0],p_bit[2:0]};
		ack <= 1;
	end else begin
		//data_out <= 0;
		ack <= 0;
	end
end


endmodule //encoder