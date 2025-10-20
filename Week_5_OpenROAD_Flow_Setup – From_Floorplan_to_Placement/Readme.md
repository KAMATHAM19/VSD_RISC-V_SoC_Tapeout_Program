

## OpenROAD

**OpenROAD (Open Routing, Optimisation, and Analysis for Designs)** is an open-source project that provides a **complete RTL-to-GDSII flow** for digital integrated circuit (IC) design. It enables **physical design automation** — taking a circuit described at the RTL (Register Transfer Level) and automatically generating the final layout (GDSII) that can be fabricated.

**Goal** - Create a **fully open-source**, **autonomous**, **24-hour**, **no-human-in-loop** RTL-to-GDS flow.

- **Main Repository:** [The-OpenROAD-Project/OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD)  
- **Flow Scripts Repository:** [The-OpenROAD-Project/OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)

### Supported Technology Nodes
- GF180nm
- SKY130nm
- SKY90nm
- TSMC 65nm
- GF55nm
- Intel 22/16nm
- GF12LP

<div align="center">
<img width="823" height="696" alt="image" src="https://github.com/user-attachments/assets/3bde3870-3768-42d5-915c-9b31a0194526" />
</div> 

The **OpenROAD toolchain** integrates multiple components to perform the **full physical design process** from RTL to GDSII.  

1. **Synthesis** – Converts RTL (Verilog) into a gate-level netlist.  
2. **Floorplanning** – Defines the chip layout, die area, and power grid.  
3. **Placement** – Optimally places standard cells within the floorplan.  
4. **Clock Tree Synthesis (CTS)** – Builds balanced clock distribution trees.  
5. **Routing** – Connects all placed cells with wires (global + detailed routing).  
6. **Optimisation** – Iteratively improves timing, power, and area.  
7. **GDSII Export** – Produces the final layout for fabrication.

<div align="center">
<img width="506" height="308" alt="image" src="https://github.com/user-attachments/assets/78a8fe2f-b41f-4d6b-bef5-2427896b62b3" />
</div>



### OpenROAD Installation 

1. Update your system
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget software-properties-common build-essential
```
2. Install build dependencies
```
sudo apt install -y \
    g++ clang make ninja-build \
    bison flex libreadline-dev \
    tcl-dev tk-dev swig python3-dev \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    libboost-all-dev libeigen3-dev libspdlog-dev \
    libpcre3-dev libgtest-dev libabsl-dev \
    liblemon-dev zlib1g-dev
```
3. Clone the OpenROAD Repository
```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git
cd OpenROAD
ls
```
<img width="925" height="407" alt="image" src="https://github.com/user-attachments/assets/9bde04a9-cc98-4147-863e-760a153ff809" />

4. Run the Setup Script
```
sudo ./etc/DependencyInstaller.sh -common
```
<img width="925" height="414" alt="image" src="https://github.com/user-attachments/assets/230a1a72-b2ca-4c08-9afd-9603b50d2ebe" />

5. Build OpenROAD
```
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
```


4. Verify the Installation
```
which openroad
openroad -help
```
5. Run OpenROAD
```
openroad
```
6. Launch the GUI for Visualisation
```
openroad -gui
```


## Example design run 
1. Steps to run the Design
Design - gcd, Technology - nangate45
Step 1: cd OpenROAD-flow-scripts/flow
Step 2: make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk

2. Steps to run the design stage by stage
To run the OpenROAD flow stage by stage, for synthesis, floorplan, placement, CTS, routing, and GDS-II generation, using the following commands.
- Synthesis with yosys
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk synth
- Floorplan includes floorplan initialization/IO placement/Macro placement/Power planning
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk floorplan
  for gui - make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk gui_floorplan
- Placement includes global placement/resizer/detail placement
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk place
 for gui -  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk gui_place
- Clock Tree Synthesis (CTS) includes clock tree build/optimization
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk cts
  for gui - make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk gui_cts
- Routing includes global routing/detail routing
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk route
  for gui - make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk gui_route
- Finishing includes post-route timing extraction/GDSII generation with KLayout
  make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk finish
- To view the final GDSII in KLayout:
  klayout -l platforms/nangate45/FreePDK45.lyp results/nangate45/gcd/base/6_final.gds

Clean the previous run database
make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk clean_floorplan
To remove entire logs/results/reports for the specific run, use
make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk clean_all
