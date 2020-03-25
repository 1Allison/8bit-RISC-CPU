
`timescale 1 ns/1 ns
module clock(clk);
 reg clk;
 output clk;
 initial begin
 clk =0;
 forever begin
 #10 clk=1'b1;
 #10 clk=1'b0;
 end
 end
end module
