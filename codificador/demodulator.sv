import encoder_fec_pkg::*;

module demodulator(
    input clk,
    input rst_n,
    input en,
    input req,
    input modulated_message_data_t data_in,
    output logic ack,
    output demodulated_message_data_t data_out
);

end module //demodulator