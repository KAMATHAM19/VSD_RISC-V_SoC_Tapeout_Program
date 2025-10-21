
# Week-5 OpenROAD Flow Setup - from Floorplan to Placement

<details>
  <summary>OpenROAD Flow Setup</summary>
    
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

```
## 1. Clone the OpenROAD Repository
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts

## 2. Run the Setup Script
sudo ./setup.sh

## 3. Build OpenROAD
./build_openroad.sh --local

## 4. Verify the Installation
## The binaries should be available on your $PATH after setting up the environment
source ./env.sh
yosys -help  
openroad -help
```
<img width="926" height="421" alt="image" src="https://github.com/user-attachments/assets/a2b268ff-3965-47fb-a2e1-6374676525d2" />

5. Run OpenROAD
```
openroad
```
<img width="928" height="87" alt="image" src="https://github.com/user-attachments/assets/77b6ecab-9119-48e8-a8fd-59491b25bd76" />

6. Launch the GUI for Visualisation
```
openroad -gui
```
<img width="926" height="411" alt="image" src="https://github.com/user-attachments/assets/9b331d2b-12ef-4efe-8a43-2c14d2f23d3b" />

7. Run the OpenROAD Flow
- The make command runs from RTL-GDSII generation for default design gcd with nangate45 PDK
```
cd flow
make
```
<img width="928" height="358" alt="image" src="https://github.com/user-attachments/assets/635ea0ac-8fbc-432e-abc5-118469f531db" />

- You can view final layout images in OpenROAD GUI using this command
```
make gui_final
```
<img width="927" height="411" alt="image" src="https://github.com/user-attachments/assets/b94c7c7e-f472-42d1-a718-76f1a90611ef" />

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

</details>


<details>
  <summary>Day 1: Introduction to Verilog RTL design and Synthesis</summary>

</details>

token_var error
<img width="926" height="94" alt="image" src="https://github.com/user-attachments/assets/a1fede64-d540-4ce8-a462-e38b823e73d9" />

include error
<img width="925" height="95" alt="image" src="https://github.com/user-attachments/assets/b95a724c-5497-4ae4-a0e6-19aa58d002f5" />

