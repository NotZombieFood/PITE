//Encoder Fec Top module

import encoder_fec_pkg::*;

module encoder_fec(
    input clk,
    input rst_n,
    input en,
    input req,
    message_data_t data_in,      //data sensed by ADC
    output logic ack,
    message_data_t data_out     //Data sent to DAC
);

//Control signals
logic en_encoder;
logic en_decoder;
logic en_modulator;
logic en_demodulator;
logic req_encoder;
logic req_decoder;
logic req_modulator;
logic req_demodulator;
logic ack_encoder;
logic ack_decoder;
logic ack_modulator;
logic ack_demodulator;
logic buff_empty_encoder;
logic buff_empty_decoder;
logic buff_full_encoder;
logic buff_full_decoder;
logic buff_rd_valid_encoder;
logic buff_rd_valid_decoder;
logic wr_en_buff_encoder;
logic wr_en_buff_decoder;
logic rd_en_buff_encoder;
logic rd_en_buff_decoder;
//Data Signals
message_data_t                  message_buff_2_encoder;
encoded_message_data_t          encoded_message;
modulated_message_data_t        modulated_message;
demodulated_message_data_t      demodulated_message;
message_data_t                  decoded_message;

encoder_fec_controller controller(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .req(req),
    .ack(ack),
    .ack_encoder(ack_encoder),
    .ack_decoder(ack_decoder),
    .ack_modulator(ack_modulator),
    .ack_demodulator(ack_demodulator),
    .req_encoder(req_encoder),
    .req_decoder(req_decoder),
    .req_modulator(req_modulator),
    .req_demodulator(req_demodulator),
    .buff_empty_encoder(buff_empty_encoder),
    .buff_empty_decoder(buff_empty_decoder),
    .buff_full_encoder(buff_full_encoder),
    .buff_full_decoder(buff_full_decoder),
    .wr_en_buff_encoder(wr_en_buff_encoder),
    .wr_en_buff_decoder(wr_en_buff_decoder),
    .rd_en_buff_encoder(rd_en_buff_encoder),
    .rd_en_buff_decoder(rd_en_buff_decoder),
    .buff_rd_valid(buff_rd_valid),
    .en_encoder(en_encoder),
    .en_modulator(en_modulator),
    .en_demodulator(en_demodulator),
    .en_decoder(en_decoder)
);

circular_buffer buff_encoder(          //Buffer before encoder
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_buff_encoder),
    .rd_en(rd_en_buff_encoder),
    .data_in(data_in),
    .data_out(message_buff_2_encoder),
    .empty(buff_empty_encoder),
    .full(buff_full_encoder),
    .rd_valid(buff_rd_valid_encoder)
);

circular_buffer buff_decoder(          //Buffer after decoder
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_buff_decoder),
    .rd_en(rd_en_buff_decoder),
    .data_in(decoded_message),
    .data_out(data_out),
    .empty(buff_empty_decoder),
    .full(buff_full_decoder),
    .rd_valid(buff_rd_valid_decoder)
);

encoder encoder1(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_encoder),
    .req(req_encoder),
    .data_in(message_buff_2_encoder),
    .ack(ack_encoder),
    .data_out(encoded_message)
);

modulator modulator1(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_modulator),
    .req(req_modulator),
    .data_in(encoded_message),
    .ack(ack_modulator),
    .data_out(modulated_message)
);

demodulator demodulator1(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_demodulator),
    .req(req_demodulator),
    .data_in(modulated_message),
    .ack(ack_demodulator),
    .data_out(demodulated_message)
);

decoder decoder1(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_decoder),
    .req(req_decoder),
    .data_in(demodulated_message),
    .ack(ack_decoder),
    .data_out(decoded_message)
);


endmodule //encoder_fec