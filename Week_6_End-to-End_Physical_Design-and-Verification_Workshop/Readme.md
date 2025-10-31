<img width="1853" height="292" alt="image" src="https://github.com/user-attachments/assets/dfd67a4e-700c-4361-93e9-56e9a9c9c790" />
<details>
  <summary>Installation of OpenLane and Magic</summary>
  
# Installation of OpenLane and Magic

### Step 1 - Install Docker
```
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
- verify installation

```
sudo docker run hello-world
```

<img width="1862" height="502" alt="image" src="https://github.com/user-attachments/assets/a56a83b5-3ec7-41bd-b969-9bb2b22e3d39" />

### Step 2 - Make Docker Available Without Root

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot # REBOOT!
```
## Step 3 - Install OpenLane
#### Required Packages

Before installing OpenLane, make sure you have the following packages installed:

- Docker **19.03.12+**
- Git **2.35+**
- Python **3.6+**
- GNU Make

You can check if these dependencies are installed and their versions by running:

```bash
git --version
docker --version
python3 --version
python3 -m pip --version
make --version
python3 -m venv -h
```
<img width="1852" height="843" alt="image" src="https://github.com/user-attachments/assets/b55daf41-d4d4-4c44-9eff-0446ee286bf2" />

```bash
cd $HOME
git clone https://github.com/The-OpenROAD-Project/OpenLane
cd OpenLane
```
<img width="1863" height="162" alt="image" src="https://github.com/user-attachments/assets/3485c277-09b6-405e-a7a5-6df50591b07b" />

```
make
make test
```
<img width="1862" height="998" alt="image" src="https://github.com/user-attachments/assets/00cda496-5fba-477a-b1f2-f3c2f5a43b29" />


# To enter the Dockerized OpenLane environment
```
make mount
```
<img width="1860" height="121" alt="image" src="https://github.com/user-attachments/assets/cb519d7e-db3b-4d6b-8b6a-ede9979a77cc" />


###  Magic
```bash
sudo apt-get install m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev libncurses-dev
git clone https://github.com/RTimothyEdwards/magic
cd magic
```
<img width="1863" height="162" alt="image" src="https://github.com/user-attachments/assets/7ccaa89c-caf7-4128-88d7-adb5971bf49a" />

```
./configure
make
sudo make install
```
<img width="1860" height="997" alt="image" src="https://github.com/user-attachments/assets/0198dcef-4edf-4569-905b-8974bbb1c8cb" />

```
magic
```
<img width="1854" height="827" alt="image" src="https://github.com/user-attachments/assets/8f5e8715-f095-4830-9a97-18ede3e6bfa9" />

### Building PDKs from Source

To build and install the **OpenPDKs (Process Design Kits)** for the **SkyWater SKY130 process node**, follow the steps below:

```
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
```
<img width="1860" height="236" alt="image" src="https://github.com/user-attachments/assets/d335b412-0427-472e-a4ba-e19f7b5bbb31" />

```
./configure --enable-sky130-pdk
make
sudo make install
```

  
</details>

Sky130 Day 1 - Inception of open-source EDA, OpenLANE and Sky130 PDK


# 1 – Inception of open-source EDA, OpenLANE and Sky130 PDK 

<img width="810" height="609" alt="image" src="https://github.com/user-attachments/assets/9ff51852-5f9e-4741-a59e-c57aec3543c4" />

<img width="1522" height="843" alt="image" src="https://github.com/user-attachments/assets/83592182-224f-4125-bd9b-eaf4336b4a29" />



In RTL2GDS physical design, there are various terms encountered. A few key terms are:

<img width="948" height="790" alt="image" src="https://github.com/user-attachments/assets/6e0bf192-c750-4919-b98c-d53b1f5c5118" />


### **Package**
- The **package** is the casing that houses the semiconductor device.  
- It protects the chip from physical damage and provides electrical connections to the circuit board.  
- **Example:** QFN-48 (Quad Flat No-Leads) — a package with **48 pins**.

### **Chip**
- The **chip** sits inside the package and connects to the package pins through **wire bonding**.  
- It contains various internal parts like the **pad**, **core**, and **interconnects**.


<img width="1288" height="795" alt="image" src="https://github.com/user-attachments/assets/df9fc75a-d702-4cf0-9cb0-de700b19c324" />

- Inside  of the CHIP
  
### **Pads**
- Pads connect the internal signals from the chip’s core to the external pins.  
- They are arranged in a **Pad Frame** around the edges of the chip.  
- Pads can be of several types:
  - **Input Pads**
  - **Output Pads**
  - **Power Pads**
  - **Ground Pads**

### **Die**
- The **die** is the physical silicon piece that contains all the chip’s functional circuits.  
- It represents the total area of the chip.
  
### **Core**
- The **core** is the main area of the chip where computation happens.  
- It includes all the **logic circuits** (like gates, multiplexers, etc.) used to perform operations and produce outputs.


<img width="1195" height="804" alt="image" src="https://github.com/user-attachments/assets/42c1621f-4891-47b7-bdb5-089a10651b8f" />

The **core** can contain two main types of blocks:

### **Analog Blocks**
- These are **foundry-provided IPs (Intellectual Properties)**.  
- Common examples include:
  - **ADC (Analog to Digital Converter)**
  - **DAC (Digital to Analog Converter)**
  - **PLL (Phase-Locked Loop)**
  - **SRAM (Static Random Access Memory)**

