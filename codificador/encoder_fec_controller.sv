import encoder_fec_pkg::*;

module encoder_fec_controller(
    input clk,
    input rst_n,
    input en,
    input req,
    input buff_empty_encoder,
    input buff_empty_decoder,
    input buff_full_encoder,
    input buff_full_decoder,
    input buff_rd_valid_encoder,
    input buff_rd_valid_decoder,
    input ack_encoder,
    input ack_decoder,
    input ack_modulator,
    input ack_demodulator,
	 input buff_rd_valid,
    output logic req_encoder,
    output logic req_decoder,
    output logic req_modulator,
    output logic req_demodulator,
    output logic ack,
    output logic wr_en_buff,
    output logic rd_en_buff,
    output logic en_encoder,
    output logic en_modulator,
    output logic en_demodulator,
    output logic en_decoder,
	 output logic rd_en_buff_decoder,
	 output logic rd_en_buff_encoder,
	 output logic wr_en_buff_decoder,
	 output logic wr_en_buff_encoder
    
);

typedef enum logic {FREE, BUSSY} state_t;

state_t state_buff_encoder, next_state_buff_encoder;
state_t state_buff_decoder, next_state_buff_decoder;
state_t state_encoder, state_decoder, next_state_encoder, next_state_decoder;
state_t state_modulator, state_demodulator, next_state_modulator, next_state_demodulator;

assign ack = buff_rd_valid_decoder;

always_comb begin
	if (~rst_n) begin
		en_encoder = 0;
		en_modulator = 0;
		en_demodulator = 0;
		en_decoder = 0;
	end else begin
		en_encoder = 1;
		en_modulator = 1;
		en_demodulator = 1;
		en_decoder = 1;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state_buff_encoder = FREE;
		state_buff_decoder = FREE;
		state_encoder = FREE;
		state_decoder = FREE;
		state_modulator = FREE;
		state_demodulator = FREE;
	end else begin
		state_buff_encoder = next_state_buff_encoder;
		state_buff_decoder = next_state_buff_decoder;
		state_encoder = next_state_encoder;
		state_decoder = next_state_decoder;
		state_modulator = next_state_modulator;
		state_demodulator = next_state_demodulator;
	end
end

always_comb begin
	case (state_buff_encoder) 
		FREE: begin
			if (buff_full_encoder) next_state_buff_encoder = BUSSY;
			else next_state_buff_encoder = FREE;
		end
		BUSSY: begin
			if (buff_full_encoder) next_state_buff_encoder = BUSSY;
			else next_state_buff_encoder = FREE;
		end
		default: next_state_buff_encoder = FREE;
	endcase
end

always_comb begin
	case (state_buff_decoder) 
		FREE: begin
			if (buff_full_decoder) next_state_buff_decoder = BUSSY;
			else next_state_buff_decoder = FREE;
		end
		BUSSY: begin
			if (buff_full_decoder) next_state_buff_decoder = BUSSY;
			else next_state_buff_decoder = FREE;
		end
		default: next_state_buff_decoder = FREE;
	endcase
end
	
always_comb begin
	case (state_encoder) 
		FREE: begin
			if (req_encoder) next_state_encoder = BUSSY;
			else next_state_encoder = FREE;
		end
		BUSSY: begin
			if (ack_encoder) next_state_encoder = FREE;
			else next_state_encoder = BUSSY;
		end
		default: next_state_encoder = FREE;
	endcase
end
	
always_comb begin
	case (state_decoder) 
		FREE: begin
			if (req_decoder) next_state_decoder = BUSSY;
			else next_state_decoder = FREE;
		end
		BUSSY: begin
			if (ack_decoder) next_state_decoder = FREE;
			else next_state_decoder = BUSSY;
		end
		default: next_state_decoder = FREE;
	endcase
end
	
always_comb begin
	case (state_modulator) 
		FREE: begin
			if (req_modulator) next_state_modulator = BUSSY;
			else next_state_modulator = FREE;
		end
		BUSSY: begin
			if (ack_modulator) next_state_modulator = FREE;
			else next_state_modulator = BUSSY;
		end
		default: next_state_modulator = FREE;
	endcase
end
	
always_comb begin
	case (state_demodulator) 
		FREE: begin
			if (req_demodulator) next_state_demodulator = BUSSY;
			else next_state_demodulator = FREE;
		end
		BUSSY: begin
			if (ack_demodulator) next_state_demodulator = FREE;
			else next_state_demodulator = BUSSY;
		end
		default: next_state_demodulator = FREE;
	endcase
end

assign req_encoder = buff_rd_valid_encoder;

always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		req_modulator <= 0;
		req_demodulator <= 0;
		req_decoder <= 0;
		wr_en_buff_decoder <= 0;
	end else if (en) begin
		req_modulator <= req_encoder;
		req_demodulator <= req_modulator;
		req_decoder <= req_demodulator;
		wr_en_buff_decoder <= req_decoder;
	end
end


always_comb begin
	rd_en_buff_decoder = 1;
	rd_en_buff_encoder = 1;
	case (state_buff_encoder) 
		FREE: begin
			wr_en_buff = 1;
			if (req) wr_en_buff_encoder = 1;
			else wr_en_buff_encoder = 0;
		end
		BUSSY: begin
			wr_en_buff = 0;
			wr_en_buff_encoder = 0;
		end
		default: begin
			wr_en_buff = 0;
			wr_en_buff_encoder = 0;
		end
	endcase
end

/*
	
always_comb begin
	case (state_buff_decoder) 
		FREE: begin
			rd_en_buff_decoder = 1;
			if (ack_decoder) wr_en_buff_decoder = 1;
			else wr_en_buff_decoder = 0;
		end
		BUSSY: begin
			rd_en_buff_decoder = 1;
			wr_en_buff_decoder = 0;
		end
		default: begin
			rd_en_buff_decoder = 1;
			wr_en_buff_decoder = 0;
		end
	endcase
end
	
always_comb begin
	case (state_encoder) 
		FREE: begin
			rd_en_buff_encoder = 1;
			if (buff_rd_valid_encoder) req_encoder = 1;
			else req_encoder = 0;
		end
		default: req_encoder = 0;
	endcase
end
	
always_comb begin
	case (state_decoder) 
		FREE: begin
			if (ack_demodulator) req_decoder = 1;
			else req_decoder = 0;
		end
		default: req_decoder = 0;
	endcase
end

always_comb begin	
	case (state_modulator) 
		FREE: begin
			if (ack_encoder) req_modulator = 1;
			else req_modulator = 0;
		end
		default: req_modulator = 0;
	endcase
end
	
always_comb begin
	case (state_demodulator) 
		FREE: begin
			if (ack_modulator) req_demodulator = 1;
			else req_demodulator = 0;
		end
		default: req_demodulator = 0;
	endcase
end
*/


endmodule //encoder_fec_controller