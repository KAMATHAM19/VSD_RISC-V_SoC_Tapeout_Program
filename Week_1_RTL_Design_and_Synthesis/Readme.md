
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













</details>
