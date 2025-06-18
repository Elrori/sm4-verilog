// Language: Verilog 2001
`timescale 1ns / 100ps
// support for eth sm4
module sm4_top_eth_support (
    input  wire         clk,
    input  wire         rst,

    input  wire         sm4_vld,
    input  wire [127:0] sm4_key, // 复位后，无需置sm4_vld，sm4_key和sm4_sel也会生效。
    input  wire         sm4_sel, // 0: encrypt, 1: decrypt

    input  wire [7  :0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    input  wire         s_axis_tlast,
    output wire         s_axis_tready,
    input  wire [7  :0] s_axis_tuser,

    output wire [7  :0] m_axis_tdata,
    output wire         m_axis_tvalid,
    output wire         m_axis_tlast,
    output wire [7  :0] m_axis_tuser
);

sm4_top_axis8_padding  sm4_top_axis8_padding_inst (
    .clk(clk),
    .rst(rst),
    .sm4_vld(sm4_vld),
    .sm4_key(sm4_key),
    .sm4_sel(sm4_sel),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tlast(s_axis_tlast),
    .s_axis_tready(s_axis_tready),
    .s_axis_tuser(s_axis_tuser),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tuser(m_axis_tuser)
    );
endmodule
