import encoder_fec_pkg::*;

module modulator(
    input clk,
    input rst_n,
    input en,
    input req,
    input encoded_message_data_t data_in,
    output logic ack,
    output modulated_message_data_t data_out
);

endmodule //modulator