// Language: Verilog 2001
`timescale 1ns / 100ps
module sm4_top_axis128 (
    input  wire         clk,
    input  wire         rst,

    input  wire         sm4_vld,
    input  wire [127:0] sm4_key,
    input  wire         sm4_sel, // 0: encrypt, 1: decrypt

    input  wire [127:0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    input  wire         s_axis_tlast,
    output wire         s_axis_tready,

    output wire [127:0] m_axis_tdata,
    output wire         m_axis_tvalid,
    output wire         m_axis_tlast
);
integer i;
reg [3:0]   state;
reg [7:0]   count;
reg         sm4_enable_in;
reg         encdec_enable_in;
reg         encdec_sel_in;
reg         enable_key_exp_in;
reg         user_key_valid_in;
reg [127:0] user_key_in;
wire        key_exp_ready_out;
reg [127:0] sm4_key_d1;

reg [31:0]  tlast;
reg   tready;
assign s_axis_tready = key_exp_ready_out & sm4_enable_in & enable_key_exp_in & encdec_enable_in & tready;
assign m_axis_tlast = tlast[31];

always @(posedge clk or posedge rst) begin: timing_ctrl
    if (rst) begin
        state <= 1;
        count <= 0;
        sm4_enable_in <= 0;
        encdec_enable_in <= 0;
        encdec_sel_in <= sm4_sel;
        sm4_key_d1  <= sm4_key;
        enable_key_exp_in <= 0;
        user_key_valid_in <= 0;
        user_key_in <= 0;
        tready <= 0;
    end else begin
        tlast[0] <= s_axis_tlast;
        for (i = 1; i < 32; i = i + 1) begin
            tlast[i] <= tlast[i-1];
        end
        case (state)
            0: begin // runing state
                if (sm4_vld) begin
                    sm4_enable_in <= 0;
                    encdec_sel_in <= sm4_sel;
                    enable_key_exp_in <= 0;
                    user_key_valid_in <= 0;
                    encdec_enable_in <= 0;
                    sm4_key_d1      <= sm4_key;
                    tready <= 0;
                    state <= 1;
                end
            end
            1: begin // start cfg
                if (count == 32) begin
                    sm4_enable_in <= 1;
                    count <= 0;
                    state <= 2;
                end else begin
                    count <= count + 1;
                end
            end
            2: begin
                state <= 3;
            end
            3: begin
                enable_key_exp_in <= 1;
                state <= 4;
            end
            4: begin
                if (count == 8) begin
                    user_key_valid_in <= 1;
                    user_key_in <= sm4_key_d1;
                    count <= 0;
                    state <= 5;
                end else begin
                    count <= count + 1;
                end
            end
            5: begin
                user_key_valid_in <= 0;
                if (key_exp_ready_out) begin
                    state <= 6;
                end
            end
            6: begin
                if (count == 8) begin
                    encdec_enable_in <= 1;
                    count <= 0;
                    state <= 7;
                end else begin
                    count <= count + 1;
                end
            end
            7: begin
                if (count == 16) begin
                    tready <= 1;
                    count <= 0;
                    state <= 0;
                end else begin
                    count <= count + 1;
                end
            end
            default: ;
        endcase
    end
end

sm4_top sm4_top_inst(
    .clk		         (clk		        ),
    .reset_n	         (~rst   	        ),
    .sm4_enable_in       (sm4_enable_in     ),
    .encdec_enable_in    (encdec_enable_in  ),
    .encdec_sel_in       (encdec_sel_in     ),
    .enable_key_exp_in   (enable_key_exp_in ),
    .user_key_valid_in   (user_key_valid_in ),
    .user_key_in         (user_key_in       ),
    .key_exp_ready_out   (key_exp_ready_out ),
    .valid_in            (s_axis_tvalid & s_axis_tready   ),
    .data_in             (s_axis_tdata      ),
    .ready_out           (m_axis_tvalid     ),
    .result_out          (m_axis_tdata      )
    );

endmodule
