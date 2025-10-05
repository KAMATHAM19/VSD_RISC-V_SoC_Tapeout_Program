`timescale 1ns / 1ps
module avsdpll_tb;
    // Digital controls
    reg EN_VCO;
    reg REF;
    reg VCO_IN;

    // Power rails (kept as simple regs for simulation)
    reg VDDA, VDDD, VSSA, VSSD;

    wire CLK;

    avsd_pll_1v8 dut (
        .CLK(CLK),
        .VCO_IN(VCO_IN),
        .VDDA(VDDA),
        .VDDD(VDDD),
        .VSSA(VSSA),
        .VSSD(VSSD),
        .EN_VCO(EN_VCO),
        .REF(REF)
    );

    // Generate REF clock (e.g., 10 MHz = 100 ns period)
    initial begin
        REF = 0;
        forever #50 REF = ~REF; // 100 ns period
    end

    // Simulate VCO input signal
    initial begin
        VCO_IN = 0;
        forever #(83.33/2) VCO_IN = ~VCO_IN; // ~6 MHz example
    end

    initial begin
        VDDA = 1;  // tie to logic high
        VDDD = 1;
        VSSA = 0;
        VSSD = 0;

        EN_VCO = 0;
        #100 EN_VCO = 1;   // Enable VCO
        #2000 EN_VCO = 0;  // Disable for a while
        #200 EN_VCO = 1;   // Re-enable
        #2000 $finish;
    end

    initial begin
         $dumpfile("avsdpll_tb_test.vcd");
        $dumpvars(0,avsdpll_tb);
    end
endmodule

