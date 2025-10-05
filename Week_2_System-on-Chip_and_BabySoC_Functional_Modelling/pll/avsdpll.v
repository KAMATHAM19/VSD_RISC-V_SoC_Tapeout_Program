`timescale 1ns / 1ps
module avsd_pll_1v8 (
    output reg CLK,
    input      VCO_IN,
    input      VDDA,
    input      VDDD,
    input      VSSA,
    input      VSSD,
    input      EN_VCO,
    input      REF
);
    real period, lastedge, refpd;

    initial begin
        lastedge = 0.0;
        period   = 25.0; // Default: 25ns period = 40 MHz
        CLK      = 1'b0;
    end

    // VCO clock generation loop
    always begin
        if (EN_VCO) begin
            #(period / 2.0) CLK = ~CLK;
        end else begin
            CLK = 1'b0;
            @(posedge EN_VCO); // Wait until re-enabled
        end
    end

    // Measure REF period and adjust VCO
    always @(posedge REF) begin
        if (lastedge > 0.0) begin
            refpd  = $realtime - lastedge;
            period = refpd / 8.0; // Target: 8× REF frequency
        end
        lastedge = $realtime;
    end
endmodule

