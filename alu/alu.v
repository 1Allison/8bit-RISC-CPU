`timescale 1ns/100ps
 module alu(out,zero,opcode,data,accum);
 input [7:0] data,accum;
 input [2:0] opcode;
 output zero;
 output [7:0] out;
 reg [7:0] out; //
 reg zero; 
 
 parameter PASS0 = 3'b000,
           PASS1 = 3'b001,
             ADD   = 3'b010,
             AND   = 3'b011,
             XOR   = 3'b100,
             PASSD = 3'b101,
             PASS6 = 3'b110,
             PASS7 = 3'b111; 
 
// ???????????? 
 always@(opcode or data or accum)
 begin
  if(accum==8'b00000000)
	#1.2 zero=1;
  else
	#1.2 zero=0;
  case(opcode)
  PASS0:#3.5 out=accum;
  PASS1:#3.5 out=accum;
  ADD:#3.5 out=accum+data;
  AND:#3.5 out=accum&data;
  XOR:#3.5 out=accum^data;
  PASSD:#3.5 out=data;
  PASS6:#3.5 out=accum;
  PASS7:#3.5 out=accum;
  default:#3.5 out=8'bx;
endcase
 end

endmodule 
