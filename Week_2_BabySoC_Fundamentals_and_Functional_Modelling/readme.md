# System-on-Chip and BabySoC Functional Modelling

## System-on-Chip (SoC): Architecture, Design, Challenges, and Applications

### Abstract

A System-on-Chip (SoC) is a single chip that combines a complete electronic system, including processors, memory, interconnects, analogue/mixed-signal components, and peripherals. Compared to multi-chip systems, SoCs are smaller, cheaper, faster, and more energy-efficient. This repo provides an overview of SoC basics, types, architecture, design flow, verification methods, challenges, emerging trends, and applications. A case study of VSDBabySoC, a small RISC-V-based open-source SoC, demonstrates practical design and verification techniques.


### I. Introduction

A System-on-Chip (SoC) integrates computing, communication, and control on a single chip. Typical components include a processor, memory, hardware accelerators, analog/RF interfaces, and input/output (I/O) peripherals [1][2].

SoCs are popular due to:
- Higher integration and smaller chip size.
- Reuse of pre-designed IP blocks.
- Faster development and support for product variants using platform-based design [2].

<img width="980" height="921" alt="soc im1" src="https://github.com/user-attachments/assets/fa3b2f33-7ec4-4b4b-b413-97e75f0a0615" />



### II. Key Parts of an SoC 

| Component        | Function                                                                                   |
|-----------------|--------------------------------------------------------------------------------------------|
| CPU             | The brain of the SoC; executes instructions and handles data processing.                   |
| Memory          | RAM for temporary storage, ROM/Flash for permanent storage.                                 |
| I/O Ports       | Connects the SoC to external devices like cameras, USBs, or headphones.                    |
| GPU             | Handles graphics and visuals for games, videos, or other visual tasks.                     |
| DSP             | Specialised for audio/video processing (e.g., noise reduction or video enhancement).       |
| Power Management| Controls energy usage and extends battery life.                                             |
| Special Features| Optional modules like Wi-Fi, Bluetooth, and security, depending on the application.            |

*Note: Data for this table adapted from [13].*

### III. Main SoC Types

1) **General-purpose/Mobile SoCs**: CPU, GPU, ISP, connectivity, and power management; used in smartphones and tablets [3].

2) **Heterogeneous/MPSoCs**: Multiple core types (CPU, DSP, ASIP, accelerators) for parallel workloads [4].

3) **Mixed-Signal SoCs**: Combine digital cores with analogue IPs (PLLs, ADC/DACs, sensors); need careful design [5][6].

4) **Chiplet-based SoCs**: Multiple small dies in one package; improve yield and support AI/IoT [7].

<img width="1024" height="478" alt="soc 1" src="https://github.com/user-attachments/assets/a9111f0d-bce7-45f9-a180-00106ac77ce6" />




###  IV. Architecture and Interconnects

SoC design uses platform-based architecture, where cores, buses, and memory form a fixed kernel, and additional IP blocks are added around it [2]. Traditional buses struggle with many cores; Networks-on-Chip (NoC) provide distributed routing and arbitration for higher bandwidth and scalability [4].

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/15f80728-dbcf-482c-ad40-a4fca483ca0f" />


### V. Design Flow and IP Reuse

Modern SoCs reuse IP blocks at higher levels (interfaces, codecs, memory). Software is integrated early with APIs and RTOS support [2]. Analogue IP hardening converts behavioural models into manufacturable layouts, ensuring reuse across technology nodes [5].

<img width="1024" height="1024" alt="flow1" src="https://github.com/user-attachments/assets/3aff467a-87b4-4e9a-bb45-42fddeb13ecc" />


### VI. Verification and Sign-Off

Verification ensures correct SoC operation. Mixed-signal SoCs require:
- Verilog-AMS and real-number modelling
- Connectivity validation
- Power-intent verification (CPF/UPF)
- Selective transistor-level simulations [6]
Hierarchical testbenches and reusable strategies help cover multiple products and mixed-power domains [2].

### VII. Key Challenges

