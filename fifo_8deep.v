module fifo_8deep (
    input        clk, rst,
    input        wr_en, rd_en,
    input  [7:0] din,
    output [7:0] dout,
    output       full, empty
);
    reg [7:0] mem [0:7];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count;

    assign full  = (count == 8);
    assign empty = (count == 0);
    assign dout  = mem[rd_ptr];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0; rd_ptr <= 0; count <= 0;
        end else begin
            if (wr_en && !full && rd_en && !empty) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                rd_ptr <= rd_ptr + 1;
                // count stays the same
            end else if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end else if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end
endmodule
