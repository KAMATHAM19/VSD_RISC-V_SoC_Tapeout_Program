# RTL Design and Synthesis
  
<details>
  <summary>Day 1: Introduction to Verilog RTL design and Synthesis</summary>
  
## Verilog Simulation Basics

### Key Terms

- **Simulator**  
  A tool used to check the design.  
  In this case, we are using **Icarus Verilog (iverilog)** as the simulator.

- **Design**  
  The actual Verilog code (or codes) that implements the intended functionality to meet the given specifications.

- **Testbench**  
  A setup written in Verilog to apply stimulus (test vectors) to the design to verify its functionality.

### How the Simulator Works

1. The simulator continuously monitors the **input signals**.  
2. Whenever there is a **change in the input values**, the simulator re-evaluates the design.  
3. If there is **no change in inputs**, there will be **no change in outputs**.  
4. This process ensures that the outputs always reflect the latest input conditions.

<img width="1344" height="768" alt="image" src="https://github.com/user-attachments/assets/ac12d53c-eb32-4003-9515-6147062ecfaa" />

## Iverilog-based Simulation Flow

1. **Write the Design (RTL Module)**  
   - Create the Verilog file that describes the actual logic (your design).

2. **Write the Testbench**  
   - Create another Verilog file that gives input values (test vectors) to the design and checks the outputs.

3. **Compile with iverilog**  
   - Use the `iverilog` tool to compile both the design and testbench.  
   - This generates a **simulation executable** file.

4. **Run the Simulation**  
   - Execute the simulation file.  
   - It produces a **VCD file** (Value Change Dump) that records all signal changes over time.

5. **View with GTKWave**  
   - Open the VCD file in **GTKWave** (a waveform viewer).  
   - This lets you **see the signals as waveforms** and verify if the design works as expected.

> In short: **Design + Testbench → Compile → Run → VCD → View in GTKWave**

<img width="1536" height="672" alt="image" src="https://github.com/user-attachments/assets/5a74fae9-3c1b-4d2c-88b8-2d38c828302a" />

## Lab 1: Introduction

In this lab, we will begin by cloning the required GitHub repository that contains all the design files and resources for the workshop.

### Clone the Repository

```bash
git clone https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
cd sky130RTLDesignAndSynthesisWorkshop/
ls
```
<img width="927" height="429" alt="image" src="https://github.com/user-attachments/assets/f99b4c1f-7243-4a77-a2ac-d214a2b2f955" />

## Lab 2: Introduction to Verilog and GTKWave

### Running Verilog Design and Testbench
#### Step 1: Prepare the Files
- **Design file** → contains the RTL (e.g., `design.v`)  
- **Testbench file** → applies inputs and checks outputs (e.g., `testbench.v`)  
Both files are needed to run a simulation.
#### Step 2: Compile with Icarus Verilog
Use the following command:
```bash
iverilog design.v testbench.v
```
#### Step 3: Run the Simulation
Execute the compiled file:
```
./a.out
```
#### Step 4: View with GTKWave
Open the VCD file in GTKWave to see the waveforms:
```
gtkwave dump.vcd
```
### multiplexer

```
gvim good_mux.v -o tb_good_mux.v
```
<img width="921" height="406" alt="image" src="https://github.com/user-attachments/assets/0a011603-c4b1-4aad-952e-b17535f21b48" />

#### Truth Table for `good_mux` (2:1 Multiplexer)

The design selects one of the two inputs (`i0` or `i1`) based on the value of the select signal `sel`.

| sel | i0 | i1 | y |
|:---:|:--:|:--:|:-:|
|  0  |  0 |  0 | 0 |
|  0  |  0 |  1 | 0 |
|  0  |  1 |  0 | 1 |
|  0  |  1 |  1 | 1 |
|  1  |  0 |  0 | 0 |
|  1  |  0 |  1 | 1 |
|  1  |  1 |  0 | 0 |
|  1  |  1 |  1 | 1 |

#### Explanation
- When **`sel = 0`**, output `y` follows **`i0`**.  
- When **`sel = 1`**, output `y` follows **`i1`**.

```bash
iverilog good_mux.v tb_good_mux.v
./a.out
gtkwave tb_good_mux.vcd
```
<img width="925" height="372" alt="image" src="https://github.com/user-attachments/assets/25c90316-6a09-4507-9a89-fba29e352569" />

<img width="926" height="283" alt="image" src="https://github.com/user-attachments/assets/28b8a8c8-767b-4cf9-9530-5f57108481d8" />

