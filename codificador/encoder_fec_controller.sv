import encoder_fec_pck::*;

module encoder_fec_controller(
    input clk,
    input rst_n,
    input en,
    input req,
    input buff_empty,
    input buff_full,
    input ack_encoder,
    input ack_decoder,
    input ack_modulator,
    input ack_demodulator,
    output logic req_encoder,
    output logic req_decoder,
    output logic req_modulator,
    output logic req_demodulator,
    output logic ack,
    output logic wr_en_buff,
    output logic rd_en_buff,
    output logic en_encoder,
    output logic en_modulator,
    output logic en_demodulator,
    output logic en_decoder,
    
);

end module //encoder_fec_controller