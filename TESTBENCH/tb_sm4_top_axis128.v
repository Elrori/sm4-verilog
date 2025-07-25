`timescale 1ns / 100ps
module sm4_top_axis128_tb;

    // Parameters

    //Ports
    reg  clk=0;
    reg  rst=1;
    reg  sm4_vld=0;
    reg [127:0] sm4_key=128'h0123456789abcdeffedcba9876543210;
    reg  sm4_sel=0;
    reg [127:0] s_axis_tdata=0;
    reg  s_axis_tvalid=0;
    reg  s_axis_tlast=0;
    wire  s_axis_tready;
    wire [127:0] m_axis_tdata;
    wire  m_axis_tvalid;
    wire  m_axis_tlast;

    sm4_top_axis128  sm4_top_axis128_inst (
        .clk(clk),
        .rst(rst),
        .sm4_vld(sm4_vld),
        .sm4_key(sm4_key),
        .sm4_sel(sm4_sel),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tready(s_axis_tready),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tlast(m_axis_tlast)
    );

    task gen_axis;
        input string filename;
        integer i;
        integer num_bytes_read;
        reg [127:0]pkg[0:2047];
        begin
            for (i = 0; i < 2048; i = i + 1) begin
            pkg[i] = 128'bx;
            end
            $readmemh(filename,pkg);
            num_bytes_read = 0;
            for (i = 0; i < 2048; i = i + 1) begin
                if (pkg[i] !== 128'bx) begin
                    num_bytes_read = num_bytes_read + 1;
                end
            end
            for (i = 0;i<num_bytes_read ;i=i+1 ) begin
                s_axis_tvalid = 1;
                s_axis_tdata  = pkg[i];
                if (i==num_bytes_read - 1) begin
                    s_axis_tlast=1;
                end
                @(posedge clk) #0;
                while (!s_axis_tready) begin
                    @(posedge clk) #0;
                end            
            end
            s_axis_tlast =0;
            s_axis_tvalid  =0;
            s_axis_tdata   =128'd0;
        end
    endtask

    task change;
        input sel; // 0: encrypt, 1: decrypt
        input [127:0] key;
        begin
            @(posedge clk);
            sm4_vld = 1;
            sm4_key = key;
            sm4_sel = sel;
            @(posedge clk);
            sm4_vld = 0;
        end
    endtask

    always #5  clk = ! clk ;
    always @(posedge clk) begin
        if (m_axis_tvalid) begin
            $display("%h", m_axis_tdata);
        end
    end
    initial begin
        #100;
        rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        gen_axis("input.txt");
        change(1,128'h0123456789abcdeffedcba9876543210);
        gen_axis("input2.txt");

        #1000;
        $stop;
    end

endmodule