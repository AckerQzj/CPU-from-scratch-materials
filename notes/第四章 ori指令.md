# ori：逻辑或运算

![image-20250514195251678](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514195251678.png)

I类型指令：指令码6‘b001101

用法：ori rs,rt,immediate	16位immediate无符号扩展到32位，然后和rs中的数据进行逻辑或运算，然后结果保存到rt中

通用寄存器：MIPS32中定义了32个通用寄存器0~31，使用通用寄存器只需要给出相应的索引即可，索引占5bit

# 流水线模型建立

流水线模型的简单建立：

①状态机：寄存器的输出和输入之间存在回路，这样的电路被称为“状态机”

②流水线：寄存器之间有连接，但是没有上述的回路，这样的结构被称为“流水线”

数据流图：

![image-20250514200308618](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514200308618.png)

![image-20250514200514782](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514200514782.png)

在define.v中定义我们要使用到的宏

![image-20250514200632785](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514200632785.png)

![image-20250514200639155](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514200639155.png)

![image-20250514200643934](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20250514200643934.png)

### 取指阶段的实现

取指阶段的任务：取出指令存储器中的指令，同时PC递增，准备取下一条指令，包括PC，IF/ID两个模块

PC模块

IF/ID模块：暂时保存取值阶段取得的指令和指令的地址，并在下一个时钟周期传递到译码阶段

### 译码阶段

包含三个模块：Regfile，ID，ID/EX

Regfile 定义了32个32位通用整数寄存器 可以同时进行两个寄存器的读和一个寄存器的写

