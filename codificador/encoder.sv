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


endmodule //encoder