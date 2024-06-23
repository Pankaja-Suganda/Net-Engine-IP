`timescale 1 ns / 1 ps

module net_engine_v1_0_tb;

    // Parameters
    parameter integer C_S00_AXI_DATA_WIDTH   = 32;
    parameter integer C_S00_AXI_ADDR_WIDTH   = 7;
    parameter integer C_S00_AXIS_TDATA_WIDTH = 32;
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32;
    parameter integer C_M00_AXIS_START_COUNT = 32;
    parameter integer C_NET_CELL_COUNT       = 4;

    // Signals
    reg s00_axi_aclk;
    reg s00_axi_aresetn;
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
    reg [2 : 0] s00_axi_awprot;
    reg s00_axi_awvalid;
    wire s00_axi_awready;
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
    reg [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
    reg s00_axi_wvalid;
    wire s00_axi_wready;
    wire [1 : 0] s00_axi_bresp;
    wire s00_axi_bvalid;
    reg s00_axi_bready;
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
    reg [2 : 0] s00_axi_arprot;
    reg s00_axi_arvalid;
    wire s00_axi_arready;
    wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
    wire [1 : 0] s00_axi_rresp;
    wire s00_axi_rvalid;
    reg s00_axi_rready;

    reg s00_axis_aclk;
    reg s00_axis_aresetn;
    wire s00_axis_tready;
    reg [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata;
    reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb;
    reg s00_axis_tlast;
    reg s00_axis_tvalid;

    reg m00_axis_aclk;
    reg m00_axis_aresetn;
    wire m00_axis_tvalid;
    wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata;
    wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb;
    wire m00_axis_tlast;
    reg m00_axis_tready;
    
    wire [31:0] OUT_READ_POINTER;
    wire [31:0] OUT_WRITE_POINTER;
    wire completed;
    wire S_WRITE_COMPLETE;
    wire [2:0] status;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    net_engine_v1_0 # (
        .C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
        .C_S00_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
        .C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
        .C_M00_AXIS_START_COUNT(C_M00_AXIS_START_COUNT),
        .C_NET_CELL_COUNT(C_NET_CELL_COUNT)
    ) uut (
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awprot(s00_axi_awprot),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_awready(s00_axi_awready),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .s00_axi_wready(s00_axi_wready),
        .s00_axi_bresp(s00_axi_bresp),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_arprot(s00_axi_arprot),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_arready(s00_axi_arready),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rresp(s00_axi_rresp),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_rready(s00_axi_rready),
        .s00_axis_aclk(s00_axis_aclk),
        .s00_axis_aresetn(s00_axis_aresetn),
        .s00_axis_tready(s00_axis_tready),
        .s00_axis_tdata(s00_axis_tdata),
        .s00_axis_tstrb(s00_axis_tstrb),
        .s00_axis_tlast(s00_axis_tlast),
        .s00_axis_tvalid(s00_axis_tvalid),
        .m00_axis_aclk(m00_axis_aclk),
        .m00_axis_aresetn(m00_axis_aresetn),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready),
        .S_WRITE_COMPLETE(S_WRITE_COMPLETE),
		.OUT_WRITE_POINTER(OUT_WRITE_POINTER),
		.OUT_READ_POINTER(OUT_READ_POINTER)
    );

    // Clock generation
    always #5 s00_axi_aclk = ~s00_axi_aclk;
    always #5 s00_axis_aclk = ~s00_axis_aclk;
    always #5 m00_axis_aclk = ~m00_axis_aclk;

    initial begin
        // Initialize Inputs
        s00_axi_aclk = 0;
        s00_axi_aresetn = 0;
        s00_axi_awaddr = 0;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 0;
        s00_axi_wdata = 0;
        s00_axi_wstrb = 0;
        s00_axi_wvalid = 0;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;

        s00_axis_aclk = 0;
        s00_axis_aresetn = 0;
        s00_axis_tdata = 0;
        s00_axis_tstrb = 0;
        s00_axis_tlast = 0;
        s00_axis_tvalid = 0;

        m00_axis_aclk = 0;
        m00_axis_aresetn = 0;
        m00_axis_tready = 0;

        // Reset sequence
        #100;
        s00_axi_aresetn = 1;
        s00_axis_aresetn = 1;
        m00_axis_aresetn = 1;

        // Wait for reset to be released
        #100;

        // AXI Slave Write Sequence
//        axi_slave_write(7'd0, 32'hDEADBEEF);
//        axi_slave_write(7'd4, 32'hCAFEBABE);
//        axi_slave_write(7'd8, 32'hF00DBEEF);
//        axi_slave_write(7'd12, 32'hC0FFEE00);
//        axi_slave_write(7'd16, 32'hBAADF00D);
//        axi_slave_write(7'd20, 32'hFACEFEED);
//        axi_slave_write(7'd24, 32'h12345678);
//        axi_slave_write(7'd28, 32'h87654321);

        // AXI Slave Read Sequence
//        axi_slave_read(7'd0);
//        axi_slave_read(7'd4);
//        axi_slave_read(7'd8);
//        axi_slave_read(7'd12);
//        axi_slave_read(7'd16);
//        axi_slave_read(7'd20);
//        axi_slave_read(7'd24);
//        axi_slave_read(7'd28);

        // AXIS Write Sequence (8 data points)
//        s00_axis_tvalid = 1;
//        axis_slave_write(32'hAAAAAAAA);
//        axis_slave_write(32'hBBBBBBBB);
//        axis_slave_write(32'hCCCCCCCC);
//        axis_slave_write(32'hDDDDDDDD);
//        axis_slave_write(32'hEEEEEEEE);
//        axis_slave_write(32'hFFFFFFFF);
//        axis_slave_write(32'h11111111);
//        axis_slave_write(32'h22222222);
//        axis_slave_write(32'h33333333);
//        axis_slave_write(32'h44444444);
//        axis_slave_write(32'h55555555);
//        axis_slave_write(32'h66666666);
//        axis_slave_write(32'h77777777);
//        axis_slave_write(32'h88888888);
//        axis_slave_write(32'h99999999);
//        axis_slave_write(32'h55555555);
//        axis_slave_write(32'h66666666);
//        axis_slave_write(32'h77777777);
//        axis_slave_write(32'h88888888);
//        axis_slave_write(32'h99999999);
//        s00_axis_tvalid = 0;

        s00_axis_tvalid = 1;
        for ( i = 0; i < (C_NET_CELL_COUNT * 9) + 2; i = i + 1) begin
            axis_slave_write({i, 24'h0});
        end
        s00_axis_tvalid = 0;

        // AXIS Read Sequence (8 data points)
        #200
        m00_axis_tready = 1;
        
        #200
        
        s00_axis_tvalid = 1;
        for ( i = 10; i < (C_NET_CELL_COUNT * 9) + 2 + 10; i = i + 1) begin
            axis_slave_write({i, 24'h0});
        end
        s00_axis_tvalid = 0;

        // AXIS Read Sequence (8 data points)
        #200
        m00_axis_tready = 1;
        
        // End simulation
        #100;
        $stop;
    end

    // AXI Slave Write Task
    task axi_slave_write(input [C_S00_AXI_ADDR_WIDTH-1:0] addr, input [C_S00_AXI_DATA_WIDTH-1:0] data);
        begin
            @(posedge s00_axi_aclk);
            s00_axi_awaddr = addr;
            s00_axi_awvalid = 1;
            s00_axi_wdata = data;
            s00_axi_wvalid = 1;
            s00_axi_wstrb = 4'b1111;
            wait (s00_axi_awready && s00_axi_wready);
            s00_axi_awvalid = 0;
            s00_axi_wvalid = 0;
            wait (s00_axi_bvalid);
            s00_axi_bready = 1;
            @(posedge s00_axi_aclk);
            s00_axi_bready = 0;
        end
    endtask

    // AXI Slave Read Task
    task axi_slave_read(input [C_S00_AXI_ADDR_WIDTH-1:0] addr);
        begin
            @(posedge s00_axi_aclk);
            s00_axi_araddr = addr;
            s00_axi_arvalid = 1;
            wait (s00_axi_arready);
            s00_axi_arvalid = 0;
            wait (s00_axi_rvalid);
            s00_axi_rready = 1;
            @(posedge s00_axi_aclk);
            $display("Read data from address %h: %h", addr, s00_axi_rdata);
            s00_axi_rready = 0;
        end
    endtask

    // AXIS Slave Write Task
    task axis_slave_write(input [C_S00_AXIS_TDATA_WIDTH-1:0] data);
        begin
            @(posedge s00_axis_aclk);
            s00_axis_tdata = data;
            s00_axis_tstrb = 4'b1111;
            s00_axis_tlast = 0;
            wait (s00_axis_tready);
            s00_axis_tstrb = 0;
        end
    endtask

endmodule