### **Digital Blocks**
- These are **macro blocks** that perform digital logic functions.  
- Common examples include:
  - **RISC-V SoC (System on Chip)**
  - **SPI (Serial Peripheral Interface)**


### Introduction to RISC-V

# RISC-V (Reduced Instruction Set Computing)

**RISC-V** is an **open-source Instruction Set Architecture (ISA)** used to design computer processors.  
It focuses on simplicity, efficiency, and flexibility — making it a popular choice for modern hardware design.

<img width="1785" height="1105" alt="image" src="https://github.com/user-attachments/assets/97b6600f-e4e0-4048-8617-4e7ceadc085a" />


## What is RISC-V?

- **RISC-V** stands for **Reduced Instruction Set Computing – Version 5**.  
- It defines the **set of instructions** that a processor can understand and execute.  
- Unlike proprietary ISAs (like x86 or ARM), RISC-V is **open-source**, meaning anyone can use and modify it freely.

##  Key Features

- **Simple and Clean Design:**  
  RISC-V has a small, efficient set of instructions, making processors easier to design and optimize.

- **High Performance:**  
  The reduced instruction set allows for faster execution and easier hardware implementation.

- **Flexible and Extensible:**  
  Developers can add **custom extensions** to tailor the architecture for specific applications.

- **Open-Source and Collaborative:**  
  Being open means researchers, companies, and developers can collaborate easily and innovate faster.

## Why It’s Popular

- Encourages **innovation** without licensing fees.  
- Supports **custom hardware designs** for AI, IoT, embedded systems, and high-performance computing.  
- Adopted by many **companies and research institutions** around the world.  

# Software Applications to Hardware

When you run a program on a computer, it doesn’t directly execute the high-level code (like C or Python).  
Instead, it goes through several steps before becoming **machine-executable hardware instructions**.

