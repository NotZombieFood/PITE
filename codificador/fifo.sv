import module_encoder_fec::*

module fifo(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input message_data_t data_in,
    output message_data_t data_out,
    output logic rd_valid,
    output logic empty,
    output logic full
);

endmodule //fifo