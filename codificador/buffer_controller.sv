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
    output logic wr_en_buff1,
    output logic wr_en_buff2,
    output logic rd_en_buff1,
    output logic rd_en_buff2,
);

endmodule //buffer_controller