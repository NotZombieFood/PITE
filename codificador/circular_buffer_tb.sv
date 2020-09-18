import encoder_fec_pkg::*;

module circular_buffer_tb();

logic clk = 0;
logic rst_n = 0;
logic wr_en = 0;
logic rd_en = 0;
message_data_t data_in;
message_data_t data_out;
logic empty;
logic full;
logic rd_valid;

logic continous_write_n = 0;
logic continous_read_n = 0;
message_data_t memory[$];

circular_buffer dut(
	.clk(clk),
	.rst_n(rst_n),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.data_in(data_in),
	.data_out(data_out),
	.empty(empty),
	.full(full),
	.rd_valid(rd_valid)
);

always begin
	#HALF_CLK_PERIOD clk = ~clk;
end

initial begin
	//Test write and read full buffers
	#200;
	rst_n=1;
	#100;
	write_complete_buffer(clk, wr_en, data_in, full, memory);
	#100;
	read_complete_buffer(clk, rd_en, data_out, empty, rd_valid, memory);
	#200;
	//$finish;
	#1000;
	//Test Continuos writing and reading
	fork
		begin
			write_complete_buffer(clk, wr_en, data_in, continous_write_n, memory);
		end
		begin
			read_complete_buffer(clk, rd_en, data_out, continous_read_n, rd_valid, memory);
		end
	join_none
	#1000ns;
	$finish;
end

endmodule 