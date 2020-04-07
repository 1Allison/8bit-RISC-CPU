# 8bit-RISC-CPU
用verilog设计8位cpu
# cpu的工作原理

## 7. 状态控制器

![image-20200407162138106](/Users/allisonli/Library/Application Support/typora-user-images/image-20200407162138106.png)

状态控制器是一个控制单元，通过控制何时停止或启动某些部件，何时读指令等。

它在8个周期内完成指令的获取和执行。前四个时钟周期为从存储器中取数据，后四个周期用来发出不同的控制信号