## Introduction to Yosys

- **Synthesizer**  
  A tool that converts RTL (Verilog/VHDL) designs into a **netlist**, which is a gate-level representation of the circuit.

- **Yosys**  
  The synthesizer tool we are using in this lab.  
  It takes your **RTL code** as input and generates the corresponding **netlist**.

  <img width="2048" height="512" alt="image" src="https://github.com/user-attachments/assets/dd0a9b1d-9fd3-46eb-a657-84168c96ec20" />

### Yosys Setup
<img width="1408" height="736" alt="image" src="https://github.com/user-attachments/assets/7ea9d8f8-1a1b-4b5d-b8ef-4097109e4b95" />

### Verify the Synthesis
<img width="1536" height="672" alt="image" src="https://github.com/user-attachments/assets/cea5f989-1ce0-4274-a1a7-01f6cf53af24" />


## RTL Design and Synthesis
1. RTL Design

- RTL (Register Transfer Level) describes the behaviour of a digital circuit based on the given specification.
- It focuses on what the circuit should do (not how it is physically built).
- Written in HDL (Hardware Description Language) like Verilog or VHDL.

Example:

Here’s a simple 2-input AND gate in Verilog (behavioural representation):

```verilog
module and_gate (
    input  wire a, 
    input  wire b,
    output wire y
);
    assign y = a & b;   // behavior: y is AND of a and b
endmodule
```

2. Synthesis

- Synthesis is the process of converting RTL code → Gate-level representation.
- The design is mapped into logic gates and connections.
- The output of synthesis is a netlist (a text file showing gates and their interconnections).

3. Standard Cell Library (.lib)

- A .lib file contains a collection of standard logic modules (gates).

- Examples: AND, OR, NOT, Flip-Flops, etc.

- Each gate can have multiple versions (called flavours), depending on speed and power.

Example:

For a 2-input AND gate, the library may provide:
```
AND2_X1 → slow

AND2_X2 → typical/moderate

AND2_X4 → fast 
```

### Why We Need Different Flavours of Cells (Slow vs Fast)

- In digital design, it’s not enough for a circuit to work — it must also run reliably and at the right speed.
- To achieve this, designers use both slow cells and fast cells, depending on the timing needs of the circuit.

1. Slow Cells – Fixing Hold Problems

Consider two flip-flops with logic in between:

<img width="1632" height="640" alt="image" src="https://github.com/user-attachments/assets/e4c2c4d1-29b3-4ec5-993e-54fe30bc4131" />

On a clock edge, DFF A launches data.

That data passes through the logic (COMBI) before reaching DFF B.

If the logic is too fast, the data may reach DFF B too early, before its hold time has passed.
This causes a hold violation (wrong data captured).

To fix this, we use slow cells, which add delay to the path.

Hold condition :
```
T_HOLD_B < T_CQ_A + T_COMBI

Where:

T_HOLD_B = Hold time of DFF B

T_CQ_A = Clock-to-Q delay of DFF A

T_COMBI = Delay through the logic
```
> If this condition is not met, slow cells are needed.

2. Fast Cells – Improving Speed

While slow cells fix hold problems, they also make the circuit slower.
To achieve higher performance, we use fast cells.

Setup condition at DFF B:

```
T_CLK > T_CQ_A + T_COMBI + T_SETUP_B

Where:

T_CLK = Clock period

T_SETUP_B = Setup time of DFF B
```
> If the logic (T_COMBI) is too slow, the clock must run slower, which reduces performance.
> By using fast cells, we reduce delay and allow the circuit to run at higher clock speeds.

Maximum frequency of the design:
```
f_CLK_max = 1 / T_CLK_min
```
> Smaller T_COMBI → Smaller T_CLK_min → Higher f_CLK_max.

3. Summary

- Slow cells → Add delay to fix hold violations.

- Fast cells → Reduce delay to fix setup violations and improve speed.

- A standard cell library (.lib) provides multiple versions of each gate (slow, typical, fast), so designers can mix and match depending on timing needs.

## Faster Cells vs Slower Cells

In digital circuits, the **load** mainly comes from **capacitance**.  
The time needed to **charge or discharge this capacitance** defines the **cell delay**.

- **Faster charging/discharging** → **Smaller delay** (faster cell)  
- **Slower charging/discharging** → **Larger delay** (slower cell)  

### Key Points

