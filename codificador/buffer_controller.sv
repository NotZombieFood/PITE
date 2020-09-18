import encoder_fec_pkg::*;

module buffer_controller(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input empty_buff1,
    input empty_buff2,
    input full_buff1,
    input full_buff2,
	 input rd_valid_buff1,
	 input rd_valid_buff2,
	 output logic rd_valid,
    output logic wr_en_buff1,
    output logic wr_en_buff2,
    output logic rd_en_buff1,
    output logic rd_en_buff2,
	 output logic reading_buff1
);

logic writting_buff1;
logic next_writting_buff1;
logic next_reading_buff1;

assign rd_valid = reading_buff1 ? rd_valid_buff1:rd_valid_buff2;

assign wr_en_buff1 = next_writting_buff1 & wr_en & !full_buff1;
assign wr_en_buff2 = !next_writting_buff1 & wr_en & !full_buff2;
assign rd_en_buff1 = next_reading_buff1 & rd_en & !empty_buff1;
assign rd_en_buff2 = !next_reading_buff1 & rd_en & !empty_buff2;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		writting_buff1 <= 1;
		reading_buff1 <= 0;
	end else begin
		writting_buff1 <= next_writting_buff1;
		reading_buff1 <= next_reading_buff1;
	end
end

always_comb begin
	if (writting_buff1) begin
		if (full_buff1 & empty_buff2) begin
			next_writting_buff1 = 0;
		end else begin
			next_writting_buff1 = 1;
		end
	end else begin
		if (full_buff2 & empty_buff1) begin
			next_writting_buff1 = 1;
		end else begin
			next_writting_buff1 = 0;
		end
	end
end

always_comb begin
	if (reading_buff1) begin
		if (empty_buff1 & full_buff2) begin
			next_reading_buff1 = 0;
		end else begin
			next_reading_buff1 = 1;
		end
	end else begin
		if (empty_buff2 & full_buff1) begin
			next_reading_buff1 = 1;
		end else begin
			next_reading_buff1 = 0;
		end
	end
end

endmodule //buffer_controller