- **Power and Thermal Management**: DVFS, clock/power gating, thermal-aware design [1][3].
- **Interconnect Latency**: On-chip memory, NoC, and floorplanning [1].
- **Variability and Reliability**: Error-tolerant design to counter process variations and ageing [1].
- **Verification and Testing***: Complex multi-power and mixed-signal designs need advanced testing [6].

### VIII. Emerging Directions

- **Open-Source SoC Tools**: FASoC automates analogue IP generation and digital integration [8].
- **Chiplets and Advanced Packaging**: 2.5D/3D integration allows modular, fast SoC designs [7].
- **Education**: Engineers need cross-disciplinary skills in HW/SW/AMS/RF design [9].

### IX. Representative Applications

- **Consumer Devices**: Smartphones, tablets, wearables [3].
- **IoT/Embedded Systems**: Low-power RISC-V SoCs for sensors [10].
- **Healthcare**: Implantables, diagnostics, secure telemedicine devices [11].
- **Industrial/Automotive Systems**: Control systems, ADAS, and safety-critical applications [6].

### X. Case Study: VSDBabySoC

The VSDBabySoC is a small yet powerful RISC-V-based SoC designed primarily to test three open-source IP cores together for the first time and calibrate the analogue portions of the system. Despite its modest size, this SoC demonstrates critical design and verification practices for educational and research purposes [12]. This SoC illustrates practical applications of key SoC concepts, including IP reuse, integration of analogue and digital components, low-power design techniques, and verification workflows. Built using Sky130 technology, the VSDBabySoC is fully open-source and well-documented, which makes it ideal for teaching, research, and prototyping.

Key Features:
- **Processor**: RVMYTH microprocessor (lightweight RISC-V core)
- **Clock Generator**: 8x PLL for stable timing
- **Analogue Interface**: 10-bit DAC for audio/video output
- **Memory**: On-chip SRAM and ROM
- **Peripherals**: UART, GPIO, SPI
- **Power Optimisation**: Clock/power gating for microwatt-level operation
- **Verification**: RTL and mixed-signal AMS simulation

<img width="2270" height="1260" alt="vsdbabysoc_block_diagram" src="https://github.com/user-attachments/assets/d3501270-7d19-4b3a-97f3-ddad5ec6d800" />

**Discussion**: The VSDBabySoC uses a Phase-Locked Loop (PLL) as its clock generator and controller, along with a DAC for analogue output. This design shows how a small, open-source SoC can connect digital and analogue domains, providing a hands-on platform for learning mixed-signal SoC design in practical and educational settings.

### XI. Takeaways for Practitioners

- Choose SoC type and interconnect based on workload, scalability, and power [4][7].
- Integrate analogue IP early with reusable models [5].
- Use comprehensive verification for multi-power and mixed-signal designs [6].
- Explore automation and open-source frameworks for edge-focused SoCs [8].

### References

[1] A. Chopde et al., “System On Chip Design Challenges and its Solutions,” Proc. IEEE sources cited within, 2024.

[2] G. Martin and H. Chang, “System-on-Chip Design,” IEEE Tutorial Paper, 2001.

[3] M. Gupta et al., “Comprehensive Analysis of System on Chips: Architecture, Applications, and Future Trends,” preprint, 2024.

[4] D. N. Kumar and G. Mohan, “Design and Optimization of System-on-chip (SOC),” JETIR, 2015.

[5] M. Hamour et al., “Analog IP Design Flow for SoC Applications,” IEEE, 2003.

[6] C. Liang, “Mixed-Signal Verification Methods for Multi-Power Mixed-Signal SoC Design,” IEEE, 2013.

[7] M. P. C. Mok et al., “Chiplet-based System-on-Chip for Edge Artificial Intelligence,” IEEE EDTM, 2021.

[8] T. Ajayi et al., “An Open-source Framework for Autonomous SoC Design with Analog Block Generation,” IFIP/IEEE VLSI-SoC, 2020.

