import encoder_fec_pkg::*;

module modulator(
    input clk,
    input rst_n,
    input en,
    input encoded_message_data_t data_in,
    output modulated_message_data_t data_out
);

end module //modulator