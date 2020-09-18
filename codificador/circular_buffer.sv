import encoder_fec_pkg::*;

module circular_buffer(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input message_data_t data_in,
    output message_data_t data_out,
    output logic empty,
    output logic full,
    output logic rd_valid
);

logic empty_buff1, empty_buff2;
logic full_buff1, full_buff2;
logic wr_en_buff1, wr_en_buff2;
logic rd_en_buff1, rd_en_buff2;
logic rd_valid_buff1, rd_valid_buff2;
logic reading_buff1;
message_data_t rd_data_buff1, rd_data_buff2;

assign data_out = reading_buff1 ? rd_data_buff1:rd_data_buff2;
assign full = full_buff1 & full_buff2;
assign empty = empty_buff1 & empty_buff2;

buffer_controller controller(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .empty_buff1(empty_buff1),
    .empty_buff2(empty_buff2),
	 .rd_valid_buff1(rd_valid_buff1),
	 .rd_valid_buff2(rd_valid_buff2),
	 .rd_valid(rd_valid),
    .full_buff1(full_buff1),
    .full_buff2(full_buff2),
    .wr_en_buff1(wr_en_buff1),
    .wr_en_buff2(wr_en_buff2),
    .rd_en_buff1(rd_en_buff1),
    .rd_en_buff2(rd_en_buff2),
	 .reading_buff1(reading_buff1)
);

fifo #(
	.WIDTH(DATA_WIDTH),
	.ENTRIES(ENTRIES_BUFFER)
)buff1(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_buff1),
    .rd_en(rd_en_buff1),
    .data_in(data_in),
    .data_out(rd_data_buff1),
    .rd_valid(rd_valid_buff1),
    .empty(empty_buff1),
    .full(full_buff1)
);

fifo #(
	.WIDTH(DATA_WIDTH),
	.ENTRIES(ENTRIES_BUFFER)
)buff2(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_buff2),
    .rd_en(rd_en_buff2),
    .data_in(data_in),
    .data_out(rd_data_buff2),
    .rd_valid(rd_valid_buff2),
    .empty(empty_buff2),
    .full(full_buff2)
);

endmodule //circular_buffer