[9] H. De Man, “System-on-chip design: impact on education and research,” IEEE Design & Test of Computers, 1999.

[10] R. Serrano et al., “A Low-Power Low-Area SoC based in RISC-V Processor for IoT Applications,” ISOCC, 2021.

[11] W. Y. Leong et al., “System-on-Chip (SoC) Medicine,” IEEE Int. Workshop on Electromagnetics Applications and Student Innovation Competition (iWEM), 2024.

[12] M. Manili, "VSDBabySoC: A small mixed-signal SoC including PLL, DAC, and a RISCV-based processor named RVMYTH," GitHub, Available: https://github.com/manili/VSDBabySoC
. Accessed: Oct. 4, 2025.

[13] H. Kumar DM, "11. Fundamentals of SoC Design," SFAL-VSD-SoC-Journey, GitHub, Available: https://github.com/hemanthkumardm/SFAL-VSD-SoC-Journey/tree/main/11.%20Fundamentals%20of%20SoC%20Design
. Accessed: Oct. 4, 2025.


## BabySoC Functional Modelling

VSDBabySoC is a small but powerful System on Chip (SoC) based on the RISC-V design. It was created to test three open-source IP cores at the same time and to fine-tune its analog components. The SoC includes an RVMYTH processor, an 8x phase-locked loop (PLL) to create a stable clock, and a 10-bit DAC (digital-to-analog converter) that allows it to work with analog devices.

### 1. RISC-V Core (rvmyth)

RVMYTH is the main CPU of BabySoC. It uses a register called **r17** to store values sent to the DAC. As it runs, `r17` is continuously updated, producing a steady stream of data for analogue conversion. RVMYTH outputs a **10-bit digital signal (OUT)** for the DAC.

