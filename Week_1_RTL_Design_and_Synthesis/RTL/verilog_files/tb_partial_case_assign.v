`timescale 1ns / 1ps

module tb_partial_case_assign;
    // Inputs
    reg i0, i1, i2;
    reg [1:0] sel;   // FIXED: sel is 2 bits
    reg clk, reset;

    // Outputs
    wire x, y;

    // Instantiate the Unit Under Test (UUT)
    partial_case_assign uut (
        .sel(sel),
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .x(x),
        .y(y)
    );

    initial begin
        $dumpfile("tb_partial_case_assign.vcd");
        $dumpvars(0, tb_partial_case_assign);

        // Initialize Inputs
        i0 = 1'b0;
        i1 = 1'b0;
        i2 = 1'b0;
        clk = 1'b0;
        reset = 1'b0;
        sel = 2'b00;

        #1  reset = 1'b1;
        #10 reset = 1'b0;

        #5000 $finish;
    end

    // Stimulus
    always #317 i0 = ~i0;
    always #37  i1 = ~i1;
    always #57  i2 = ~i2;
    always #600 clk = ~clk;

    // sel counter logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            sel <= 2'b00;
        else
            sel <= sel + 1;
    end
endmodule