- To charge/discharge capacitance quickly, transistors must supply **more current**.  
- This is controlled by **transistor width**:
  - **Wider transistors** → Lower delay → **More area and higher power**  
  - **Narrow transistors** → Higher delay → **Less area and lower power**  

### Comparison Table

| Feature          | Fast Cells (Wider Transistors)       | Slow Cells (Narrow Transistors)    |
|------------------|--------------------------------------|------------------------------------|
| **Delay**        | Low (fast switching)                | High (slower switching)            |
| **Area**         | Large                               | Small                              |
| **Power**        | High                                | Low                                |
| **Usage**        | Critical timing paths               | Non-critical paths                 |
| **Advantage**    | Improves performance (speed)        | Saves area and power               |
| **Disadvantage** | Costly in area and power consumption | Increases delay (slower operation) |


### Summary

- **Fast cells** → Used for **critical paths** to meet timing.  
- **Slow cells** → Used for **non-critical paths** to reduce area and power.  

#### Synthesis illustration

<img width="984" height="805" alt="113" src="https://github.com/user-attachments/assets/a4657f25-a4d5-49a6-af26-870ff06afaf7" />

## Lab 3: Yosys good mux

### Steps to Run Synthesis

### Step 0: Start Yosys
```bash
yosys
```
<img width="928" height="128" alt="image" src="https://github.com/user-attachments/assets/f5dee0a1-7ab5-4a57-8a95-065aa36d5dc9" />

### Step 1: Load the Standard Cell Library

The Liberty file (.lib) contains the timing and logic information of the Sky130 standard cells.
We need it so Yosys can map our RTL design to real technology cells.

```
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
<img width="924" height="78" alt="image" src="https://github.com/user-attachments/assets/b43c7a9e-59ab-4d44-8396-8018dffea192" />

### Step 2: Read the RTL Verilog File

Load your RTL design (good_mux.v)

```
read_verilog good_mux.v
```
<img width="920" height="98" alt="image" src="https://github.com/user-attachments/assets/33a725a7-5846-489d-bf51-ce0bccc1da40" />

- technology independent 
<img width="925" height="415" alt="image" src="https://github.com/user-attachments/assets/6dd65624-b3da-4aac-8540-477f21ad6e89" />


### Step 3: Synthesise the Top Module

Convert the RTL design into a technology-independent netlist.
Here, the top module is good_mux.
```
synth -top good_mux
```
<img width="928" height="300" alt="image" src="https://github.com/user-attachments/assets/24434893-72ab-4e8c-b697-9c575101a053" />
<img width="923" height="372" alt="image" src="https://github.com/user-attachments/assets/d51f789a-0700-4583-b164-5a91ef8daa64" />

### Step 4: Map to Standard Cells

Now map the synthesised netlist to actual Sky130 standard cells (defined in the Liberty file).
This produces a technology-dependent netlist.

```
abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
<img width="928" height="262" alt="image" src="https://github.com/user-attachments/assets/aa83f907-5411-482f-b615-7124fe91cf39" />
<img width="926" height="77" alt="image" src="https://github.com/user-attachments/assets/a04d503a-c3c8-49d0-ac1a-fa5f5fa62699" />

### Step 5: View the Netlist as a Schematic

Visualise the synthesised circuit as a schematic diagram.
```
show
```
<img width="924" height="395" alt="image" src="https://github.com/user-attachments/assets/9ed88b20-8e4e-4332-b077-095600f49bb0" />

### Step 6: Write the Gate-Level Netlist

Finally, export the gate-level netlist to a Verilog file.

The `-noattr` option removes extra attributes, making the file easier to read.

```
write_verilog -noattr good_mux_netlist.v
```

```verilog
/* Generated by Yosys 0.51+17 (git sha1 e44d1d404, g++ 9.4.0-1ubuntu1~20.04.2 -fPIC -O3) */

module good_mux(i0, i1, sel, y);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input i0;
  wire i0;
  input i1;
  wire i1;
  input sel;
  wire sel;
  output y;
  wire y;
  sky130_fd_sc_hd__mux2_1 _4_ (
    .A0(_0_),
    .A1(_1_),
    .S(_2_),
    .X(_3_)
  );
  assign _0_ = i0;
  assign _1_ = i1;
  assign _2_ = sel;
  assign y = _3_;
endmodule
```
</details>

<details>
  <summary>Day 2: Timing libs, hierarchical vs flat synthesis and efficient flop coding styles</summary>


































</details>
