import encoder_fec_pkg::*;
`timescale 1ns/1ps

module fifo_tb();

logic clk = 0;
logic rst_n = 0;
logic wr_en = 0;
logic rd_en = 0;
message_data_t data_in;
message_data_t data_out;
logic rd_valid;
logic empty;
logic full;

message_data_t memory_queue[$];

fifo #(
	.WIDTH(DATA_WIDTH),
	.ENTRIES(ENTRIES_BUFFER)
) dut(
	.clk(clk),
	.rst_n(rst_n),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.data_in(data_in),
	.data_out(data_out),
	.rd_valid(rd_valid),
	.empty(empty),
	.full(full)
);

//clock proccess
always begin
	#HALF_CLK_PERIOD clk = ~clk;
end



//Test
initial begin
	#30;
	rst_n = 1;
	@(posedge clk);
	//Write complete buffer
	write_complete_buffer(clk, wr_en, data_in, full, memory_queue);
	#100;
	@(posedge clk);
	//Read complete buffer
	read_complete_buffer(clk, rd_en, data_out, empty, memory_queue);
	#100;
	$finish;

end 


endmodule 