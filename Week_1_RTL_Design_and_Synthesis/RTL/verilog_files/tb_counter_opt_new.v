`timescale 1ns/1ps

module tb_counter_opt;

  // Testbench signals
  reg clk;
  reg reset;
  wire q;

  // Internal signal visibility (hierarchical reference)
  wire [2:0] count;
  assign count = uut.count;   // expose DUT internal reg for waveform

  // Instantiate the DUT
  counter_opt uut (
    .clk(clk),
    .reset(reset),
    .q(q)
  );

  // Clock generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 5ns high, 5ns low → 100MHz clock
  end

  // Stimulus
  initial begin
    // Apply reset at start
    reset = 1;
    #12;        // hold reset a bit longer than one clock
    reset = 0;

    // Let it run for a while
    #200;

    // Apply reset again mid-count
    reset = 1;
    #10;
    reset = 0;

    // Run more
    #200;

    // End simulation
    $finish;
  end

  // Console monitor
  initial begin
    $monitor("Time=%0t | reset=%b | count=%b | q=%b",
             $time, reset, count, q);
  end

  // Dump VCD for GTKWave
  initial begin
    $dumpfile("tb_counter_opt.vcd");
    $dumpvars(0, tb_counter_opt);
  end

endmodule

