import encoder_fec_pkg::*;

module demodulator(
    input clk,
    input rst_n,
    input en,
    input modulated_message_data_t data_in,
    output demodulated_message_data_t data_out
);

end module //demodulator