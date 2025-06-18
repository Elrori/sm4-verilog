// Language: Verilog 2001
`timescale 1ns / 100ps
// support for eth sm4 42B
module sm4_top_eth_support #(
    parameter LOC = 42
)(
    input  wire         clk,
    input  wire         rst,

    input  wire         sm4_vld,
    input  wire [127:0] sm4_key, // 复位后，无需置sm4_vld，sm4_key和sm4_sel也会生效。
    input  wire         sm4_sel, // 0: encrypt, 1: decrypt

    input  wire [7  :0] s_axis_tdata, // ethernet data input
    input  wire         s_axis_tvalid,// 以太网报文满足 length>=64
    input  wire         s_axis_tlast,
    input  wire [7  :0] s_axis_tuser,

    output wire [7  :0] m_axis_tdata,// ethernet data output
    output wire         m_axis_tvalid,
    output wire         m_axis_tlast,
    output wire [7  :0] m_axis_tuser
);
localparam PIPELINE_DLY = 50;
initial begin
    if (LOC <=16) begin
        $display("sm4_top_eth_support.v: LOC must be greater than 16");
        $error;
    end
end

integer i;
reg [7:0]s_axis_tdata_int;
reg  s_axis_tvalid_int;
reg  s_axis_tlast_int;
wire s_axis_tready_int;
reg [7:0]s_axis_tuser_int;
reg [15:0] counter;

reg [7:0]s_axis_tdata_d[PIPELINE_DLY-1:0];
reg [PIPELINE_DLY-1:0]s_axis_tvalid_d;
reg [PIPELINE_DLY-1:0]s_s_axis_tlast_d;
reg [7:0]s_axis_tuser_d[PIPELINE_DLY-1:0];

wire [7:0]m_axis_tdata_dly;
wire      m_axis_tvalid_dly;
wire      m_axis_tlast_dly;
wire [7:0]m_axis_tuser_dly;

wire [7:0]m_axis_tdata_int;
wire      m_axis_tvalid_int;
wire      m_axis_tlast_int;
wire [7:0]m_axis_tuser_int;

assign    m_axis_tdata_dly = s_axis_tdata_d[PIPELINE_DLY-1];
assign    m_axis_tvalid_dly = s_axis_tvalid_d[PIPELINE_DLY-1];
assign    m_axis_tlast_dly = s_s_axis_tlast_d[PIPELINE_DLY-1];
assign    m_axis_tuser_dly = s_axis_tuser_d[PIPELINE_DLY-1];

assign    m_axis_tdata = {m_axis_tvalid_dly,m_axis_tvalid_int} == 2'b10 ? m_axis_tdata_dly : 
                         {m_axis_tvalid_dly,m_axis_tvalid_int} == 2'b11 ? m_axis_tdata_int :
                         {m_axis_tvalid_dly,m_axis_tvalid_int} == 2'b01 ? m_axis_tdata_int :8'b0;
assign    m_axis_tvalid = m_axis_tvalid_int|m_axis_tvalid_dly;
assign    m_axis_tlast  = m_axis_tlast_int;
assign    m_axis_tuser  = m_axis_tuser_int;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        s_axis_tvalid_int <= 0;
        s_axis_tdata_int  <= 0;
        s_axis_tlast_int  <= 0;
        s_axis_tuser_int  <= 0;
        counter <= 0;
    end else begin
        s_axis_tvalid_int <= (counter >= LOC) ? 1 : 0;
        s_axis_tdata_int  <= s_axis_tdata;
        s_axis_tlast_int  <= s_axis_tlast;
        s_axis_tuser_int  <= s_axis_tuser;
        if (s_axis_tvalid) begin
            if (s_axis_tlast) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end
sm4_top_axis8_padding  sm4_top_axis8_padding_inst (
    .clk(clk),
    .rst(rst),
    .sm4_vld(sm4_vld),
    .sm4_key(sm4_key),
    .sm4_sel(sm4_sel),
    .s_axis_tdata(s_axis_tdata_int),
    .s_axis_tvalid(s_axis_tvalid_int & s_axis_tready_int),
    .s_axis_tlast(s_axis_tlast_int),
    .s_axis_tready(s_axis_tready_int),
    .s_axis_tuser(s_axis_tuser_int),

    .m_axis_tdata(m_axis_tdata_int),
    .m_axis_tvalid(m_axis_tvalid_int),
    .m_axis_tlast(m_axis_tlast_int),
    .m_axis_tuser(m_axis_tuser_int)
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        s_axis_tvalid_d   <= {PIPELINE_DLY{1'b0}};
        s_s_axis_tlast_d  <= {PIPELINE_DLY{1'b0}};
    end else begin
        s_axis_tdata_d[0] <= s_axis_tdata;
        s_axis_tuser_d[0] <= s_axis_tuser;
        s_axis_tvalid_d   <={s_axis_tvalid_d, s_axis_tvalid};
        s_s_axis_tlast_d  <={s_s_axis_tlast_d, s_axis_tlast};
        for (i=1; i<PIPELINE_DLY; i=i+1) begin
            s_axis_tdata_d[i] <= s_axis_tdata_d[i-1];
            s_axis_tuser_d[i] <= s_axis_tuser_d[i-1];
        end        
    end

end
endmodule
