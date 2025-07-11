// Language: Verilog 2001
`timescale 1ns / 100ps
// padding support for sm4
// len(tdata) % 16 ==0, no pading
// len(tdata) % 16 !=0, padding with 0x00
module sm4_top_axis8_padding (
    input  wire         clk,
    input  wire         rst,

    input  wire         sm4_vld,
    input  wire [127:0] sm4_key, // 复位后，无需置sm4_vld，sm4_key和sm4_sel也会生效。
    input  wire         sm4_sel, // 0: encrypt, 1: decrypt

    input  wire [7  :0] s_axis_tdata,/*synthesis keep=true*/
    input  wire         s_axis_tvalid,/*synthesis keep=true*/
    input  wire         s_axis_tlast,/*synthesis keep=true*/
    output wire         s_axis_tready,/*synthesis keep=true*/
    input  wire [7  :0] s_axis_tuser,/*synthesis keep=true*/

    output wire [7  :0] m_axis_tdata,/*synthesis keep=true*/
    output wire         m_axis_tvalid,/*synthesis keep=true*/
    output wire         m_axis_tlast,/*synthesis keep=true*/
    output wire [7  :0] m_axis_tuser/*synthesis keep=true*/
);

wire [7  :0] s_axis_tdata_int;
wire         s_axis_tvalid_int;
wire         s_axis_tlast_int;
wire         s_axis_tready_int;
wire [7  :0] s_axis_tuser_int;

wire         tready;
reg  [3 : 0] count;
reg          padding;
reg  [7  :0] padding_tuser;

assign s_axis_tready = tready & s_axis_tready_int;
assign s_axis_tlast_int = (count == 15)  ? (s_axis_tlast |padding) : 0;
assign s_axis_tvalid_int = padding  | s_axis_tvalid;
assign s_axis_tdata_int = padding ? 8'h00 : s_axis_tdata;
assign s_axis_tuser_int = padding ? padding_tuser : s_axis_tuser;
assign tready = ~padding;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        padding <= 0;
        padding_tuser <= 0;
    end else begin
        if (s_axis_tvalid && s_axis_tready && s_axis_tlast && (!padding)) begin
            if (count != 15) begin
                padding <= 1;
            end
        end else if(padding) begin
            if (count == 15) begin
                padding <= 0;
            end
        end
        if(s_axis_tvalid_int && s_axis_tlast_int) begin
            count <= 0;
        end else if ((s_axis_tvalid && s_axis_tready) || padding) begin
            count <= count + 1;
        end
        if(s_axis_tvalid && s_axis_tlast && s_axis_tready) begin
            padding_tuser <= s_axis_tuser;
        end
    end
end

sm4_top_axis8  sm4_top_axis8_inst (
    .clk(clk),
    .rst(rst),
    .sm4_vld(sm4_vld),
    .sm4_key(sm4_key),
    .sm4_sel(sm4_sel),
    
    .s_axis_tdata(s_axis_tdata_int),
    .s_axis_tvalid(s_axis_tvalid_int),
    .s_axis_tlast(s_axis_tlast_int),
    .s_axis_tready(s_axis_tready_int),
    .s_axis_tuser(s_axis_tuser_int),

    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tuser(m_axis_tuser)
    );

endmodule
