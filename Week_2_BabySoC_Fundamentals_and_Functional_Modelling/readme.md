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


## pre-synthesis Simulation

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

iverilog → invokes the Icarus Verilog compiler.

-o ./output/pre_synth_sim/pre_synth_sim.out → specifies the output executable file.

-DPRE_SYNTH_SIM → defines the macro PRE_SYNTH_SIM (used in your testbench for conditional code).

-I ./src/include → tells the compiler where to look for header/include files.

-I ./src/module → tells the compiler where to look for module source files.

./src/module/testbench.v → top-level testbench that ties the design and simulation together.


<img width="926" height="425" alt="image" src="https://github.com/user-attachments/assets/c797a9fb-33d8-4e4a-9068-28a7e0e3482b" />



# yosys 

read_verilog ./src/module/vsdbabysoc.v

<img width="933" height="86" alt="image" src="https://github.com/user-attachments/assets/321db736-1659-4290-a794-0e8b28090058" />

read_verilog -I ./src/include/ ./src/module/rvmyth.v

<img width="926" height="113" alt="image" src="https://github.com/user-attachments/assets/7ae1d4b6-6047-4fb4-a087-08dd43ff9129" />


read_verilog -I ./src/include/ ./src/module/clk_gate.v

<img width="917" height="83" alt="image" src="https://github.com/user-attachments/assets/39f55b94-d898-4cac-9ceb-276ac581d05c" />


read_liberty -lib ./src/lib/avsdpll.lib
read_liberty -lib ./src/lib/avsddac.lib
read_liberty -lib ./src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

<img width="926" height="171" alt="image" src="https://github.com/user-attachments/assets/ed27ca72-e2b5-4862-92ad-b77a3bcadca4" />

synth -top vsdbabysoc

clockgate
<img width="227" height="147" alt="image" src="https://github.com/user-attachments/assets/c2e0fb56-8bd0-4ef0-beec-15f5eb4099a3" />

rvmyth
<img width="224" height="304" alt="image" src="https://github.com/user-attachments/assets/a9cf19ec-3a6e-4369-8685-0b0419256621" />

vsdbabysoc
<img width="226" height="173" alt="image" src="https://github.com/user-attachments/assets/16ac9661-0ab5-4be2-9605-b7dd47f494b0" />

design hier
<img width="236" height="364" alt="image" src="https://github.com/user-attachments/assets/ac254241-a53b-4c0e-b7b2-466ff23062a2" />

dfflibmap -liberty ~/VLSI/VSDBabySoC/src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

<img width="919" height="359" alt="image" src="https://github.com/user-attachments/assets/1c95146d-7c24-4d78-90b8-d8ce0c20cfd5" />

opt

<img width="927" height="359" alt="image" src="https://github.com/user-attachments/assets/5ed07f4b-a65f-4f75-8804-b55b19ac40d7" />

abc -liberty ./src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime;{D};strash;dch,-f;map,-M,1,{D}

<img width="926" height="400" alt="image" src="https://github.com/user-attachments/assets/418ee250-7fec-4426-96c1-c9de4f15a98e" />

flatten
setundef -zero
clean -purge
rename -enumerate

<img width="928" height="182" alt="image" src="https://github.com/user-attachments/assets/2ead8890-553a-4783-8c51-222f5d8e4229" />

stat
<img width="274" height="374" alt="image" src="https://github.com/user-attachments/assets/79da2ba2-6b38-4629-95a6-8343962455b0" />
<img width="284" height="292" alt="image" src="https://github.com/user-attachments/assets/9b6a8a5b-7d18-4c7f-942f-a86bbfc2c075" />


write_verilog -noattr ./output/post_synth_sim/vsdbabysoc.synth.v
<img width="927" height="101" alt="image" src="https://github.com/user-attachments/assets/9c5dd8ed-bac2-45fd-9be4-d9a21bcca869" />









