// Language: Verilog 2001
`timescale 1ns / 100ps
module sm4_top_axis8 (
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
    output reg          m_axis_tvalid,/*synthesis keep=true*/
    output wire         m_axis_tlast,/*synthesis keep=true*/
    output wire [7  :0] m_axis_tuser/*synthesis keep=true*/
);
integer i;
reg  [127:0] s_axis_tdata_128;
reg          s_axis_tvalid_128;
reg          s_axis_tlast_128;
wire         s_axis_tready_128;

reg  [127:0] m_axis_tdata_128_d1;
wire [127:0] m_axis_tdata_128;
wire         m_axis_tvalid_128;
wire         m_axis_tlast_128;

reg [3:0]    count;
reg [15:0]   m_axis_tlast_d;
reg [7:0]    s_axis_tuser_d[48:0];

assign s_axis_tready = s_axis_tready_128;
assign m_axis_tdata = m_axis_tdata_128_d1[127:120];
assign m_axis_tlast = m_axis_tlast_d[15];
assign m_axis_tuser = s_axis_tuser_d[48];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        s_axis_tdata_128 <= 0;
        s_axis_tvalid_128 <= 0;
        m_axis_tlast_d <= 0;
    end else begin
        s_axis_tuser_d[0] <= s_axis_tuser;
        for (i=1;i<49;i=i+1) begin
            s_axis_tuser_d[i] <= s_axis_tuser_d[i-1];
        end

        m_axis_tlast_d <= {m_axis_tlast_d,m_axis_tlast_128};
        s_axis_tvalid_128 <= count == 15;
        s_axis_tlast_128  <= s_axis_tlast && count == 15;
        if (s_axis_tvalid && s_axis_tready_128) begin
            count <= count + 1;
            s_axis_tdata_128 <= {s_axis_tdata_128, s_axis_tdata};
        end
    end
end

sm4_top_axis128  sm4_top_axis128_inst (
    .clk(clk),
    .rst(rst),
    .sm4_vld(sm4_vld),
    .sm4_key(sm4_key),
    .sm4_sel(sm4_sel),

    .s_axis_tdata(s_axis_tdata_128),
    .s_axis_tvalid(s_axis_tvalid_128),
    .s_axis_tlast(s_axis_tlast_128),
    .s_axis_tready(s_axis_tready_128),

    .m_axis_tdata(m_axis_tdata_128),
    .m_axis_tvalid(m_axis_tvalid_128),
    .m_axis_tlast(m_axis_tlast_128)
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        m_axis_tdata_128_d1 <= 128'd0;
        m_axis_tvalid <= 0;
    end else begin
        if (m_axis_tvalid_128) begin
            m_axis_tdata_128_d1 <= m_axis_tdata_128;
        end else begin
            m_axis_tdata_128_d1 <= m_axis_tdata_128_d1 << 8;
        end
        if (m_axis_tlast && (!m_axis_tvalid_128)) begin
            m_axis_tvalid <= 0;
        end else if (m_axis_tvalid_128) begin
            m_axis_tvalid <= 1;
        end
    end
end
endmodule
