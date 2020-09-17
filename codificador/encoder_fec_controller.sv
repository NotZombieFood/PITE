import encoder_fec_pkg::*;

module encoder_fec_controller(
    input clk,
    input rst_n,
    input en,
    input req,
    input buff_empty_encoder,
    input buff_empty_decoder,
    input buff_full_encoder,
    input buff_full_decoder,
    input buff_rd_valid_encoder,
    input buff_rd_valid_decoder,
    input ack_encoder,
    input ack_decoder,
    input ack_modulator,
    input ack_demodulator,
	 input buff_rd_valid,
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
	 output logic rd_en_buff_decoder,
	 output logic rd_en_buff_encoder,
	 output logic wr_en_buff_decoder,
	 output logic wr_en_buff_encoder
    
);

endmodule //encoder_fec_controller