

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

- Run the OpenROAD Flow
- The make command runs from RTL-GDSII generation for the default design gcd with the nangate45 PDK
```
cd flow
make
```
<img width="928" height="358" alt="image" src="https://github.com/user-attachments/assets/635ea0ac-8fbc-432e-abc5-118469f531db" />

- You can view the final layout images in OpenROAD GUI using this command
```
make gui_final
```
<img width="927" height="411" alt="image" src="https://github.com/user-attachments/assets/b94c7c7e-f472-42d1-a718-76f1a90611ef" />

</details>


<details>
  <summary>RTL2GDS Flow for SPM</summary>

# **RTL2GDS Flow for SPM** 

This explains how to set up and run the **RTL to GDS-II flow** for the **Serial/Parallel Multiplier (SPM)** design using the **OpenROAD-flow-scripts** framework.


Step 1: Create Source Directories

1. Create the Verilog source directory for the design:
```
mkdir -p OpenROAD-flow-scripts/flow/designs/src/spm
```
2. Add your Verilog file:
```
cd OpenROAD-flow-scripts/flow/designs/src/spm
gvim spm.v
```

- spm.v
  
```verilog
// (Parameterized) Unsigned Serial/Parallel Multiplier:
// - Multiplicand x (Input bit-serially)
// - Multiplier a (All bits at the same time/Parallel)
// - Product y (Output bit-serial)
module spm #(parameter bits=32) (
    input clk,
    input rst,
    input x,
    input[bits-1: 0] a,
    output y
);
    wire[bits: 0] y_chain;
    assign y_chain[0] = 0;
    assign y = y_chain[bits];

    wire[bits-1:0] a_flip;
    generate 
        for (genvar i = 0; i < bits; i = i + 1) begin : flip_block
            assign a_flip[i] = a[bits - i - 1];
        end 
    endgenerate

    delayed_serial_adder dsa[bits-1:0](
        .clk(clk),
        .rst(rst),
        .x(x),
        .a(a_flip),
        .y_in(y_chain[bits-1:0]),
        .y_out(y_chain[bits:1])
    );

endmodule

module delayed_serial_adder(
    input clk,
    input rst,
    input x,
    input a,
    input y_in,
    output reg y_out
);
    reg last_carry;
    wire last_carry_next;
    wire y_out_next;

    wire g = x & a;
    assign {last_carry_next, y_out_next} = g + y_in + last_carry;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            last_carry <= 1'b0;
            y_out <= 1'b0;
        end else begin
            last_carry <= last_carry_next;
            y_out <= y_out_next;
        end
    end
endmodule
```

Step 2: Create Design Configuration

Inside OpenROAD-flow-scripts/flow/designs/sky130hd/, create a folder for the design:
```
mkdir -p OpenROAD-flow-scripts/flow/designs/sky130hd/spm
```
Create a configuration file named config.mk:
```
gvim config.mk
```
- Add the following contents:

```
export PLATFORM         = sky130hd
export DESIGN_NAME      = spm
export VERILOG_FILES    = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE         = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60
export TNS_END_PERCENT  = 100
```

Step 3: Define SDC Constraints

Create the file constraint.sdc in:
```
OpenROAD-flow-scripts/flow/designs/sky130hd/spm/
gvim constraint.sdc
```

- write the contents
  
```
current_design spm

set clk_name        core_clock
set clk_port_name   clk
set clk_period      10
set clk_io_pct      0.2

set clk_port [get_ports $clk_port_name]
create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]
set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
```
> This script defines the timing constraints and clock setup for the SPM module using the sky130hd platform.

Step 4: Run the OpenROAD Flow

The OpenROAD flow can be run stage-by-stage for synthesis, floorplan, placement, CTS, routing, and GDS-II generation.

1. Change Directory
```
cd OpenROAD-flow-scripts/flow
```

2. Edit the Makefile:
   
Comment out the default GCD run and add a line for SPM:
```
DESIGN_CONFIG=./designs/sky130hd/spm/config.mk
```
<img width="926" height="426" alt="1" src="https://github.com/user-attachments/assets/7b9118af-ff49-415c-b5a5-c54d9d144475" />

2. Synthesis (Yosys)
   
Converts RTL to Gate-level Netlist
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk synth
```
<img width="923" height="402" alt="image" src="https://github.com/user-attachments/assets/de8d458b-1a4c-4307-bded-ac9d125f9a30" />

3. Floorplanning
   
Includes floorplan initialisation, IO placement, macro placement, and power planning.
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk floorplan
```
<img width="926" height="419" alt="image" src="https://github.com/user-attachments/assets/6187634f-d52c-4275-923d-ac25d0cc179d" />

GUI Mode:

```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk gui_floorplan
```

<img width="926" height="427" alt="image" src="https://github.com/user-attachments/assets/c02ea2e5-6845-4726-8256-1d7fca48df24" />

4. Placement

Includes global placement, resizer, and detailed placement.

```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk place
```
<img width="926" height="404" alt="image" src="https://github.com/user-attachments/assets/49f40443-fd3e-44a8-95ae-4c1c471a7171" />

GUI Mode:
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk gui_place
```
<img width="926" height="413" alt="image" src="https://github.com/user-attachments/assets/d2af2af1-c824-45fc-aac3-90f250946382" />

5. Clock Tree Synthesis (CTS)

Includes clock tree build and optimisation.
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk cts
```
<img width="926" height="408" alt="image" src="https://github.com/user-attachments/assets/0fcc93b7-96f9-4b4f-919c-4c23f4688847" />

GUI Mode:
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk gui_cts
```
<img width="925" height="427" alt="image" src="https://github.com/user-attachments/assets/2c5d5631-598c-45cb-85b2-9d68fc374e68" />

6. Routing

Includes global and detailed routing.
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk route
```
<img width="925" height="418" alt="image" src="https://github.com/user-attachments/assets/25f5b28a-7829-45f0-ad38-6e6709f59b60" />

GUI Mode:
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk gui_route
```
<img width="926" height="428" alt="image" src="https://github.com/user-attachments/assets/16cb121b-410e-4e23-bd18-9d0392f4985c" />

7. Finishing

Performs post-route timing extraction and generates the GDS-II layout.
```
make DESIGN_CONFIG=./designs/sky130hd/spm/config.mk finish
```
<img width="925" height="422" alt="image" src="https://github.com/user-attachments/assets/7f9aca00-8a17-439a-a845-918c5e092402" />

Step 5: View Final GDSII in KLayout
```
klayout -l platforms/sky130hd/sky130hd.lyp results/sky130hd/spm/base/6_final.gds
```
<img width="926" height="430" alt="image" src="https://github.com/user-attachments/assets/4d1ec786-ac32-438e-8c68-ab0233c1ee51" />


</details>



