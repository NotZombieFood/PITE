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

encoder_fec_controller controller(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .req(req),
    .ack(ack),
    .buff_empty()
    .buff_full(),
    .wr_en_buff(),
    .rd_en_buff(),
    .en_encoder(),
    .en_modulator(),
    .en_demodulator(),
    .en_decoder()
);

circular_buffer buff_encoder(          //Buffer before encoder
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rd_en(),
    .data_in(),
    .data_out(),
    .empty(),
    .full(),
    .rd_valid()
);

circular_buffer buff_decoder(          //Buffer after decoder
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rd_en(),
    .data_in(),
    .data_out(),
    .empty(),
    .full(),
    .rd_valid()
);

encoder encoder1(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .data_in(),
    .data_out()
);

modulator modulator1(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .data_in(),
    .data_out()
);

demodulator demodulator1(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .data_in(),
    .data_out()
);

decoder decoder1(
    .clk(clk),
    .rst_n(rst_n),
    .en(),
    .data_in(),
    .data_out()
);


endmodule //encoder_fec