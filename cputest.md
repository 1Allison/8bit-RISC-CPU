#对cpu功能进行验证
###测试文件CPUTest1.dat
a. 首先opcode为111，对应操作指令JMP，跳转到地址00011110继续执行。00: fe
若跳转失败，则指令顺序执行，执行opcode为000，对应操作指令为HLT。
b.跳转成功, 在11110地址处执行111_00011，跳转到00011地址处 1e:e3
c.跳转成功，执行 101_11010，opcode为101，对应操作指令为LDA，将在11010地址处数 据data1放入累加器中。03:ba
d.之后执行opcode为001，对应操作指令为SKZ条件操作指令则判断在00000地址处，若 alu=0，跳过下一条语句。04:20
e.之后执行 101_11011 ，将在11011地址中的数据data2放入累加器中,则判断在00000地址 处，若alu=0，跳过下一条语句。 06:bb
f.执行111_01010，跳转到地址01010处。执行110_11100 ，将累加器中的数据存入地址 11100中。07:20
g.之后顺序执行101_11010，对应操作指令为LDA，将11010地址处数据data1放入累加器 中。08:ea
h.之后顺序执行110_11100，将累加器中的数据存入地址11100中。 0a:dc
i.之后顺序执行001_00000, 将11010地址处数据data1放入累加器中。 0b:ba
j.之后顺序执行110_11100 ,将累加器中的数据存入地址11100中。0c:dc
k.之后顺序执行101_11100 , 将11010地址处数据data1放入累加器中 。0d:bc
l.之后顺序执行 001_00000 ，对应操作指令为SKZ条件操作指令，则判断在00000地址处， 若alu=0，跳过下一条语句 。0e:20
m.顺序执行100_11011,将00100地址中数据与累加器中数据异或。 10:9b
n.顺序执行 001_00000。看xor是否工作。对应操作指令为SKZ，则在00000地址处:若
alu=0，跳过下一条语句。 11:20
o.顺序执行111_10100 。对应操作指令JMP，跳转到地址10100继续执行。12:f4 p.跳转到地址14，执行100_11011。将00100地址中数据与累加器中数据异或。14:9b
q.顺序执行001_00000，对应操作指令为SKZ，则在00000地址处:若alu=0，跳过下一条语 句。
r. 顺序执行000_00000 ，程序结束，进行HLT状态，停机。 另:以上指令若执行不成功则进入HLT状态。
代码如下:
```
//opcode_operand  // addr                   assembly code
//--------------  // ----  --------------------------------------------
@00 111_11110     //  00        BEGIN:   JMP TST_JMP
    000_00000     //  01        HLT    //JMP did not work at all
    000_00000     //  02        HLT  //JMP did not load PC, it skipped
    101_11010     //  03        JMP_OK:  LDA DATA_1
    001_00000     //  04        SKZ
    000_00000     //  05        HLT        //SKZ or LDA did not work
    101_11011     //  06        LDA DATA_2
    001_00000     //  07        SKZ
    111_01010     //  08        JMP SKZ_OK
    000_00000     //  09        HLT        //SKZ or LDA did not work
    110_11100     //  0A        STO TEMP//store non-zero value in TEMP
    101_11010     //  0B        LDA DATA_1
    110_11100     //  0C        STO TEMP   //store zero value in TEMP
    101_11100     //  0D        LDA TEMP
    001_00000     //  0E        SKZ        //check to see if STO worked
    000_00000     //  0F        HLT        //STO did not work
    100_11011     //  10        XOR DATA_2
    001_00000     //  11        SKZ        //check to see if XOR worked
    111_10100     //  12        JMP XOR_OK
    000_00000     //  13        HLT        //XOR did not work at all
    100_11011     //  14        XOR_OK:  XOR DATA_2
    001_00000     //  15        SKZ
    000_00000     //  16        HLT   //XOR did not switch all bits
    000_00000     //  17        END:HLT//CONGRATULATIONS - TEST1 PASSED!
    111_00000     //  18        JMP BEGIN  //run test again
@1A 00000000      //  1A        DATA_1:         //constant 00
    11111111      //  1B        DATA_2:         //constant FF
    10101010      //  1C        TEMP:             //variable
@1E 111_00011     //  1E        TST_JMP: JMP JMP_OK
	000_00000     //  1F        HLT        //JMP is broken
```
###测试文件CPUTest2.dat

a.101_11011   将11011处数据DATA_2送到累加器中 。 00:bb
    b.011_11100   顺序执行 将11100地址中存的数据DATA_3与累加器中数据DATA_2进行AND操作,结果放回累加器 01:7c
    c.100_11011   将11011地址中存的数据DATA_2与累加器中数据（DATA_2）AND（DATA_3）进行XOR操作,结果放回累加器  02:9b
    d.001_00000   验证操作是否正确 03:20
    e.010_11010   将11010地址中存的数据DATA_1与累加器中数据ADD操作,结果放回累加器 05:5a       
    f. 001_00000   验证操作是否正确 06:20
    g.111_01001   跳转到地址01001ADD_OK处 07:e9
    h.100_11100   将11100地址中存的数据DATA_3与累加器中数据进行XOR操作,结果放回累加器 09:9c 
    i. 010_11010   将11010地址中存的数据DATA_1与累加器中数据ADD操作,结果放回累加器 0a:5a
    j. 110_11101   将累加器中的数据存入地址11101的TEMP中。0b:dd
    k.101_11010   将11010处数据DATA_1送到累加器中 。 0c:ba
    l. 010_11101   将11011地址中存的数据TEMP与累加器中数据ADD操作,结果放回累加器。0d:5d
    g.001_00000   验证操作是否正确 oe:20
    k.000_00000   程序结束
