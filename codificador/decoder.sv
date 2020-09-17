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


endmodule //decoder