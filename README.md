# 8bit-RISC-CPU
用verilog设计8位cpu
整个CPU结构图：
![image text](https://github.com/1Allison/img-folder/raw/master/image-20200407171216592.png)
# cpu的工作原理
## 1. 存储器
#### 功能：用来存储指令系统中的指令。
所有指令按地址顺序存放在存储器中。指令地址位是4位，cpu是八位，所以存储器是32*8bit。
data是一个双向数据总线。
当read=1,data从存储器读到总线上。当write在上升沿时，将data从总线写入存储器中。
```verliog
/***************  * 32X8 MEMORY *  ***************/ 
 
`timescale 1 ns / 1 ns 
 
module mem ( data, addr, read, write ) ;
 inout [7:0] data  ;
 input [4:0] addr  ;
 input       read  ;
 input       write ; 
 
  reg [7:0] memory [0:31] ; 
  assign data=(read)?memory[addr]:8'hZ;

  always@(posedge write)
   begin
    memory[addr]<=data[7:0];
   end
 
endmodule 
```
## 2.程序计数器
#### 功能：作为状态单元存放想要执行的指令的地址。计数指令的顺序号。
**上边沿有效的异步复位计数器**
每次cpu重新启动时，从存储器的零地址开始读取指令并且执行。执行完一条指令后，pc_addr增加2，指向下一条指令。若执行的是转移语句，id_pc为1，将该地址装入计数器中。
```
//5-bit counter 
`timescale 1 ns / 100 ps 
module counter ( cnt, clk, data, rst_, load ) ; 
 
output [4:0] cnt  ;
input  [4:0] data ;
input        clk  ;
input        rst_ ; 
input        load ; 
reg    [4:0] cnt  ; 
 
  always @ ( posedge clk or negedge rst_ )   
  	if ( !rst_ )      
 	  #1.2 cnt <= 0 ;     
	else       
	  if ( load )    
          cnt <= #3 data ;       
          else     
          cnt <= #4 cnt + 1 ; 
 
endmodule 
```

#### 寻址方式：
##### 指令寻址
1. 顺序寻址
2. 跳跃寻址 下一条指令的地址码不由计数器给出，在本条指令中指出。
即指令的内容为 ：JMP3。
##### 操作数寻址
1. 立即寻址方式 地址字段中直接给操作数（立即数）。
2. 直接寻址方式 地址字段中直接给操作数在存储器中的地址。
3. 间接寻址方式 地址字段中直接给操作数的地址在存储器中的地址，从操作数的地址找到操作数。
4. 寄存器寻址方式 地址字段中直接给寄存器的编号
4.1 直接
4.2 间接
5. 基址寻址 基址寄存器内容+指令中形式地址 得到有效地址
6. 变址寻址 指令中形式地址为基准，变址寄存器中内容为修改量。
7. 相对寻址 计数器内容+指令中地址形式

在本设计的8位cpu中，采用直接寻址方式


## 3.指令寄存器 
#### 功能 存放当前正在执行的指令
从存储器中经过数据总线把即将执行的指令读入寄存器中。
```
/******************  * 8-bit REGISTER *  ******************/ 
 
`timescale 1 ns / 1 ns 
 
module register ( out, data, load, clk, rst_ ) ; 
 
output [7:0] out  ;
input  [7:0] data ;
input        load ; 
input        clk  ; 
input        rst_ ; 
 
wire [7:0] n1, n2 ; 
 
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
```
## 4. 地址多路选择器
指令执行的情况有两种，需要进行选择。故设计一个二选一开关。
## 5. 算术逻辑单元 
根据指令的操作码opcode来判断下一步执行什么操作。对数据data和accum（累加器中数据）进行逻辑运算。

```
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
```
## 6. 累加器
寄存器.
暂时存放ALU的一个操作或者运算结果,比如ADD是 accum=accum+data。

## 7.状态控制器

![image text](https://github.com/1Allison/img-folder/raw/master/image-20200407162138106.png)

状态控制器是一个控制单元，通过控制何时停止或启动某些部件，何时读指令等。

它在8个周期内完成指令的获取和执行。前四个时钟周期为从存储器中取数据，后四个周期用来发出不同的控制信号。

**读取数据**：
第一个时钟周期：sel=1,存储器此时收到了一个mux给的地址pc_addr.
第二个时钟周期：sel=1,rd=1,存储器read=1，按照pc_addr的地址从存储器中读出数据到数据总线data上。
第三个时钟周期与第四个时钟周期相同（由于8位RISC_CPU读指令需要两个时钟周期）：sel=1,rd=1,id_ir=1,指令寄存器开始工作，读取data数据。data为8位数据，前3位是操作数，后五位是地址。

**处理数据**
第五个时钟周期：inc_pc=1,时钟信号。计数器开始工作，
第六个时钟周期：rd=aluop(一种控制信号)，执行ADD,AND,XOR,LDA时，aluop=1,read为1，需要从存储器中读取数据；当执行HLT、 SKZ、STO、JMP时，aluop=0,不需要从存储器中读数据。
第七个时钟周期：
1. 算术逻辑
2. 由于SKR操作是 skip if zero true,故需要判断ALU的zero标志是否为1，若zero为1，跳转到下一个语句。
3. JMP=1,PC地址为目标地址

第八个时钟周期