/*
 * @Author: xudatou1994 
 * @Date: 2023-02-19 17:45:59 
 * @Last Modified by: xudatou1994
 * @Last Modified time: 2023-02-19 17:47:24
 */
`timescale 1ns/1ns
module apb_master ();
    reg clk;
    reg reset_n;
    reg [31:0] paddr ;
    reg psel;
    reg penable;
    reg pwrite;
    reg [31:0] pwdata ;
    reg [3:0] pstrb ;

    reg pready;
    reg [31:0] prdata ;
    reg pslverr;

    reg [31:0] data_t;
   
    localparam reg0_addr = 32'h00001234;
    localparam reg1_addr = 32'h00001234 + 4;

    localparam clk_cycle = 5;

initial begin
    $fsdbDumpfile("apb_master.fsdb");
    $fsdbDumpvars();
    $display("apb_demo_tb start");
    clk = 0;
   
end

task apb_reset();
    reset_n = 0;
    psel = 0;
    pwrite = 0;
    penable = 0;
    pstrb = 4'hf;
    repeat(2)
         @(posedge clk);
   reset_n = 1;  
   @(posedge clk);
endtask

task apb_write(input [31:0] addr, input [31:0] wdata);
   // T1
    @(posedge clk)begin
        paddr = addr;
        pwdata = wdata;
        pwrite = 1;
        psel = 1;
        pstrb = 4'hf;
    end
    // T2
    @(posedge clk);
    penable = 1;
    @(posedge clk);
endtask

task apb_read(input [31:0] addr);
    //T1
    @(posedge clk)begin
        paddr = addr;
        pwrite = 0;
        psel = 1;
        penable = 0;
    end

    //T2
    @(posedge clk);
    penable = 1;
    @(posedge clk);
    
endtask

task apb_write_and_check(input [31:0] addr, input [31:0] wdata);
    apb_write(addr, wdata);
    # clk_cycle;
    apb_read(addr);
    if (prdata == wdata) $display("apb check succ");
    else $display("apb check failed, except:%x, actuall:%x",wdata , prdata);

endtask


always begin
   #clk_cycle clk = ~clk;
end

always begin
   
   //reg 0
   apb_reset();
   data_t = $random();
   apb_write_and_check(reg0_addr, data_t);

   //reg1
   data_t = $random();
   apb_write_and_check(reg1_addr, data_t);

   $display("apb_demo_tb end");
   $finish;

end

apb_demo dut(
    .pclk(clk), 
    .preset_n(reset_n), 
    .paddr(paddr), 
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite), 
    .pwdata(pwdata),
    .pstrb(pstrb),

    .pready(pready),
    .prdata(prdata),
    .pslverr(pslverr)
);

endmodule