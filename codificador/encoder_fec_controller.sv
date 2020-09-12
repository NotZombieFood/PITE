import encoder_fec_pck::*;

module encoder_fec_controller(
    input clk,
    input rst_n,
    input en,
    input req,
    input buff_empty,
    input buff_full,
    output logic ack,
    output logic wr_en_buff,
    output logic rd_en_buff,
    output logic en_encoder,
    output logic en_modulator,
    output logic en_demodulator,
    output logic en_decoder,
    
);

end module //encoder_fec_controller