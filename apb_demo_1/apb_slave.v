/* apb slave code
 * @Author: xudatou1994 
 * @Date: 2023-02-19 17:45:42 
 * @Last Modified by:   xudatou1994 
 * @Last Modified time: 2023-02-19 17:45:42 
 */
module apb_demo #(
    // 数据宽度，支持8 16 32
    parameter DATA_WIDTH = 32,
    // 地址宽度，支持8 16 32
    parameter ADDR_WIDTH = 32

)(
    input wire pclk,
    input wire preset_n,
    input wire [ADDR_WIDTH-1:0] paddr,
    input wire psel,
    input wire penable,
    input wire pwrite,
    input wire [DATA_WIDTH-1:0] pwdata ,
    input wire [DATA_WIDTH/8-1:0] pstrb ,

    output wire pready,
    output wire [DATA_WIDTH-1:0] prdata ,
    output reg pslverr
);
    
    localparam DEMO_BASE_ADDR = 32'h00001234;

    localparam IDLE = 2'b00;
    localparam SETUP = 2'b01;
    localparam ACCESS = 2'b10;

    reg [1:0] state, state_next;
    wire [DATA_WIDTH-1:0] demo_reg0, demo_reg1;


    always @(posedge pclk or preset_n) begin
        if (!preset_n) begin
            state <= IDLE;
            state_next <= IDLE;

            pslverr <= 0;
        end
        else state <= state_next;
    end

    always @(*) begin
        case(state)
            IDLE: if((paddr[ADDR_WIDTH-1:4] == DEMO_BASE_ADDR[ADDR_WIDTH-1:4]) && psel) state_next <= SETUP;
            SETUP:if((paddr[ADDR_WIDTH-1:4] == DEMO_BASE_ADDR[ADDR_WIDTH-1:4]) && psel) state_next <= ACCESS;
            ACCESS: 
                if(pready) begin
                    if((paddr[ADDR_WIDTH-1:4] == DEMO_BASE_ADDR[ADDR_WIDTH-1:4]) && psel) state_next<= SETUP;
                    else state_next <= IDLE;
                end
            default: state_next <= IDLE;
        endcase
    end
    // assign pstrb_t = {{8{pstrb[3]}}, {8{pstrb[2]}}, {8{pstrb[1]}}, {8{pstrb[0]}}};
    assign pready = 1;
    assign demo_reg0 = (state == ACCESS && pwrite && paddr[2] && penable)?pwdata:demo_reg0;
    assign demo_reg1 = (state == ACCESS && pwrite && !paddr[2] && penable)?pwdata:demo_reg1;
    

    assign prdata = (state == ACCESS && !pwrite && paddr[2] && penable)?demo_reg0:((state == ACCESS && !pwrite && !paddr[2] && penable)?demo_reg1:prdata);

endmodule