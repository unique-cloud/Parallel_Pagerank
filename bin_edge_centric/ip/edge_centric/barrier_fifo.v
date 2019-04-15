// (C) 1992-2014 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    


module barrier_fifo(
		// Global signals
		clock,
		resetn,	// use resetn to flush the fifo.
		
		// User I/O
		pull,
		push,
		in_data,
		out_data,
		valid,
		fifo_ready,
		
		// OpenCL runtime parameters
		work_group_size);
		
    parameter DATA_WIDTH = 32;
    parameter MAXIMUM_WORK_GROUP_SIZE = 1024;

    input clock;
    input resetn;
    input pull;
    input push;
    input [DATA_WIDTH-1:0] in_data;
    output [DATA_WIDTH-1:0] out_data;
    output valid;
    output fifo_ready;
    input [15:0] work_group_size;

	function integer my_local_log;
	input [31:0] value;
		for (my_local_log=0; value>1; my_local_log=my_local_log+1)
			value = value>>1;
	endfunction		

	localparam LOG_MAX_WORK_GROUP_SIZE = my_local_log(MAXIMUM_WORK_GROUP_SIZE);
	
	wire empty_signal, full_signal;
	wire [LOG_MAX_WORK_GROUP_SIZE:0] used_words;
	wire reset;
	reg [LOG_MAX_WORK_GROUP_SIZE:0] elements_left_in_current_workgroup;
	
	intermediate_data_fifo my_local_fifo(
		.clock(clock),
		.data(in_data),
		.rdreq(pull & ~empty_signal & (|elements_left_in_current_workgroup)),
		.sclr(reset),
		.wrreq(push & ~full_signal),
		.empty(empty_signal),
		.full(full_signal),
		.q(out_data),
		.usedw(used_words[LOG_MAX_WORK_GROUP_SIZE-1:0]));
	defparam my_local_fifo.DATA_WIDTH = DATA_WIDTH;
	defparam my_local_fifo.NUM_WORDS = MAXIMUM_WORK_GROUP_SIZE;
	defparam my_local_fifo.LOG_NUM_WORDS = LOG_MAX_WORK_GROUP_SIZE;
	
	assign valid = ~empty_signal;
	assign used_words[LOG_MAX_WORK_GROUP_SIZE] = full_signal;
	
	always@(posedge clock)
	begin
		if (reset)
		begin
			elements_left_in_current_workgroup <= 'd0;
		end
		else
			if ((~(|elements_left_in_current_workgroup)) && (
				({1'b0, used_words} + {1'b0, push}) >= {1'b0, work_group_size}))
			begin
				// If the fifo contains more elements than the work group size (or is about to after this push),
				// then at the next positive edge of the clock the fifo is ready to produce data.
				elements_left_in_current_workgroup <= work_group_size[LOG_MAX_WORK_GROUP_SIZE:0];
			end

			if (pull & (|elements_left_in_current_workgroup))
			begin				
				if ((~(|elements_left_in_current_workgroup[LOG_MAX_WORK_GROUP_SIZE:1])) && (elements_left_in_current_workgroup[0] == 1'b1) && (
					({1'b0, used_words} + {1'b0, push} - {1'b0, pull}) >= {1'b0, work_group_size}))
				begin
					// If the fifo contains more elements than the work group size (or is about to after this push),
					// then at the next positive edge of the clock the fifo is ready to produce data.
					elements_left_in_current_workgroup <= work_group_size[LOG_MAX_WORK_GROUP_SIZE:0];
				end
				else		
				begin
					// subtract 1 from the number of elements left for processing in the current workgroup.
					elements_left_in_current_workgroup <= elements_left_in_current_workgroup - 1'b1;
				end				
			end
	end
	
	assign fifo_ready = |elements_left_in_current_workgroup;

	reg [3:0] synched_reset_n;
	// Converting a resetn into a synchronous reset
	always@(posedge clock or negedge resetn)
	begin
		if (~resetn)
			synched_reset_n[0] <= 1'b0;
		else
			synched_reset_n[0] <= 1'b1;
	end 
	always@(posedge clock)
		synched_reset_n[3:1] <= synched_reset_n[2:0];

	assign reset = ~synched_reset_n[3];
endmodule
		

// megafunction wizard: %FIFO%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: scfifo 

// ============================================================
// File Name: intermediate_data_fifo.v
// Megafunction Name(s):
// 			scfifo
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 9.1 Build 350 03/24/2010 SP 2 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2010 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module intermediate_data_fifo (
	clock,
	data,
	rdreq,
	sclr,
	wrreq,
	empty,
	full,
	q,
	usedw);

	parameter DATA_WIDTH = 32;
	parameter NUM_WORDS = 1024;
	parameter LOG_NUM_WORDS = 10;

	input	  clock;
	input	[DATA_WIDTH-1:0]  data;
	input	  rdreq;
	input	  sclr;
	input	  wrreq;
	output	  empty;
	output	  full;
	output	[DATA_WIDTH-1:0]  q;
	output	[LOG_NUM_WORDS-1:0]  usedw;
	
	wire [LOG_NUM_WORDS-1:0] sub_wire0;
	wire  sub_wire1;
	wire [DATA_WIDTH-1:0] sub_wire2;
	wire  sub_wire3;
	wire [LOG_NUM_WORDS-1:0] usedw = sub_wire0[LOG_NUM_WORDS-1:0];
	wire  empty = sub_wire1;
	wire [DATA_WIDTH-1:0] q = sub_wire2[DATA_WIDTH-1:0];
	wire  full = sub_wire3;

	scfifo	scfifo_component (
				.rdreq (rdreq),
				.sclr (sclr),
				.clock (clock),
				.wrreq (wrreq),
				.data (data),
				.usedw (sub_wire0),
				.empty (sub_wire1),
				.q (sub_wire2),
				.full (sub_wire3)
				// synopsys translate_off
				,
				.aclr (),
				.almost_empty (),
				.almost_full ()
				// synopsys translate_on
				);
	defparam
		scfifo_component.add_ram_output_register = "OFF",
		scfifo_component.intended_device_family = "Cyclone II",
		scfifo_component.lpm_numwords = NUM_WORDS,
		scfifo_component.lpm_showahead = "ON",
		scfifo_component.lpm_type = "scfifo",
		scfifo_component.lpm_width = DATA_WIDTH,
		scfifo_component.lpm_widthu = LOG_NUM_WORDS,
		scfifo_component.overflow_checking = "OFF",
		scfifo_component.underflow_checking = "OFF",
		scfifo_component.use_eab = "ON";


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AlmostEmpty NUMERIC "0"
// Retrieval info: PRIVATE: AlmostEmptyThr NUMERIC "-1"
// Retrieval info: PRIVATE: AlmostFull NUMERIC "0"
// Retrieval info: PRIVATE: AlmostFullThr NUMERIC "-1"
// Retrieval info: PRIVATE: CLOCKS_ARE_SYNCHRONIZED NUMERIC "1"
// Retrieval info: PRIVATE: Clock NUMERIC "0"
// Retrieval info: PRIVATE: Depth NUMERIC "1024"
// Retrieval info: PRIVATE: Empty NUMERIC "1"
// Retrieval info: PRIVATE: Full NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
// Retrieval info: PRIVATE: LE_BasedFIFO NUMERIC "0"
// Retrieval info: PRIVATE: LegacyRREQ NUMERIC "0"
// Retrieval info: PRIVATE: MAX_DEPTH_BY_9 NUMERIC "0"
// Retrieval info: PRIVATE: OVERFLOW_CHECKING NUMERIC "1"
// Retrieval info: PRIVATE: Optimize NUMERIC "2"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: UNDERFLOW_CHECKING NUMERIC "1"
// Retrieval info: PRIVATE: UsedW NUMERIC "1"
// Retrieval info: PRIVATE: Width NUMERIC "8"
// Retrieval info: PRIVATE: dc_aclr NUMERIC "0"
// Retrieval info: PRIVATE: diff_widths NUMERIC "0"
// Retrieval info: PRIVATE: msb_usedw NUMERIC "0"
// Retrieval info: PRIVATE: output_width NUMERIC "8"
// Retrieval info: PRIVATE: rsEmpty NUMERIC "1"
// Retrieval info: PRIVATE: rsFull NUMERIC "0"
// Retrieval info: PRIVATE: rsUsedW NUMERIC "0"
// Retrieval info: PRIVATE: sc_aclr NUMERIC "0"
// Retrieval info: PRIVATE: sc_sclr NUMERIC "1"
// Retrieval info: PRIVATE: wsEmpty NUMERIC "0"
// Retrieval info: PRIVATE: wsFull NUMERIC "1"
// Retrieval info: PRIVATE: wsUsedW NUMERIC "0"
// Retrieval info: CONSTANT: ADD_RAM_OUTPUT_REGISTER STRING "OFF"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
// Retrieval info: CONSTANT: LPM_NUMWORDS NUMERIC "1024"
// Retrieval info: CONSTANT: LPM_SHOWAHEAD STRING "ON"
// Retrieval info: CONSTANT: LPM_TYPE STRING "scfifo"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "8"
// Retrieval info: CONSTANT: LPM_WIDTHU NUMERIC "10"
// Retrieval info: CONSTANT: OVERFLOW_CHECKING STRING "OFF"
// Retrieval info: CONSTANT: UNDERFLOW_CHECKING STRING "OFF"
// Retrieval info: CONSTANT: USE_EAB STRING "ON"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
// Retrieval info: USED_PORT: data 0 0 8 0 INPUT NODEFVAL data[7..0]
// Retrieval info: USED_PORT: empty 0 0 0 0 OUTPUT NODEFVAL empty
// Retrieval info: USED_PORT: full 0 0 0 0 OUTPUT NODEFVAL full
// Retrieval info: USED_PORT: q 0 0 8 0 OUTPUT NODEFVAL q[7..0]
// Retrieval info: USED_PORT: rdreq 0 0 0 0 INPUT NODEFVAL rdreq
// Retrieval info: USED_PORT: sclr 0 0 0 0 INPUT NODEFVAL sclr
// Retrieval info: USED_PORT: usedw 0 0 10 0 OUTPUT NODEFVAL usedw[9..0]
// Retrieval info: USED_PORT: wrreq 0 0 0 0 INPUT NODEFVAL wrreq
// Retrieval info: CONNECT: @data 0 0 8 0 data 0 0 8 0
// Retrieval info: CONNECT: q 0 0 8 0 @q 0 0 8 0
// Retrieval info: CONNECT: @wrreq 0 0 0 0 wrreq 0 0 0 0
// Retrieval info: CONNECT: @rdreq 0 0 0 0 rdreq 0 0 0 0
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: full 0 0 0 0 @full 0 0 0 0
// Retrieval info: CONNECT: empty 0 0 0 0 @empty 0 0 0 0
// Retrieval info: CONNECT: usedw 0 0 10 0 @usedw 0 0 10 0
// Retrieval info: CONNECT: @sclr 0 0 0 0 sclr 0 0 0 0
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo_bb.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo_waveforms.html TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL intermediate_data_fifo_wave*.jpg FALSE
// Retrieval info: LIB_FILE: altera_mf
