package encoder_fec_pkg;

	 //`define SIMULATION
	
	 parameter CLK_PERIOD = 50;
	 localparam HALF_CLK_PERIOD = CLK_PERIOD/2;
    parameter DATA_WIDTH = 8;
	 parameter ENTRIES_BUFFER = 1024;
	 parameter PARITY_BITS = 5;
	 localparam HAMMING_WIDTH = 16

    typedef logic[DATA_WIDTH-1:0]      message_data_t;
    typedef logic[HAMMING_WIDTH-1:0]   encoded_message_data_t;
    typedef logic[DATA_WIDTH-1:0]      modulated_message_data_t;
    typedef logic[DATA_WIDTH-1:0]      demodulated_message_data_t;
	 
	 
//TASKS FOR TEST BENCHES
//Only compile this tasks in modelsim for simulation, won´t compile in Quartus for synthesis
`ifdef SIMULATION
task automatic write_complete_buffer(
	ref logic clk,
	ref logic wr_en,
	ref message_data_t wr_data,
	ref logic full,
	ref message_data_t memory[$]);
begin
	if (!full) begin
		@(posedge clk);
		wr_en = 1;
		wr_data = $urandom();
	end
	while (!full) begin
		@(posedge clk);
		memory.push_back(wr_data);
		wr_data = $urandom();
		#1;
	end
	wr_en  = 0;
end
endtask: write_complete_buffer

task automatic read_complete_buffer(
	ref clk,
	ref logic rd_en,
	ref message_data_t rd_data,
	ref logic empty,
	ref logic rd_valid,
	ref message_data_t memory[$]);
begin	
	message_data_t data_tmp;
	@(posedge clk);
	rd_en = 1;
	@(posedge clk);
	while(!empty) begin
		@(posedge clk);
		if (rd_valid) begin
			data_tmp = memory.pop_front();
			assert(data_tmp==rd_data) else begin
				$fatal("Mismatch reading memory, expected: %d, actual: %d", data_tmp, rd_data);
			end
		end
	end
	rd_en = 0;
end
endtask: read_complete_buffer
`endif
	 

endpackage //encoder_fec_pkg