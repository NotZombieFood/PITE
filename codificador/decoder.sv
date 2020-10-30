import encoder_fec_pkg::*;

module decoder(
    input clk,
    input rst_n,
    input en,
    input req,
    input demodulated_message_data_t data_in,
    output logic ack,
    output message_data_t data_out
);

logic [15:0] corrected_message;
logic [10:0] extended_message;
logic [10:0] message;
logic [4:0] expectedP;		//Expected parity bits
logic [4:0] receivedP;		//Received parity bits
logic[3:0] ERR;
logic oneError, twoErrors;

assign message = {data_in[15:9], data_in[7:5],data_in[3]};
assign extended_message = {corrected_message[15:9],corrected_message[7:5], corrected_message[3]};

//Parity bits
assign expectedP[4] = ^{receivedP[4],message[10:4]};
assign expectedP[3] = ^{receivedP[3],message[10:7],message[3:1]};
assign expectedP[2] = ^{receivedP[2],message[10:9],message[6:5],message[3:2],message[0]};
assign expectedP[1] = ^{receivedP[1],message[10],message[8],message[6],message[4:3],message[1:0]};
assign expectedP[0] = ^data_in[15:1];
assign receivedP[4] = data_in[8];
assign receivedP[3] = data_in[4];
assign receivedP[2] = data_in[2];
assign receivedP[1] = data_in[1];
assign receivedP[0] = data_in[0];

//Detect Errors
assign ERR[3] = expectedP[4];
assign ERR[2] = expectedP[3];
assign ERR[1] = expectedP[2];
assign ERR[0] = expectedP[1];

assign oneError = (expectedP[0]!=receivedP[0]);
assign twoErrors = ((|ERR)&&(expectedP[0]==receivedP[0]));

assign corrected_message = data_in ^ (1'b1<<ERR);

always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		data_out <= 0;
		ack <= 0;
	end else if (en & req) begin
		data_out <= extended_message[7:0];
		ack <= 1;
	end else begin
		ack <= 0;
	end
end

endmodule //decoder