`timescale 1ns/1ps
module tb_fifo_8deep;
    reg        clk, rst, wr_en, rd_en;
    reg  [7:0] din;
    wire [7:0] dout;
    wire       full, empty;

    fifo_8deep dut(.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),
                   .din(din),.dout(dout),.full(full),.empty(empty));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(0, tb_fifo_8deep);
        clk=0; rst=1; wr_en=0; rd_en=0; din=0;
        #10 rst=0;

        // Write 8 entries -> full
        repeat(8) begin
            @(posedge clk); #1; wr_en=1; din=din+1;
        end
        @(posedge clk); #1; wr_en=0;
        $display("At %t: full=%b (expect 1)", $time, full);

        // Read 8 entries -> empty
        repeat(8) begin
            @(posedge clk); #1; rd_en=1;
            $display("At %t: dout=%d", $time, dout);
        end
        @(posedge clk); #1; rd_en=0;
        $display("At %t: empty=%b (expect 1)", $time, empty);

        #20 $finish;
    end
endmodule