总体功能为计算（（（（DATA_2）AND（DATA_3）XOR DATA_2）+DATA_1）XOR DATA_3）+DATA_1
代码如下：
```
//opcode_operand  // addr                   assembly code
//--------------  // ----  -------------------------------------------
@00 101_11011     //  00   BEGIN:  LDA DATA_2
    011_11100     //  01           AND DATA_3 
    100_11011     //  02           XOR DATA_2
    001_00000     //  03           SKZ
    000_00000     //  04           HLT         //AND doesn't work
    010_11010     //  05           ADD DATA_1
    001_00000     //  06           SKZ
    111_01001     //  07           JMP ADD_OK
    000_00000     //  08           HLT         //ADD doesn't work
    100_11100     //  09           XOR DATA_3
    010_11010     //  0A           ADD DATA_1  //FF plus 1 makes -1
    110_11101     //  0B           STO TEMP
    101_11010     //  0C           LDA DATA_1
    010_11101     //  0D         ADD TEMP    //-1 plus 1 should make zero
    001_00000     //  0E           SKZ
    000_00000     //  0F           HLT      //ADD Doesn't work
    000_00000     //  10   END:    HLT //CONGRATULATIONS - TEST2 PASSED!
    111_00000     //  11           JMP BEGIN   //run test again
@1A 00000001      //  1A   DATA_1:             //constant  1(hex)
    10101010      //  1B   DATA_2:             //constant AA(hex)
    11111111      //  1C   DATA_3:             //constant FF(hex)
    00000000      //  1D   TEMP:
```
###测试文件CPUTest3.dat
总体功能为计算斐波那契数列的之并输出到144
代码如下：
```
//opcode_operand  // addr                     assembly code
//--------------  // ----  --------------------------------------------
    111_00011     //  00   JMP LOOP   //jump to the address of LOOP
@03 101_11011     //  03   LOOP:   LDA FN2//load value in FN2 into accum
    110_11100     //  04   STO TEMP   //store accumulator in TEMP
    010_11010     //  05   ADD FN1    //add value in FN1 to accumulator
    110_11011     //  06   STO FN2    //store result in FN2
    101_11100     //  07   LDA TEMP   //load TEMP into the accumulator
    110_11010     //  08   STO FN1    //store accumulator in FN1
    100_11101     //  09   XOR LIMIT  //compare accumulator to LIMIT
    001_00000     //  0A   SKZ        //if accum = 0, skip to DONE
    111_00011     //  0B   JMP LOOP   //jump to address of LOOP
    000_00000     //  0C   DONE:   HLT        //end of program
    101_11111     //  0D   AGAIN:  LDA ONE
    110_11010     //  0E   STO FN1
    101_11110     //  0F   LDA ZERO
    110_11011     //  10   STO FN2
    111_00011     //  11   JMP LOOP   //jump to address of LOOP
@1A 000_00001     //  1A   FN1: //variable - stores 1st Fib. No.
    000_00000     //  1B   FN2: //variable - stores 2nd Fib. No.
    000_00000     //  1C   TEMP: //temporary variable
    100_10000     //  1D   LIMIT:  //constant 144 - max value
    000_00000     //  1E   ZERO: //constant 0
    000_00001     //  1F   ONE: //constant 1//
```
##3自行编写功能验证
仿照CPUTest3.dat中对斐波那契数列的测试，写了对佩尔数列的测试进行验证 Pell数列a1, a2, a3, ...的定义是这样的，
一组数据为:a1 = 1, a2 = 2, ... ,为:an = 2 * a[n − 1] + a[n - 2] (n > 2)
代码如下:
```

//opcode_operand // addr assembly code //-------------- // ---- --------------------------------------------
111_00011 // 00 @03 101_11010 // 03
JMP LOOP //jump to the address of LOOP LOOP:LDA N1 //load value in N1 into accum STO TEMP //store accumulator in TEMP
110_11110 010_11011 010_11011 110_11100 101_11011 110_11010 101_11100 110_11011 100_11111 001_00000 111_00011 000_00000
@1A 00000000
  00000001
  00000000
  00000000
  10101001
// 04 // 05 // 06 // 07 // 08 // 09 // 0A // 0B // 0C // 0D // 0E // 0F
ADD N2 ADD N2 STO N3 LDA N2 STO N1 LDA N3 STO N2
JMP LOOP //jump to the address of LOOP DONE:HLT //end of program
//add value in N2 to accumulator //store accumulator in N3
//store accumulator in N2
//store accumulator in N2
XOR LIMIT //compare accumulator to LIMIT SKZ //if accum = 0, skip to DONE
// 1A N1: //variable - stores 1st Fib. No. // 1B N2: //variable - stores 2nd Fib. No. // 1C N3: //variable - current value
// 1D TEMP: //temporary variable
// 1E LIMIT: //constant 169 - max value
```