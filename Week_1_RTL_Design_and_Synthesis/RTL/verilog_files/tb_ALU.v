
module ALU16bit_tb;

reg clk;
reg [2:0] Opcode;
reg [15:0] Operand1;
reg [15:0] Operand2;

wire [15:0] Result;
wire flagC;
wire flagZ;

// Instantiate the ALU with clk
ALU16bit uut (
    .clk(clk),
    .Opcode(Opcode),
    .Operand1(Operand1),
    .Operand2(Operand2),
    .Result(Result),
    .flagC(flagC),
    .flagZ(flagZ)
);

// Clock generation
   	 always begin
        	#5 clk = ~clk; // Clock period 10 time units
    	end


// Stimulus block
initial begin
        $dumpfile("tb_ALU.vcd");
	$dumpvars(0,ALU16bit_tb);
end

initial begin
    // Initial value
	clk = 0;
        Operand1 = 16'h0000;
        Operand2 = 16'h0000;
        #10;
   

  // Test case
        #10 Operand1 = 16'h0003; Operand2 = 16'h0001; Opcode = 3'b000; 
        #10 Operand1 = 16'h0004; Operand2 = 16'h0002; Opcode = 3'b001; 
        #10 Operand1 = 16'h0005; Operand2 = 16'h0006; Opcode = 3'b010; 
        #10 Operand1 = 16'h1010; Operand2 = 16'h0101; Opcode = 3'b011; 
        #10 Operand1 = 16'h0101; Operand2 = 16'h1010; Opcode = 3'b100; 
        #10 Operand1 = 16'h1010; Operand2 = 16'h0101; Opcode = 3'b101; 
        #10 Operand1 = 16'h0101; Operand2 = 16'h1010; Opcode = 3'b110; 
        #10 Operand1 = 16'h0111; Operand2 = 16'h0001; Opcode = 3'b111;  
        #50 $finish;
    end
	initial begin
        $display("Opcode: %b | A: %h | B: %h | Result: %h | Carry: %b | Zero: %b",
                 Opcode, Operand1, Operand2, Result, flagC, flagZ);
    end

endmodule

