package encoder_fec_pkg;

    parameter DATA_WIDTH = 32;

    typedef logic[DATA_WIDTH-1:0]   message_data_t;
    typedef logic[DATA_WIDTH-1:0]   encoded_message_data_t;
    typedef logic[DATA_WIDTH-1:0]   modulated_message_data_t;
    typedef logic[DATA_WIDTH-1:0]   demodulated_message_data_t;

end package //encoder_fec_pkg