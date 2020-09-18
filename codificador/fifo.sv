import encoder_fec_pkg::*;

module fifo #(
	parameter WIDTH = 32,
	parameter ENTRIES = 1024
)
(
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

localparam index = $clog2(ENTRIES);

//Memory to store data
logic [WIDTH-1:0] memory[ENTRIES-1:0];
//Indexes to access data
logic[index-1:0] wr_idx;
logic[index-1:0] next_wr_idx;
logic[index-1:0] rd_idx;
logic[index-1:0] next_rd_idx;
logic[1:0] conc_wren_rden;

//Concatenate wren and rden
assign conc_wren_rden = {wr_en, rd_en};
//Assign next index
assign next_wr_idx = wr_idx+1'b1;
assign next_rd_idx = rd_idx+1'b1;

//Write data
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		//Errase mem
		for (int idx=0; idx<ENTRIES; idx++) begin
			memory[idx] <= 0;
			wr_idx <= 0;
		end
	end else if (wr_en) begin
		memory[wr_idx] <= data_in;
		wr_idx <= next_wr_idx;
	end
end

//read_data
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		data_out <= 0;
		rd_idx <= 0;
		rd_valid <= 0;
	end else if (rd_en) begin
		if (!empty) begin
			data_out <= memory[rd_idx];
			rd_idx <= next_rd_idx;
			rd_valid <= 1;
		end else begin
			data_out <= 0;
			rd_valid <= 0;
		end
	end
end

//full empty flags
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		empty <= 1;
		full <= 0;
	end else begin
		case (conc_wren_rden)
			2'b01: begin				//only read
				full <= 0;
				if ((next_rd_idx==wr_idx)||(empty)) begin
					empty <= 1;
				end else begin
					empty <= 0;
				end
			end
			2'b10: begin 				//only write
				empty <= 0;
				if (next_wr_idx == rd_idx) begin
					full <= 1;
				end else begin
					full <= 0;
				end 
			end
			default:	begin			//no change
				full <= full;	
				empty <= empty;
			end
		endcase
	end
end

endmodule //fifo