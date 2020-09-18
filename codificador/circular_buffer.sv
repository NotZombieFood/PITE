import encoder_fec_pkg::*;

module circular_buffer(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input message_data_t data_in,
    input message_data_t data_out,
    output logic empty,
    output logic full,
    output logic rd_valid
);

buffer_controller controller(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rd_en(),
    .empty_buff1(),
    .empty_buff2(),
    .full_buff1(),
    .full_buff2(),
    .wr_en_buff1(),
    .wr_en_buff2(),
    .rd_en_buff1(),
    .rd_en_buff2()
);

fifo #(
	.WIDTH(DATA_WIDTH),
	.ENTRIES(ENTRIES_BUFFER)
)buff1(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rd_en(),
    .data_in(),
    .data_out(),
    .rd_valid(),
    .empty(),
    .full()
);

fifo #(
	.WIDTH(DATA_WIDTH),
	.ENTRIES(ENTRIES_BUFFER)
)buff2(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(),
    .rd_en(),
    .data_in(),
    .data_out(),
    .rd_valid(),
    .empty(),
    .full()
);

endmodule //circular_buffer