You can find the module on GitHub: [rvmyth](https://github.com/kunalg123/rvmyth/)

 <img width="940" height="478" alt="rvmyth" src="https://github.com/user-attachments/assets/1b754272-7fd0-4bf7-9528-c07b429e725a" />

### 2. Phase-Locked Loop

A **PLL (Phase-Locked Loop)** creates a clean and steady clock by copying the timing of a known reference and continuously adjusting itself to stay in sync.

<img width="1024" height="474" alt="pllb" src="https://github.com/user-attachments/assets/ad43eb4e-363f-4b06-92ae-f36fb04af233" />

#### How It Works

1. **Compare:**  
   A **phase/frequency detector (PFD)** checks how the PLL’s output clock differs from the reference clock in both timing (phase) and speed (frequency).

2. **Correct:**  
   A **charge pump** and **loop filter** turn this difference into a smooth control voltage that adjusts a **voltage-controlled oscillator (VCO)**. This keeps the output clock locked to the reference.  
   A **feedback divider** allows the output to be a precise multiple of the reference frequency.

#### Phase/Frequency Detector (PFD)

- Detects which clock is ahead and by how much.  
- Produces digital **UP/DOWN pulses** representing the difference between the reference and output.  
- Using a PFD (instead of a simple XOR) improves the lock range and prevents timing slips, which is important for SoCs.

#### Charge Pump and Loop Filter

- Converts the PFD pulses into current (charge pump).  
- The **low-pass filter** turns this current into a smooth control voltage for the VCO.  
- Reduces ripple, controls lock speed, and keeps the clock stable with low jitter.  
- A well-designed filter balances three things:  
  1. Fast lock time  
  2. Low jitter  
  3. Stable operation without ringing  

#### Voltage-Controlled Oscillator (VCO) and Feedback Divider

- The **VCO** generates the clock signal, with frequency controlled by the input voltage.  
- The **feedback divider** sets the output frequency:  
  - **Integer-N:** `output = N × reference frequency`  
  - **Fractional-N:** allows finer frequency steps but requires spur-reduction techniques  
- The VCO’s noise mainly determines the output clock quality once locked.

#### Why PLLs Matter in SoCs and RISC-V Cores

- On-chip PLLs provide **low-jitter clocks** at the exact frequencies required by CPU, memory, and I/O.  
- Avoids long off-chip clock paths, reduces timing skew, and enables multiple frequencies from a single crystal.  
- Cleans up reference noise in-band and uses a low-noise VCO out-of-band, producing a **high-quality core clock** essential for reliable timing and performance in CPUs and SoCs.

<img width="1018" height="551" alt="pll" src="https://github.com/user-attachments/assets/480cea1e-5a63-4cf3-8ff5-181c953504eb" />

#### avsdpll_1v8 PLL Core Specifications

| **Parameter** | **Specification / Notes** |
|---------------|---------------------------|
| **Summary** | 8× clock multiplier PLL for SkyWater 130 nm, delivering 40–100 MHz output from 5–12.5 MHz reference at 1.8 V supply (typical corner, room temperature). |
| **Technology / Process** | SkyWater SKY130 (130 nm) open-source PDK |
| **Supply Voltage** | 1.8 V digital rail (VDD = 1.8 V at 27°C). |
| **Reference Input Frequency (F_CLKREF)** | 5–12.5 MHz (typical, 27°C). |
| **Output Frequency (F_CLKOUT)** | 40–100 MHz (8× multiplication via divide-by-8 feedback, typical, 27°C). |
| **Duty Cycle (Pre-layout)** | ~46% at 40 MHz, ~40.6% at 100 MHz. |
| **Duty Cycle (Post-layout)** | ~52.7% at 40 MHz, ~50% at 100 MHz. |
| **Lock Time (Pre-layout)** | ~120 µs at 40 MHz, ~80 µs at 100 MHz. |
| **Lock Time (Post-layout)** | ~37 µs at 40 MHz, ~22 µs at 100 MHz. |
| **Loop Filter** | Third-order passive filter; example pre-layout: C1 ≈ 355 fF, C2 ≈ 350 fF, C3 ≈ 345 fF, R1–R3 ≈ 490 Ω; post-layout caps adjusted to 295–305 fF. |
| **Functional Blocks / Areas (post-layout)** | Frequency divider: 29.92 µm², PFD: 49.09 µm², MUX: 12.12 µm², Charge Pump: 132.29 µm², VCO: 57.73 µm², Integrated PLL: 496.03 µm². |
| **Jitter / Load** | RMS jitter and load capacitance placeholders; focus on frequency, duty cycle, and lock times. |
| **Datasheet Summary** | SKY130, 1.8 V, 5–12.5 MHz in, 40–100 MHz out (8×), ~50% duty, lock ~22–37 µs post-layout, third-order loop filter. |


### 3. Digital-to-Analog-Converter

   
<img width="981" height="511" alt="dac" src="https://github.com/user-attachments/assets/4d1ee6e4-35b9-4af7-8789-0f26c0fab3a8" />

A **10-bit DAC (Digital-to-Analog Converter)** turns binary codes into an analog voltage.  
This allows mixed-signal SoCs to drive real-world loads like **sensors, audio paths, or measurement circuits**.

#### avsddac Specifications 

| **Parameter**       | **Description**            | **Typical/Example**     | **Unit** | **Notes** |
|----------------------|----------------------------|--------------------------|----------|-----------|
| **Resolution**      | Number of bits             | 10                       | bits     | 1024 codes |
| **Digital input**   | Data bus                   | `D[9:0]`                 | —        | From RVMYTH |
| **Enable**          | DAC enable                 | `EN`                     | —        | Digital control |
| **Analog supply**   | Analog rail                | 3.3                      | V        | VDDA (analog domain) |
| **Digital supply**  | Digital rail               | 1.8                      | V        | VDD (logic domain) |
| **References**      | High/Low refs              | `VREFH` / `VREFL`        | V        | Example: VREFH=3.3V, VREFL=0V |
| **Output pin**      | Analog output              | `OUT`                    | —        | Single-ended |

    
### 4. VSDBabySoC

#### How VSDBabySoC Works  

##### Step 1 – Starting Up and Clock Generation  
- When BabySoC powers on, the **PLL (Phase-Locked Loop)** starts running.  
- The PLL creates a **clean, stable clock signal**.  
- This clock keeps the **processor (RVMYTH)** and the **DAC** working in sync, ensuring smooth operation without timing errors.  

##### Step 2 – Data Processing in RVMYTH  
- The **RVMYTH processor** uses a register called **r17** to hold data values.  
- These values are continuously updated and sent to the **DAC**.  
- RVMYTH produces a **10-bit digital signal (OUT)** - `rvmyth D[9:0]`, which represents the data stream for analog conversion.  

##### Step 3 – Digital-to-Analog Conversion (DAC)  
- The **10-bit DAC** converts the digital values from RVMYTH into an **analog voltage**.  
- Each 10-bit code corresponds to one of **1024 voltage levels** between `VREFL` (low) and `VREFH` (high).  
- Typical DAC designs use:  
  - **R-2R resistor ladders**  
  - **Weighted resistors**  
- The **Sky130 version of the DAC** uses a **potentiometric architecture** with:  
  - **3.3 V analog supply** and **1.8 V digital supply**  
  - **External reference rails** (`VREFH` / `VREFL`)  
  - **Standard pin naming** for better noise isolation and tool compatibility 

> **PLL makes the clock → RVMYTH generates 10-bit data → DAC converts it into analog output.**


```
mkdir SoC
cd SoC
git clone https://github.com/manili/VSDBabySoC.git
cd VSDBabySoC
```
<img width="927" height="191" alt="image" src="https://github.com/user-attachments/assets/caf1b761-4fc1-4927-a177-5bdde5cef393" />

```
cd src/module
```

<img width="931" height="211" alt="image" src="https://github.com/user-attachments/assets/fa0ffc7e-dbce-4042-96f3-b442dd8b1e51" />


#### TLV to Verilog Conversion

Step 1: Install Python venv
```
sudo apt update
sudo apt install python3-venv python3-pip -y
```
Step 2: Create and Activate a Virtual Environment

This helps isolate SandPiper-SaaS and its dependencies.

```
# Create venv
python3 -m venv sp_env

# Activate venv
source sp_env/bin/activate
```

Step 3: Install SandPiper-SaaS Inside the Virtual Environment
```
pip install pyyaml click sandpiper-saas
```

> This installs the SandPiper-SaaS TLV compiler along with required Python dependencies.

Step 4: Prepare Your TLV Source

```
Place your .tlv files inside ./src/module/.
Example: rvmyth.tlv
```
Step 5: Convert TLV to Verilog

Run the compiler:
```
sandpiper-saas -i ./src/module/*.tlv -o rvmyth.v --bestsv --noline -p verilog --outdir ./src/module/
```
- -i ./src/module/*.tlv → Input TLV file(s)
- -o rvmyth.v → Output Verilog file name
- --bestsv → Optimize SystemVerilog output
- --noline → Remove debug line directives
- -p verilog → Generate pure Verilog
- --outdir ./src/module/ → Store output in same module directory

<img width="926" height="188" alt="image" src="https://github.com/user-attachments/assets/fe40973d-4fbf-49f8-9b5e-aca92f0a86fd" />

Step 6: Verify the Generated Verilog
```
less ./src/module/rvmyth.v
```

<img width="925" height="418" alt="image" src="https://github.com/user-attachments/assets/f13fd8cf-1612-4ab8-97e5-2098e838fe5f" />

```
cd src/module
tree
```
<img width="926" height="177" alt="image" src="https://github.com/user-attachments/assets/365672fe-a05f-4ad7-aa68-98d3bd6c3be3" />

- rvmyth.tlv → TL-Verilog source (the one you convert with SandPiper)

- rvmyth.v → Verilog generated from rvmyth.tlv (already present)

- rvmyth_gen.v → Likely an intermediate or modified version of rvmyth.v

- avsddac.v, avsdpll.v, clk_gate.v → Standard cell/analogue-digital blocks for SoC integration

- pseudo_rand_gen.sv, pseudo_rand.sv → SystemVerilog modules for random number generation

- vsdbabysoc.v → Top-level SoC module that integrates everything (DAC, PLL, RVMyth core, etc.)

- testbench.v → Testbench for simulation

- testbench.rvmyth.post-routing.v → Post-routing testbench (for gate-level simulation after layout)


> include folder

<img width="929" height="91" alt="image" src="https://github.com/user-attachments/assets/70046fc9-d0db-4756-b448-795189f81fef" />


#### Pre-Synthesis Simulation

```
mkdir -p output/pre_synth_sim

iverilog -o ./output/pre_synth_sim/pre_synth_sim.out \
  -DPRE_SYNTH_SIM \
  -I ./src/include \
  -I ./src/module \
  ./src/module/testbench.v

cd output/pre_synth_sim
./pre_synth_sim.out
gtkwave pre_synth_sim.vcd
```

- iverilog → invokes the Icarus Verilog compiler.
- -o ./output/pre_synth_sim/pre_synth_sim.out → specifies the output executable file.
- -DPRE_SYNTH_SIM → defines the macro PRE_SYNTH_SIM (used in your testbench for conditional code).
- -I ./src/include → tells the compiler where to look for header/include files.
- -I ./src/module → tells the compiler where to look for module source files.
- ./src/module/testbench.v → top-level testbench that ties the design and simulation together.

<img width="926" height="425" alt="image" src="https://github.com/user-attachments/assets/c797a9fb-33d8-4e4a-9068-28a7e0e3482b" />


#### Synthesis 

```
yosys
read_verilog ./src/module/vsdbabysoc.v
```
<img width="933" height="86" alt="image" src="https://github.com/user-attachments/assets/321db736-1659-4290-a794-0e8b28090058" />

```
read_verilog -I ./src/include/ ./src/module/rvmyth.v
```
<img width="926" height="113" alt="image" src="https://github.com/user-attachments/assets/7ae1d4b6-6047-4fb4-a087-08dd43ff9129" />

```
read_verilog -I ./src/include/ ./src/module/clk_gate.v
```
<img width="917" height="83" alt="image" src="https://github.com/user-attachments/assets/39f55b94-d898-4cac-9ceb-276ac581d05c" />

```
read_liberty -lib ./src/lib/avsdpll.lib
read_liberty -lib ./src/lib/avsddac.lib
read_liberty -lib ./src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
<img width="926" height="171" alt="image" src="https://github.com/user-attachments/assets/ed27ca72-e2b5-4862-92ad-b77a3bcadca4" />

```
synth -top vsdbabysoc
```

| **Clock Gate** | **RVMYTH** | **VSDBabySoC** | **Design Hierarchy** |
|----------------|------------|----------------|----------------------|
| <img width="227" height="147" alt="clockgate" src="https://github.com/user-attachments/assets/c2e0fb56-8bd0-4ef0-beec-15f5eb4099a3" /> | <img width="224" height="304" alt="rvmyth" src="https://github.com/user-attachments/assets/a9cf19ec-3a6e-4369-8685-0b0419256621" /> | <img width="226" height="173" alt="vsdbabysoc" src="https://github.com/user-attachments/assets/16ac9661-0ab5-4be2-9605-b7dd47f494b0" /> | <img width="236" height="364" alt="design-hier" src="https://github.com/user-attachments/assets/ac254241-a53b-4c0e-b7b2-466ff23062a2" /> |

```
dfflibmap -liberty ~/VLSI/VSDBabySoC/src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```
<img width="919" height="359" alt="image" src="https://github.com/user-attachments/assets/1c95146d-7c24-4d78-90b8-d8ce0c20cfd5" />

```
opt
```
<img width="927" height="359" alt="image" src="https://github.com/user-attachments/assets/5ed07f4b-a65f-4f75-8804-b55b19ac40d7" />

```
abc -liberty ./src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime;{D};strash;dch,-f;map,-M,1,{D}
```


| Command         | Purpose / Description                                                                 | Effect / Notes |
|-----------------|--------------------------------------------------------------------------------------|----------------|
| `strash`        | Structural hashing: converts the logic network into an **AIG (And-Inverter Graph)** | Efficient processing and simplified logic representation |
| `scorr`         | SAT-based equivalence checking and redundancy removal                               | Removes logic that does not affect outputs |
| `ifraig`        | Refines the AIG using SAT sweeping                                                  | Merges equivalent nodes, cleans up functionally identical logic |
| `retime`        | Moves flip-flops across logic (forward or backward)                                 | Improves performance or area; helps meet timing constraints |
| `{D}`           | Placeholder for design-specific commands                                             | May expand to clock definitions or other flow-specific steps |
| `strash` (again)| Rebuilds the AIG after retiming and cleanup                                         | Ensures AIG is optimized post-retiming |
| `dch,-f`        | Don’t-Care Hashing (`-f` forces aggressive optimization)                           | Exploits don't-care conditions to simplify logic |
| `map,-M,1,{D}`  | Technology mapping into **Sky130 standard cells**                                   | `-M,1` optimizes for minimum depth (timing first); `{D}` is flow-specific parameters |

<img width="926" height="400" alt="image" src="https://github.com/user-attachments/assets/418ee250-7fec-4426-96c1-c9de4f15a98e" />

```
flatten
setundef -zero
clean -purge
rename -enumerate
```
- **flatten** → make design flat (no hierarchy)  
- **setundef -zero** → replace undefined signals with 0  
- **clean -purge** → remove unused logic  
- **rename -enumerate** → rename signals/modules in order
- 
<img width="928" height="182" alt="image" src="https://github.com/user-attachments/assets/2ead8890-553a-4783-8c51-222f5d8e4229" />

```
stat
```
<img width="274" height="374" alt="image" src="https://github.com/user-attachments/assets/79da2ba2-6b38-4629-95a6-8343962455b0" />
<img width="284" height="292" alt="image" src="https://github.com/user-attachments/assets/9b6a8a5b-7d18-4c7f-942f-a86bbfc2c075" />

```
write_verilog -noattr ./output/post_synth_sim/vsdbabysoc.synth.v
```
<img width="927" height="101" alt="image" src="https://github.com/user-attachments/assets/9c5dd8ed-bac2-45fd-9be4-d9a21bcca869" />

#### Copy the required files for Gate-level Simulation

```
cd /home/venkatkamatham/Desktop/SoC/VSDBabySoC/src/module
cp -r ../../../../RTL/sky130RTLDesignAndSynthesisWorkshop/my_lib/verilog_model/primitives.v .
cp -r ../../../../RTL/sky130RTLDesignAndSynthesisWorkshop/my_lib/verilog_model/sky130_fd_sc_hd.v .
cp -r ../../output/post_synth_sim/vsdbabysoc.synth.v .
```
#### Post-Synthesis Simulation

```
cd Desktop/SoC/VSDBabySoC/
iverilog -o ./output/post_synth_sim/post_synth_sim.out -DPOST_SYNTH_SIM -DFUNCTIONAL -DUNIT_DELAY=#1 -I ./src/include -I ./src/module ./src/module/testbench.v
```
<img width="928" height="47" alt="image" src="https://github.com/user-attachments/assets/8d9812ab-ad09-4b65-a11e-d089900f9c42" />

> To resolve this: Update the syntax in the file sky130_fd_sc_hd.v at or around line 74452.

Change:

`endif SKY130_FD_SC_HD__LPFLOW_BLEEDER_FUNCTIONAL_V

To:

`endif // SKY130_FD_SC_HD__LPFLOW_BLEEDER_FUNCTIONAL_V

<img width="926" height="425" alt="image" src="https://github.com/user-attachments/assets/67777a00-b9e3-44e1-89bc-62cc74f214a1" />

- waveform
  
<img width="926" height="428" alt="image" src="https://github.com/user-attachments/assets/5b086481-b392-46a2-8dc7-51f8534e0488" />

