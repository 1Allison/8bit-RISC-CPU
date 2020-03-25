/******************  * 8-bit REGISTER *  ******************/ 
 
`timescale 1 ns / 1 ns 
 
module register ( out, data, load, clk, rst_ ) ; 
 
output [7:0] out  ;
input  [7:0] data ;
input        load ; 
input        clk  ; 
input        rst_ ; 
 
wire [7:0] n1, n2 ; 
 
// ???? dffr
mux mux7
(.out(n1[7]),
.sel(load),
.b(data[7]),
.a(out[7])
);
dffr dffr7
(.q(out[7]),
.d(n1[7]),
.clk(clk),
.rst_(rst_) 
);

mux mux6
(.out(n1[6]),
.sel(load),
.b(data[6]),
.a(out[6])
);
dffr dffr6
(.q(out[6]),
.d(n1[6]),
.clk(clk),
.rst_(rst_) 
);

mux mux5
(.out(n1[5]),
.sel(load),
.b(data[5]),
.a(out[5])
);
dffr dffr5
(.q(out[5]),
.d(n1[5]),
.clk(clk),
.rst_(rst_) 
);

mux mux4
(.out(n1[4]),
.sel(load),
.b(data[4]),
.a(out[4])
);
dffr dffr4
(.q(out[4]),
.d(n1[4]),
.clk(clk),
.rst_(rst_) 
);

mux mux3
(.out(n1[3]),
.sel(load),
.b(data[3]),
.a(out[3])
);
dffr dffr3
(.q(out[3]),
.d(n1[3]),
.clk(clk),
.rst_(rst_) 
);

mux mux2
(.out(n1[2]),
.sel(load),
.b(data[2]),
.a(out[2])
);
dffr dffr2
(.q(out[2]),
.d(n1[2]),
.clk(clk),
.rst_(rst_) 
);

mux mux1
(.out(n1[1]),
.sel(load),
.b(data[1]),
.a(out[1])
);
dffr dffr1
(.q(out[1]),
.d(n1[1]),
.clk(clk),
.rst_(rst_) 
);

mux mux0
(.out(n1[0]),
.sel(load),
.b(data[0]),
.a(out[0])
);
dffr dffr0
(.q(out[0]),
.d(n1[0]),
.clk(clk),
.rst_(rst_) 
);

endmodule 