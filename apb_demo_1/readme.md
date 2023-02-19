设计目标：使用APB5协议对两个32bit寄存器读、写，并且实现基本验证代码。

参考资料《IHI0024D_amba_apb_protocol_spec.pdf》

在APB协议更新中（文档第十页），有如下信号的变动
APB2 --> APB3
+ PREADY，表示一次传输是否完成
+ PSLVERR，表示传输过程中是否有错误

APB3 --> APB4
+ PPROT,表示安全、非安全传输
+ PSTRB，类似于网络掩码，表示哪几位传输有效

APB4 --> APB5




信号名称| 信号作用 | demo代码中的定义
---- | ---- |----
PCLK | 1bit,时钟信号 | pclk
PRESETn | 1bit,复位信号，低电平复位 | preset_n
PADDR | 最多支持32bit,地址位，读写都会用到 | paddr
PSELx | 1bit,片选位 | psel
PENABLE | 1bit,使能位，跟psel功能很像 | penable
PWRITE | 1bit,0：读，1：写 | pwrite
PWDATA | 最多支持32bit,写入的数据| pwdata
PSTRB | 掩码，8bit一组，32bit的传输宽度需要4位掩码| pstrb
PREADY | 1bit, 表示一次传输是否完成 | pready
PRDATA | 最多支持32bit, 读取的数据 | prdata
PSLVERR | 1bit,代表传输过程中是否有错误 | pslverr
PWAKEUP | |
PAUSER | |
PWUSER | |
PRUSER | |
PBUSER | |

Table: 在APB5下的所有信号功能
