/*********************************  * TEST BENCH FOR 8-BIT REGISTER *  *********************************/ 
`timescale 1 ns / 1 ns
 module register_test; 
 
  wire [7:0] out  ;
  reg  [7:0] data ;
  reg        load ;
  reg        rst_ ; 
  reg        clk;
// ????????
// Instantiate register 
register c1
(.out(out),
.data(data),
.load(load),
.rst_(rst_),
.clk(clk));
 
 
// Instantiate clock 
 initial begin
 clk =0;
 forever begin
 #10 clk=1'b1;
 #10 clk=1'b0;
 end
 end
 
// Monitor signals 

initial
begin
    $timeformat(-9,1,"ns",9);
    $monitor("time=%t, clk=%b, data=%h, load=%b, out=%h",$stime, clk, data, load, out);
    $dumpvars(2,register_test);
end
 
// Apply stimulus 
 
initial 
begin 
// INSERT STIMULUS HERE
 /*To prevent clock/data races,ensure that you don?t transition the stimulus on the active(positive)edge of the clock */ 
 
      @ ( negedge clk ) // Initialize signals 
         rst_ = 0 ;
         data = 0 ;
         load = 0 ; 
 
      @ ( negedge clk ) // Release reset
         rst_ = 1 ; 
 
      @ ( negedge clk ) // Load hex 55
         data = 'h55 ;
         load = 1 ; 
 
      @ ( negedge clk ) // Load hex AA
         data = 'hAA ;
         load = 1 ; 
 
      @ ( negedge clk ) // Disable load but register
         data = 'hCC ;
         load = 0 ; 
 
      @ ( negedge clk ) // Terminate simulation
         $finish ;
     end 
 
endmodule 
 