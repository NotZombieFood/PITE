import encoder_fec_pkg::*;
`timescale 1ns/1ps

module random_tb();

logic clk = 0;
logic rst_n = 0;
logic [15:0] input_val = 0;
logic [15:0] output_val = 0;
logic rd_en = 0;


random #(
) dut(
	.clk(clk),
	.rst_n(rst_n),
	.wr_en(wr_en),
	.input_val(input_val),
	.output_val(output_val)
);

//clock proccess
always begin
	#10 clk = ~clk;
end



//Test
initial begin
	#30;
	rst_n = 1;
	@(posedge clk);
	//Write complete buffer
  #100;
  input_val = 0xff;
	#100
  input_val = 0xaa;
end

endmodule