![IMG-8769](https://user-images.githubusercontent.com/64173714/215443267-3402518b-6809-4ca5-a753-1d2737d006da.jpg)


## Step-by-Step Process

### 1. High-Level Language
- You start by writing a program in a **high-level language** such as **C**, **C++**, or **Python**.
- This code is easy for humans to read and understand, but **hardware cannot execute it directly**.

### 2. Compilation (Compiler)
- The **compiler** translates the high-level code into **assembly language**.  
- Assembly language is **hardware-specific** — it represents instructions that the processor understands, but still in a readable format for humans.

### 3. Assembly to Machine Code (Assembler)
- The **assembler** converts the assembly language into **machine language**.  
- Machine language is made up of **binary code (0s and 1s)**, which can be directly executed by the processor.

### 4. System Software Role
The **system software** manages how the program interacts with the hardware.  
It includes:

| Component | Function |
|------------|-----------|
| **Operating System (OS)** | Handles low-level operations such as memory management, input/output, and process control |
| **Compiler** | Converts high-level source code into assembly language |
| **Assembler** | Translates assembly language into binary machine code |

### 5.Execution on Hardware
- Once in **binary form**, the code can be executed directly by the **chip**.  
- The **chip layout** defines the hardware components (like logic gates, registers, and connections) that perform the operations.

### 6. RTL (Register Transfer Level)
- The **interface between machine language and hardware** is defined through **RTL code**.  
- RTL describes the **digital logic behavior** — how data moves between registers and how computations are performed.  
- RTL is a key step in **hardware design**, bridging the gap between **software** and **physical circuits**.


> Programs move from **high-level code → assembly → binary → hardware →**,  
> with the help of the **OS, compiler, assembler,** and **RTL** that connect software instruction


## SoC design and OpenLANE

<img width="593" alt="3" src="https://user-images.githubusercontent.com/64173714/215445891-5f004c86-c8c8-4ba8-bdce-976a7e8f7f68.png">

To design a **digital ASIC (Application-Specific Integrated Circuit)** using **open-source** resources, three main open-source components are required:

## 1. RTL Designs

- **RTL (Register Transfer Level)** designs describe the digital logic behavior of a circuit.  
- These designs are typically written in **Verilog** or **VHDL** and define how data moves and is processed in hardware.  
- You can find many **open-source RTL designs** on:
  - [GitHub](https://github.com)  
  - [LibreCores](https://www.librecores.org)  
  - [OpenCores](https://www.opencores.org)

## 2. PDK (Process Design Kit)

- The **PDK** is a **collection of files** that model a **semiconductor fabrication process**.  
- It acts as a **bridge between the designer and the fabrication (fab)** by providing the necessary rules and models for ASIC design.

###  PDK Includes:

1. **Process Design Rules**  
   - Defines how the chip should be physically built.  
   - Includes:
     - **DRC (Design Rule Check)** – ensures layout follows manufacturing rules.  
     - **LVS (Layout vs. Schematic)** – checks that layout matches circuit design.  
     - **PEX (Parasitic Extraction)** – analyzes real-world physical effects.

2. **Device Models**  
   - Provide electrical characteristics of transistors and components used in simulation.

3. **Digital Standard Cell Libraries**  
   - Contain pre-designed logic gates (AND, OR, NOT, etc.) used to build digital circuits.

4. **I/O Libraries**  
   - Define input/output pad cells used for chip-to-board communication.

### Example: SkyWater PDK
- Provided by **Google** and **SkyWater Technology**.  
- Known as the **SkyWater 130nm Open-Source PDK**.  
- This PDK enables open-source ASIC design and fabrication using **130nm technology**.

## 3. EDA Tools (Electronic Design Automation)

- **EDA tools** are used to design, verify, and layout the ASIC.  
- These tools automate steps such as synthesis, placement, routing, and verification.

### Popular Open-Source EDA Tools:
- **OpenROAD** – Automated digital layout flow  
- **OpenLANE** – Complete ASIC design flow based on SkyWater PDK  
-  **QFlow** – Open-source digital synthesis and layout suite  


## Simplified RTL to GDSII Flow

![IMG-8761](https://user-images.githubusercontent.com/64173714/215446489-bdfd9f74-92c4-40db-bb70-744d06a18289.jpg)

## 1. Synthesis

**Synthesis** converts the RTL (Register Transfer Level) code into a **gate-level netlist** using components from a standard cell library.

<img width="560" height="188" alt="image" src="https://github.com/user-attachments/assets/0d9115e3-d104-4781-b759-e4f6ff5ad6f2" />

- Standard cells have a **regular layout** with **fixed height** and **variable width**.  
- Each standard cell has multiple **views/models**:
  - Electrical view  
  - HDL (Hardware Description Language) view  
  - SPICE view  
  - Layout views (Abstract and Detailed)

## 2. Floor Planning & Power Planning

### Floor Planning
This step allocates silicon area and defines how different components are arranged on the chip.

- **Chip Floorplanning**:  
  Divides the chip die into regions for different system blocks and places I/O pads.
  <img width="543" height="138" alt="image" src="https://github.com/user-attachments/assets/a9c5b94b-6438-4483-938a-324bcd35b517" />
  
- **Macro Floorplanning**:  
  Defines block dimensions, pin locations, and placement rows.
  <img width="546" height="152" alt="image" src="https://github.com/user-attachments/assets/c425a331-4cc9-4a8d-bad6-30afd19a8aa0" />

### Power Planning
Designs a **robust power distribution network** using:
- **Power rings, meshes, or stripes**  
- **Standard cell power rails**  
- **Thicker top metal layers** to minimize resistance and IR drop issues

<img width="820" height="320" alt="image" src="https://github.com/user-attachments/assets/01f1e082-68e0-46f7-8e66-4974e00d93ed" />


## 3. Placement

**Placement** is the process of positioning standard cells on predefined rows within the floorplan.

<img width="466" height="157" alt="image" src="https://github.com/user-attachments/assets/bd35ba70-e94a-44a6-b8fb-5cd17ed5f908" />


### Steps:
1. **Global Placement** – Finds approximate (but possibly illegal) cell locations for optimal performance.  
2. **Detailed Placement** – Adjusts cells into legal positions while maintaining good performance.

<img width="532" height="176" alt="image" src="https://github.com/user-attachments/assets/27641333-56d5-43d4-8eca-fb74ce8b3639" />

## 4. Clock Tree Synthesis (CTS)

**Clock Tree Synthesis** distributes the clock signal to all flip-flops with **minimum skew**.

- Common structures: **H-tree** or **X-tree**
- Goal: Ensure consistent clock arrival times across the chip
<img width="177" height="130" alt="image" src="https://github.com/user-attachments/assets/3b2390c2-5934-4fcc-b1ff-6fce4a56d59f" />

  
## 5. Routing

**Routing** connects the placed cells using metal layers defined in the process design kit (PDK).

### Routing Details:
- **Signal Routing**: Uses multiple metal layers (horizontal and vertical) to connect signals.  
- **Routing Grid**: A large grid defines metal tracks and via positions.  

### Routing Steps:
1. **Global Routing** – Generates routing guides for major signal paths.  
2. **Detailed Routing** – Implements exact wiring using those guides.

  <img width="1158" height="403" alt="image" src="https://github.com/user-attachments/assets/7a6f659a-112d-41be-a162-ee10a65e91c8" />

> Example: The **Sky130** PDK defines **6 routing layers** for both global and detailed routing.

## 6. Sign-Off

The **Sign-Off** stage verifies that the final layout meets all design and manufacturing rules.

### Physical Verification
- **DRC (Design Rule Checking)** – Ensures layout complies with fabrication rules.  
- **LVS (Layout vs Schematic)** – Confirms the layout matches the circuit schematic.

### Timing Verification
- Confirms that all **timing constraints** (setup, hold, and clock requirements) are satisfied.



### About Openlane flow

**OpenLANE** is an open-source, end-to-end flow for designing digital integrated circuits — taking designs from **RTL to GDSII**.  
It integrates multiple open-source tools and is optimized for the **SkyWater 130nm Open PDK (SKY130)**.


OpenLANE enables users to design and tape out digital chips using only **open-source tools** and **open-source process design kits (PDKs)**.  
It powers the **striVe family** of fully open SoCs (System-on-Chips), which follow the principles of:
-  **Open PDK**
-  **Open EDA**
-  **Open RTL**

<img width="526" height="387" alt="image" src="https://github.com/user-attachments/assets/20560799-2f3b-4784-bc90-65e83692c941" />

### Core Tools Used
| Function | Tool |
|-----------|------|
| RTL Synthesis | **Yosys** |
| Logic Optimization | **ABC** |
| Physical Design (PnR) | **OpenROAD** |
| Detailed Routing | **TritonRoute** |
| Timing Analysis | **OpenSTA** |
| Layout and Verification | **Magic**, **Netgen** |
| Parasitic Extraction | **SPEF_Extraction** |


## Modes of Operation

OpenLANE supports two primary modes:

1. **Autonomous Mode** – Runs the complete RTL-to-GDSII flow automatically.  
2. **Interactive Mode** – Allows users to manually control and customize each stage for exploration and debugging.

##  Design Flow Stages

![IMG-8762](https://user-images.githubusercontent.com/64173714/215446664-5d9da8cd-d538-4c7e-9585-98f393586e6d.jpg)  


### 1. RTL Synthesis
- The **Yosys** tool processes the RTL code and converts it into a **gate-level logic circuit**.
- **ABC** performs logic optimization and maps the design to a **standard cell library**.
- Various **ABC scripts** implement different synthesis strategies for improved timing or area efficiency.

### 2. Design Exploration
OpenLANE provides utilities for:
- Testing different design configurations  
- Generating **reports on layout violations**  
- Performing **Static Timing Analysis (STA)** using **OpenSTA**  
- Optional **DFT (Design for Test)** steps, including:
  - Scan Insertion  
  - ATPG (Automatic Test Pattern Generation)  
  - Test Pattern Compaction  
  - Fault Coverage Analysis  
  - Fault Simulation  


### 3. Physical Implementation
The **OpenROAD** tool handles the entire **Place and Route (PnR)** process, which includes:

| Step | Description |
|------|--------------|
| FP + PP | Floorplanning and Power Planning |
| Placement | Placing standard cells |
| Optimization | Improving timing and area |
| CTS | Clock Tree Synthesis |
| Routing | Connecting all signals |

- **TritonRoute** performs **detailed routing**.  
- A **Logic Equivalence Check (LEC)** ensures that the optimized circuit behaves identically to the original RTL.  
- **Antenna Rule Checking and Fixing** are done using **Magic**, with **fake antenna insertion** when necessary.  
- **NetGen** performs **circuit extraction** for verification.


### 4. Sign-Off

The final verification stage ensures the design is ready for tapeout.

| Verification Task | Tool |
|--------------------|------|
| Static Timing Analysis (STA) | OpenSTA |
| Design Rule Checking (DRC) | Magic |
| Layout vs Schematic (LVS) | Magic / NetGen |
| RC Extraction | SPEF Extraction + OpenSTA |


## Step 1. Setting Up the Working Directory

Navigate to your OpenLANE working directory:

```bash
cd work/tools/openlane_working_dir/openlane/
```
Step 2: Start the Docker Container
Run the OpenLANE Docker environment:
```
docker
```
Step 3: Launch OpenLANE in Interactive Mode
```
./flow.tcl -interactive
package require openlane 0.9
```
- Al the design files are in `openlane_working_dir/openlane/designs/picorv32a`
  
<img width="1853" height="292" alt="image" src="https://github.com/user-attachments/assets/bc90c74b-1161-4b4f-a6a8-be7f056c2f3d" />

Step 4: Prepare the Design
```
prep -design picorv32a 
```
> This merges configuration files and prepares the design for synthesis. Check if a merged file was created successfully.

<img width="1851" height="935" alt="image" src="https://github.com/user-attachments/assets/8b767f8e-e589-4067-a3ae-25f8b9314261" />

Step 5: Review the `runs` Directory

After each **OpenLANE** run, a new folder is created inside the `runs/` directory.  
Each run contains key files that record the **progress and results** of the design flow.

### Inside `runs/<run_name>/` you’ll find:

- **reports/** – Detailed metrics from each step (synthesis, placement, routing, STA).  
- **results/** – Final outputs such as **GDSII**, **DEF**, and **netlists**.  
- **logs/** – Terminal logs for **debugging** and **tracking** the flow execution.

> **Tip:** Reviewing these directories helps verify that each stage completed successfully and that your design meets timing and physical constraints.

<img width="1847" height="943" alt="image" src="https://github.com/user-attachments/assets/78e21bcb-7a90-4dea-a375-2eba8b7be2e4" />

Step 6: Run RTL Synthesis

Converts the RTL code into a gate-level netlist.
```
run_synthesis
```
<img width="1852" height="927" alt="image" src="https://github.com/user-attachments/assets/eb84fcc6-ac49-472b-8518-bbdbd971425f" />

Step 7: View Synthesis Statistics

After synthesis completes, check reports in:

```
reports/synthesis/
```
This includes:
 - Total cell count
 - Number of flip-flops
 - Logic breakdown
 - Timing results

<img width="1852" height="195" alt="image" src="https://github.com/user-attachments/assets/d1d0a5e8-3ffe-4308-ac4a-b019d8e1019f" />

<table>
  <tr>
    <th align="center">Pre-Statistics</th>
    <th align="center">Post-Statistics</th>
  </tr>
  <tr>
    <td align="center">
      <img width="457" height="607" alt="Pre-Statistics" src="https://github.com/user-attachments/assets/6e109a59-0417-4916-b0a3-32f97bf8008f" />
    </td>
    <td align="center">
      <img width="413" height="851" alt="Post-Statistics" src="https://github.com/user-attachments/assets/b010b82b-fe4e-4877-8298-be4a8c03ab72" />
    </td>
  </tr>
</table>

> Chip area for module : 147712.918400

Step 8: Calculate the Flop Ratio

Flop Ratio Formula:
```mathematica
Flop Ratio = (Number of D Flip-Flops) / (Total Number of Cells)


Flop Ratio = 1613 / 14876 = 0.108 ≈ 10.84 %
```
> Tip: A typical digital design has a flop ratio between 5% and 15%, depending on its complexity and architecture.

<img width="1848" height="961" alt="1" src="https://github.com/user-attachments/assets/f25d5602-584b-4438-8c3c-fbe2773082fd" />

# 2 - Understand importance of good floorplan vs bad floorplan and introduction to library cells

## 1. Define Width and Height of Core and Die

The **core and die** dimensions are determined based on the **netlist**, which defines the connectivity between all components in the circuit.

   <img width="1363" height="971" alt="image" src="https://github.com/user-attachments/assets/ffd1f5ba-2b2a-4bb9-8289-b763d4d4818a" />

For example: 

<img width="566" height="192" alt="image" src="https://github.com/user-attachments/assets/da1dcd5a-1934-42f6-83ef-9dee4d0fbd7b" />

- The **dimensions** depend on the number of **logic gates** and **flip-flops**, each having a specific length and width.  


  <img width="1393" height="893" alt="image" src="https://github.com/user-attachments/assets/e363305d-b7b3-4382-9948-57331c64c854" />

- Example:  
  If the minimum area is **2 × 2 = 4 units**, then the chip occupies **4 units** with **100% area utilization**.
  
<img width="1285" height="578" alt="image" src="https://github.com/user-attachments/assets/af6244bc-eda7-46ad-91d2-6d55ef9b04f1" />

### Utilization Factor

> **Utilization Factor** = (Area Occupied by Netlist) / (Total Area of the Core)

for example
 Utilization = (4 × 1) / (2 × 2)
 Utilization = 1 → No space left

> In practice, designs typically target **0.6 to 0.7 utilization**  
to allow space for routing and optimization.

### Aspect Ratio

> **Aspect Ratio (AR)** = Height / Width

| Aspect Ratio | Shape Description |
|---------------|------------------|
| AR = 1 | Square Shape |
| AR > 1 | Horizontal Rectangular Shape |
| AR < 1 | Vertical Rectangular Shape |


For example:

<img width="1732" height="986" alt="image" src="https://github.com/user-attachments/assets/f0c59db6-a142-4af4-b8c5-c28a0e348f6c" />

```mathematica
  Utilization Factor = (Area Occupied by Netlist) / (Total Area of the Core)
                     = (2 x 2) / (4 x 4)
                     = 4 / 16
                     = 0.25
- 75% is left for place the aditional cells, routing

  Aspect Ratio (AR) = Height / Width
                    = 4 / 4
                    = 1 (Square Shape)
```

## 2. Define the Locations of Pre-Placed Cells

**Pre-placed cells** are blocks or modules whose functionality is implemented **only once** and reused across the design.

### Characteristics of Pre-Placed Cells
- These cells are **fixed in position** before automated placement and routing.    
- They may have **extended I/O pins** to connect with other parts of the chip.
  <img width="1602" height="997" alt="image" src="https://github.com/user-attachments/assets/bca3efdc-1295-4711-8c42-e7efc3362e9e" />
- Often include **IP blocks** (Intellectual Property cores) or **reusable modules**.
     <img width="583" height="191" alt="image" src="https://github.com/user-attachments/assets/182b90bd-ecff-4248-b0d0-a89c0699576e" />
- The **arrangement of IPs** within the chip is referred to as **floorplanning**.

### Pre-placement Process
- IP blocks and other reusable cells have **user-defined locations** on the chip.  
- These blocks are positioned **manually or semi-manually** before the automatic placement process.  
- Once pre-placed cells are fixed, the **automated placement and routing tools** arrange the **remaining standard cells** and **logic elements** around them.

## 3. Surround Pre-Placed Cells with Decoupling Capacitors

###  Placement of Pre-Placed Cells
The **location of pre-placed cells** depends on the **design scenario** and functional requirements.  
They are strategically positioned to optimize **connectivity, performance, and power distribution**.

<img width="1499" height="963" alt="image" src="https://github.com/user-attachments/assets/67058ea8-7de7-4f87-a38b-f9dea17efd5e" />

### What Are Decoupling Capacitors?

**Decoupling Capacitors (Decaps)** are special capacitors placed **around pre-placed cells** to stabilize the power supply during switching events.

<img width="1415" height="861" alt="image" src="https://github.com/user-attachments/assets/93daad1d-a725-4faa-97b4-936d1835ba26" />

### Function of Decoupling Capacitors

In practical circuits, wires exhibit **resistance (R)**, **inductance (L)**, and **capacitance (C)**.  
When a circuit switches states (from `0 → 1` or `1 → 0`), **voltage drops** can occur due to these parasitic effects.

Decoupling capacitors help mitigate these effects by acting as **local charge reservoirs**.


### Working Principle

- A **decoupling capacitor** is a large capacitor pre-charged with electrical energy.  
- During a switching event, it **supplies the required charge** to nearby logic cells, preventing sudden voltage drops.  
- After switching, the capacitor **recharges** from the main power supply.  
- This cycle ensures a **stable voltage level** and reduces **crosstalk** and **power noise** in the design.

<img width="1290" height="970" alt="image" src="https://github.com/user-attachments/assets/f7bf7a18-f8e3-49e8-a627-3bf82a8d3670" />

## 4. Power Planning

### Purpose of Power Planning

**Power Planning** ensures that every part of the chip receives a stable and sufficient power supply (VDD and VSS).  
It involves designing a power distribution network that connects all major blocks (macros) and standard cells efficiently.

### Example Scenario

Consider a design with **4 macros**.  

<img width="967" height="807" alt="image" src="https://github.com/user-attachments/assets/9f6db2ac-427a-444b-a0d8-021a192a599f" />

Each macro must:
- Receive consistent power from **VDD** (power) and **VSS** (ground).  
- Maintain equal signal strength between the **driver** and the **load** across the chip.

<img width="1308" height="995" alt="image" src="https://github.com/user-attachments/assets/86153d94-4251-4610-9941-a942a4f25a2f" />

### Power Integrity Issues

Assume a **16-bit bus** connected to an inverter:

<img width="1448" height="880" alt="image" src="https://github.com/user-attachments/assets/d595416f-53c1-4e1f-b9e1-20e3536ceba6" />

- When logic `1` (VDD) becomes logic `0`, and vice versa,  
  the switching current passes through a **single VDD tap point**.
- This creates a momentary voltage imbalance, leading to:
  1. **Ground Bounce** – Increase in ground voltage at the VSS node.

<img width="1474" height="886" alt="image" src="https://github.com/user-attachments/assets/7b567e75-ef9a-484a-945f-7e50d5c116ed" />

 2. **Voltage Droop** – Drop in supply voltage at the VDD node.
    
<img width="1435" height="333" alt="image" src="https://github.com/user-attachments/assets/e4fed4b1-dd9d-4a19-98e7-b7f319fbb2df" />

These effects can cause **timing violations**, **logic instability**, and **signal noise**.


### Solution: Multiple Power Supply Connections

To minimize these effects:
- Use **multiple power and ground connections** distributed across the chip.  
- This reduces the current drawn from any single point, minimizing **voltage droop** and **ground bounce**.  
- Ensures a **uniform power distribution network (PDN)** throughout the design.

<img width="1899" height="986" alt="image" src="https://github.com/user-attachments/assets/b90616a9-f9ed-4e64-a97b-b8b90b7a0f3a" />

 
> Connecting all macros to multiple **VDD** and **VSS** taps improves power integrity, reduces noise, and ensures reliable chip operation during switching events.

  
  

    
 

### LABS 
* floorplan in openlane `run_floorplan`

<img width="953" alt="2 1" src="https://user-images.githubusercontent.com/64173714/215262087-ce4be0c1-be55-4835-9bb3-f12ae759249d.png">

The `picorv32a.floorplan.def` file was generated in the `./results/floorplan` directory by this command.

* We use the Magic tool to view the floorplan, and we need three files to do so:
   * Magic Tech file : sky130A.tech
   * LEF file : merged.lef
   * Def file of floorplan : picorv32a.floorplan.def

```
 magic -T <location of techfile> lef read <loction of lef file> def read <location of floorplan def file>
 ```
```
~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/runs/27-01_19-20/results/floorplan$
magic -T /home/venkykamatham1998/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read picorv32a.floorplan.def &
```
The above command can be used to view the floorplan in the Magic tool.

<img width="959" alt="magic" src="https://user-images.githubusercontent.com/64173714/215261151-64df2adf-2cbd-45a1-8988-626328ad414e.png">

* placement in openlane `run_placement`

<img width="960" alt="p1" src="https://user-images.githubusercontent.com/64173714/215262016-617f0a68-ae1b-4670-8428-8e6e46931cc3.png">

The `picorv32a.placement.def` file was generated in the `./results/placement` directory by this command.
```
 magic -T <location of techfile> lef read <loction of lef file> def read <location of placement def file>
 
```

```
~/Desktop/work/tools/openlane_working_dir/openlane/designs/picorv32a/runs/27-01_19-20/results/placement$
magic -T /home/venkykamatham1998/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read picorv32a.placement.def &

```

<img width="956" alt="placement" src="https://user-images.githubusercontent.com/64173714/215261639-6099a3f9-0480-434b-ae2f-da66f1ac7be9.png">

### Standard Cell Design
The typical standard cell design flow consists of 3 elements :
1. Inputs - PDKs , DRC & LVS rules, SPICE models, library & user-defined specs
2. Design Steps - Circuit design, layout design, characterization
3. Outputs - CDL(circuit description lanuage), GDSII, LEF, extracted spice netlist(.crc)

<a name="3-design-and-characterize-one-library-cell-using-magic-layout-tool-and-ngspice"></a>
# 3 - Design and characterize one library cell using Magic Layout tool and ngspice

### Labs
#### ioPlacer - to changes I/O pins and place around the core

```
% set ::env(FP_IO_MODE) 2
2
% run_floorplan
```
To see how I/O pins are aligned after changing the value in ioPlacer 

<img width="960" alt="reset" src="https://user-images.githubusercontent.com/64173714/215265586-4619331d-3f95-4573-9765-2c9d07226e55.png">

Spice Simulations (Pre-Layout)
The spice simulations mainly consist of :
1. Spice deck - component connectivity, component values, identify nodes, name nodes
2. NGspice introduction
3. Static behaviour evaluation 

## SPICE simulation lab for CMOS inverter

* At first we need to git clone the standard cells and command is :
```
git clone https://github.com/nickson-jose/vsdstdcelldesign.git

```
* After cloning the repo, navigate to the vsdstdcelldesign directory and use magic to view the sky130_inv.mag file.
* Before opening we need magic tech file and copy the tech file in vsdstdcelldesign directority
```
     cp sky130A.tech /home/venkykamatham1998/Desktop/work/tools/openlane_working_dir/openlane/vsdstdcelldesign/
```
 * To view the layout use this command 
 ```
     magic -T sky130A.tech sky130_inv.mag &
```
<img width="956" alt="image" src="https://user-images.githubusercontent.com/64173714/215268906-9ec922be-924e-447f-8758-a8d5eb418157.png">

16 mask CMOS fabrication process  
``` 
https://www.vlsisystemdesign.com/wp-content/uploads/2017/07/16-mask-process.pdf

```
* To view the layout press `s` for select, `z` for zoom and in `tkconl` type what cammand to see the mask layers 

<img width="959" alt="3 3" src="https://user-images.githubusercontent.com/64173714/215276740-9f6fd45c-da8c-476c-a30d-2a38baef0d08.png">

* We should extract the parasitics and characterise the design. We open the tkcon window and execute the following commands:
```
extract all
ext2spice cthresh 0 rthresh 0
ext2spice
```
The extracted file 

<img width="960" alt="3 4" src="https://user-images.githubusercontent.com/64173714/215278218-907c745b-a97a-4d7c-add9-a114193a6694.png">

<img width="960" alt="spice 1" src="https://user-images.githubusercontent.com/64173714/215278228-8ab8f44d-e61c-4da2-8699-f3011548a675.png">

We then modify the spice file so that we can plot a transient response:
```
* SPICE3 file created from sky130_inv.ext - technology: sky130A

.option scale=0.01u
.include ./libs/pshort.lib
.include ./libs/nshort.lib

* .subckt sky130_inv A Y VPWR VGND
M0 Y A VGND VGND nshort_model.0 ad=1435 pd=152 as=1365 ps=148 w=35 l=23
M1 Y A VPWR VPWR pshort_model.0 ad=1443 pd=152 as=1517 ps=156 w=37 l=23
C0 A VPWR 0.08fF
C1 Y VPWR 0.08fF
C2 A Y 0.02fF
C3 Y VGND 0.18fF
C4 VPWR VGND 0.74fF
* .ends

* Power supply 
VDD VPWR 0 3.3V 
VSS VGND 0 0V 

* Input Signal
Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)

* Simulation Control
.tran 1n 20n
.control
run
.endc
.end
```
* Open the spice file by typing `ngspice sky130A_inv.spice` 
* Generate a graph using `plot y vs time a` 

<img width="960" alt="3 0" src="https://user-images.githubusercontent.com/64173714/215286609-f27e665b-6d2e-4769-bbc8-1af19275347c.png">
<img width="960" alt="t" src="https://user-images.githubusercontent.com/64173714/215286642-0a0bdfcf-2078-4b72-9234-6d7afe3d4a7e.png">
* From the transient response, we will now characterise the cell's slew rate and propagation delay

   * rise transiton - time taken by output waveform to transit from 20%(0.66) to 80%(2.64) of VDD(3.3 max value) = 2.19945 - 2.15722 = 0.03728 ns
   
<img width="316" alt="rise" src="https://user-images.githubusercontent.com/64173714/215319377-e139cefc-a69f-4a70-96f1-9db85e05fc89.png">

   * fall transition - time taken by output waveform to transit from 80% (2.64) to 20% (0.66) of VDD = 4.06716 - 4.0394 = 0.02766 ns
   
<img width="307" alt="fall transi" src="https://user-images.githubusercontent.com/64173714/215319388-8c9b7de9-1e7a-4ed1-8563-925744289767.png">

   *  rise cell delay - The difference between the time when output as well as input is at 50% (1.65) i.e falling at 50% of output is rising = 2.18132 - 2.14945 = 0.03187 ns
   
<img width="308" alt="cell rise de" src="https://user-images.githubusercontent.com/64173714/215319395-2eac9a92-c094-4e40-bec6-e8fde0e86fb8.png">

   *  fall cell delay - The difference between the time when output as well as input is at 50% (1.65) i.e falling at 50% of input is rising = 4.059292 - 4.04958 = 0.009712 ns 
   
<img width="277" alt="cll fall delay" src="https://user-images.githubusercontent.com/64173714/215319398-47e2f33e-82e5-4527-83cc-5721f3be5836.png">

# 4 - Pre-layout timing analysis and importance of good clock tree

## LAB

* OpenLANE is a tool for place and route, which places cells in a design. When using this tool, the full information contained in the .mag file, which includes boundry,power and ground, logic, etc., is not necessary. Instead, only the essential information, such as the placement boundary, power and ground rails, and input and output ports, is required. This information is contained in lef files, which protect the IP(intellectual property). 
* The goal is to extract the lef file from the .mag file and use it to replace the standard cells in the design. There are guidelines to follow when creating a standard cell set for use in place and route
   * I/p and O/p port must lies on the intersection of the vertical and horizontal tracks
   * Width oof the std cell should be in the odd ultiples of the track pitch
   * Height should be odd multiples of vertical track pitch
   
  * To run the previous flow follow this command
 ```
   prep -design picorv32a -tag
 
 ```
 * In these directory `/pdks/sky130A/libs.tech/openlane/sky130_fd_sc_hd/` we can find tracks
 ```
 ~/Desktop/work/tools/openlane_working_dir/openlane/vsdstdcelldesign$ cd ../../pdks/sky130A/libs.tech/openlane/sky130_fd_sc_hd/
 
 ```
 * tpye command ` less tracks.info`
 ```
 less tracks.info
 
 ```
 <img width="956" alt="4 1" src="https://user-images.githubusercontent.com/64173714/215493780-f81c412d-a0eb-49a8-b4a7-ce6e5fd2cd34.png">
 
 * open the layout from vsdstdcelldesign directory
 
 ``` 
    magic -T sky130.tech sky130_inv.mag
 
 ```
In the tkon terminal, use the grid command to compare the tracks' information

<img width="960" alt="4 2" src="https://user-images.githubusercontent.com/64173714/215494843-c069b012-c948-4dd9-9164-d43678a4d5cc.png">

The three guidelines are clearly shown in the illustration in this image

<img width="958" alt="4 3" src="https://user-images.githubusercontent.com/64173714/215496521-f3f79ae8-e302-4155-8946-244049d897dd.png">

* The information from the .mag file will be extracted into a LEF file, which will contain essential details for placement and routing, such as cell dimensions, port information, and specific properties. The first step in creating the LEF file is to clearly define the port definitions, including the class and intended use of each port
* Save the mag file and relaunch the magic tool. Then run the command below to create the lef file
```
    lef write
```
<img width="960" alt="4 4" src="https://user-images.githubusercontent.com/64173714/215499686-c0f38477-bf00-46ad-be90-145cd216e0cb.png">

<img width="960" alt="4 4 1" src="https://user-images.githubusercontent.com/64173714/215499715-a9e30d63-c15f-4df4-bcc4-010159a9972f.png">

* The prior command creates a.lef file. Now, use the following command to copy the lef file into the picrorv32a directory.
```
      cp <path to the file> <path to the target location>
```
* Add the folowing to config.tcl inside the picorv32a
```
Design
set ::env(DESIGN_NAME) "picorv32a"

set ::env(VERILOG_FILES) "./designs/picorv32a/src/picorv32a.v"
set ::env(SDC_FILE) "./designs/picorv32a/src/picorv32a.sdc"
set ::env(CLOCK_PERIOD) "5.000"
set ::env(CLOCK_PORT) "clk"

set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(LIB_SYNTH) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"
set ::env(LIB_FASTEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__fast.lib"
set ::env(LIB_SLOWEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__slow.lib"
set ::env(LIB_TYPICAL) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"
set ::env(EXTRA_LEFS) [glob $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/*.lef]

set ::env(FP_CORE_UTIL) 65
set ::env(FP_IO_VMETAL) 4
set ::env(FP_IO_HMETAL) 3

set filename $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
source $filename
}
```
* Connect the newly created lef file to the OpenLANE flow using
```
    set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
  
    add_lefs -src $lefs 

```
<img width="951" alt="5 1" src="https://user-images.githubusercontent.com/64173714/215319500-f3e895e5-cb8c-4a45-ad82-c21ac34d86c9.png">

<img width="947" alt="5 2" src="https://user-images.githubusercontent.com/64173714/215505144-b1013341-2dde-421d-99d0-c341b1ed6313.png">

* run synthesis - `run_synthesis`

<img width="960" alt="5 3" src="https://user-images.githubusercontent.com/64173714/215505008-c5f76b67-bd49-4f83-9936-966dc3f67656.png">

* Change a few variables to reduce the negative slack. We will now change the variables "on the flight". To see the current value of the variables before changing them, use echo $::env(SYNTH STRATEGY):
```
% echo $::env(SYNTH_STRATEGY)
AREA 0
% set ::env(SYNTH_STRATEGY) 1
% echo $::env(SYNTH_BUFFERING)
1
% echo $::env(SYNTH_SIZING)
0
% set ::env(SYNTH_SIZING) 1
% echo $::env(SYNTH_DRIVING_CELL)
sky130_fd_sc_hd__inv_8
```
* run floorplan
since the openlane is new version it doesn't support `run_floorplan` command we need to use alternatives commands as follows
```
  init_floorplan
  place_io
  global_placement_or
  detailed_placement
  tap_decap_or
  detailed_placement
  gen_pdn
  run_cts
  run_routing
```
* Open the def file via magic
 
<img width="944" alt="5 5" src="https://user-images.githubusercontent.com/64173714/215507673-812bf29b-787f-43ca-b309-20a950e69b6a.png">

<img width="833" alt="5 6" src="https://user-images.githubusercontent.com/64173714/215507731-94531ee9-3635-4418-aa21-07a112a95191.png">

<img width="956" alt="5 7" src="https://user-images.githubusercontent.com/64173714/215507913-56c041d2-7165-4693-9de0-a7f6b055886f.png">

* Now, using the command, we perform a post-synthesis analysis in OpenSTA
```
  sta pre_sta.conf
```
<img width="960" alt="5 9" src="https://user-images.githubusercontent.com/64173714/215510847-d229a2f2-45fd-46cb-a9e2-f0057411f95c.png">

# Acknowledgement
* Kunal Ghosh - Co-founder of VSD 
* Nickson Jose - Instructor




Sky130 Day 2 - Good floorplan vs bad floorplan and introduction to library cells

Sky130 Day 3 - Design library cell using Magic Layout and ngspice characterization

Sky130 Day 4 - Pre-layout timing analysis and importance of good clock tree

Sky130 Day 5 - Final steps for RTL2GDS using tritonRoute and openSTA
