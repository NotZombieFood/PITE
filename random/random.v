`timescale 1 ns/ 100 ps

//// W is width LFSR scaleable from 24 down to 4 bits
//// V is width LFSR for non uniform clocking scalable from 24 down to 18 bit
//// g_type gausian distribution type, 0 = unimodal, 1 = bimodal, from g_noise_out
//// u_type uniform distribution type, 0 = uniform, 1 =  ave-uniform, from u_noise_out

module random #(parameter W = 16)
	(
		output	reg [W-1 : 0]		output_val,
		input	[W-1 : 0]		input_val,
		input 	clk,
		input		n_reset
	);

  reg [3:0] bit_position;
  reg lfsr_enable;

  assign lfsr_enable = 1;

  lsfr lsfr_1(
    .g_noise_out(bit_position),
    .u_noise_out(),
    .clk(clk),
    .n_reset(n_reset),
    .enable(lsfr_enable)
  );

  always @(posedge clock)
     begin
        output <= input ^ (1 << bit_position);
     end
endmodule
