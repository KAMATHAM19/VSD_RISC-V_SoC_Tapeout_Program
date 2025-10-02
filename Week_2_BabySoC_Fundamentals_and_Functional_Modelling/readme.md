# BabySoC Fundamentals & Functional Modelling


## rvmyth core

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


## TLV to Verilog Conversion

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
Place your .tlv files inside ./src/module/.
Example: rvmyth.tlv

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


include
<img width="929" height="91" alt="image" src="https://github.com/user-attachments/assets/70046fc9-d0db-4756-b448-795189f81fef" />
