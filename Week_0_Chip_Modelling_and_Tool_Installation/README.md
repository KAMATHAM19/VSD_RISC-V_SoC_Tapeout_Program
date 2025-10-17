<details>
  <summary>Week 0 - Chip Modelling and Tool Installation</summary>
<br>

  <details>
    <summary>Task 1: Chip Modelling</summary>
 <br>
    
<p align="center">
  <img width="1906" height="1072" alt="image" src="https://github.com/user-attachments/assets/25776a4a-b95c-4fbe-a7a4-322a1f8b11bf" />
</p>

## Chip Modelling and Compiler Flow
Applications are typically written in **C** and compiled using tools like `gcc`.  
The compilation generates an **object file**, which represents the executable form of the application.  

> At this stage, a **C/C++ model specification** is also produced, serving as a high-level reference for later hardware design and verification steps.  


## RTL Architecture and Specification Representation
In this phase, the design is converted into a **soft copy of the hardware** using RTL (Register Transfer Level) languages such as **Verilog**.  
The specifications are translated into RTL, which describes the hardware logic and forms the foundation for digital circuit implementation.  

### RTL Verification
Before moving forward, the RTL is verified using **simulation and testbenches** to ensure it behaves according to the design specification.  
This step helps catch functional bugs early in the design cycle.  

## SoC Design and Processor/Peripheral Block Creation
The design is divided into **major functional blocks**:  
- **Processor core(s)**  
- **Peripherals / IPs**  

From here:  
- The **processor core** is implemented as a **synthesizable RTL**, which is converted into a **gate-level netlist** through synthesis.  
- **Macro blocks** are also written as **synthesizable RTLs**, typically representing reusable digital components.  
- **Analog IPs** are provided as **functional RTLs**, which model behavior for simulation but are not synthesizable.  


## SoC Integration and GPIOs
All blocks are brought together through **SoC integration**, combining the **processor core(s)**, **peripherals/IPs**, and other functional blocks into a unified design.  
This stage ensures proper communication between components using system buses and interconnects.  

- **GPIOs (General Purpose Input/Output)** act as essential interfaces, enabling the chip to interact with external devices.  
- The integration process validates that all blocks work correctly together at the system level, preparing the design for the physical implementation flow.  


### Difference Between Microprocessor and Microcontroller

| Feature              | Microprocessor                                                                 | Microcontroller                                                      |
|----------------------|---------------------------------------------------------------------------------|----------------------------------------------------------------------|
| **Definition**       | CPU on a single chip, requires external memory and peripherals to work.         | CPU, memory, and peripherals integrated into one single chip.        |
| **Main Focus**       | Processing and computation.                                                     | Control of embedded applications/devices.                           |
| **Memory**           | External RAM, ROM, and storage needed.                                          | On-chip RAM, ROM/Flash memory included.                             |
| **Peripherals**      | External (timers, I/O ports, ADC, etc.).                                        | Built-in peripherals (I/O ports, timers, ADC, UART, etc.).          |
| **System Cost**      | Higher (needs multiple chips for a complete system).                           | Lower (single-chip solution).                                       |
| **Power Consumption**| Higher (not optimized for low power).                                           | Lower (optimized for embedded/portable devices).                    |
| **Speed**            | Higher clock speeds, suitable for heavy computations and multitasking.          | Moderate speed, optimized for control-oriented tasks.                |
| **Applications**     | Computers, laptops, servers, high-performance systems.                         | Embedded systems like washing machines, Arduino, smartwatches, TVs. |
| **Examples**         | Intel 8085, Intel 8086, Intel Pentium, ARM Cortex-A.                            | Intel 8051, PIC, ARM Cortex-M, Atmega328 (Arduino).                 |


## Floorplanning and Block Design
This stage covers the steps in **physical design**:

1. **Floorplanning** – Define the layout of major blocks, allocate chip area, and plan power distribution (power planning).  
2. **Placement** – Position standard cells and macros within the defined floorplan.  
3. **CTS (Clock Tree Synthesis)** – Distribute the clock signal evenly across the chip to reduce skew.  
4. **Routing** – Connect placed components with metal interconnects for signal and power delivery.  

> During this phase, IPs and macro blocks are integrated into the chip layout.


## GDSII, DRC/LVS, and Tape-out
After physical design, the chip undergoes:

- **DRC (Design Rule Check)** – Verifies that the layout obeys all manufacturing design rules.  
- **LVS (Layout Versus Schematic)** – Ensures the layout matches the original circuit schematic.  
- **GDSII Generation** – Converts the verified layout into GDSII format, the standard file for fabrication.  
- **Tape-out** – Final step of sending the GDSII data to the semiconductor foundry for manufacturing.  

> When the design passes these checks, it is converted to **GDSII format** and prepared for **tape-out** (sending the design to the foundry for fabrication).
</br>

<p align="center">
  <img width="926" height="994" alt="image" src="https://github.com/user-attachments/assets/2cdb1aaf-c1ce-401c-a3b9-a98edc091229" />
</p>

## Tape-in, Applications, and Use Cases
Once the chip is fabricated, it undergoes **packaging** and **post-silicon testing** to ensure functionality and reliability.  
This stage, known as **tape-in**, marks the point where the chip is ready to be integrated into real-world products.  

### Example Applications
- **Arduino boards** – used in prototyping and educational projects  
- **TV panels** – for display drivers and image processing control  
- **Wearables** (e.g., smartwatches) – compact, low-power SoCs for portable devices  
- **Consumer electronics** (e.g., AC systems) – embedded controllers for automation and control  

  </details>

<details>
  <summary>Task 2: Tool Installation</summary>
  
# Task 2 – Tool Installation  

Setup guide for the **VSD RISC-V Tapeout Program**. Follow the steps below to prepare your environment.  


## Required Downloads  

-  Download and install **Oracle VirtualBox**:  
  > [VirtualBox Downloads](https://www.virtualbox.org/wiki/Downloads)  

-  Download **Ubuntu Desktop (20.04 or later, 64-bit)**:  
  > [Ubuntu Desktop Downloads](https://ubuntu.com/download/desktop)  


## Installation Walkthrough  

- Watch this step-by-step video for **VirtualBox + Ubuntu installation**:
  
 > [VirtualBox & Ubuntu Setup (YouTube)](https://www.youtube.com/watch?v=hYaCCpvjsEY)  

## System Requirements  

Ensure your host system meets these requirements:  

| Resource  | Minimum Requirement      |
|-----------|--------------------------|
|  RAM      | 6 GB                    |
|  Disk     | 50 GB free space        |
|  OS       | Ubuntu 20.04+ (64-bit)  |
|  CPU      | 4 vCPUs                 |


## Update Ubuntu  

Once Ubuntu is installed, update and clean the system by running:  

```bash
sudo apt update
sudo apt upgrade
sudo apt autoclean
sudo apt autoremove
sudo apt install adms autoconf libtool automake libxaw7-dev libreadline-dev flex bison libxpm-dev gperf gcc g++ make dkms gcc
```
### 1. Yosys

```bash
sudo apt−get install build−essential clang bison flex libreadline−dev gawk tc−dev libffi−dev git graphviz xdot pkg−config python3 libboost−system−dev 
libboost−python−dev libboost−filesystem−dev zlib1g−dev

git clone https://github.com/YosysHQ/yosys.git
cd yosys
make 
sudo make install
yosys
```
<img width="1853" height="394" alt="image" src="https://github.com/user-attachments/assets/8920718a-0944-4155-aa76-ae861786e03f" />

### 2. Icarus Verilog

```bash
git clone https://github.com/steveicarus/iverilog.git
cd iverilog
sh autoconf.sh
./configure
make
sudo make install
```
<img width="1863" height="350" alt="image" src="https://github.com/user-attachments/assets/ebf16fa1-990d-44fb-a39b-3b6bf5d406e8" />

### 3. Gtkwave
```bash
cd
sudo apt install gtkwave
gtkwave
```
<img width="1855" height="832" alt="image" src="https://github.com/user-attachments/assets/bbe6b7f1-08b6-4503-a086-dadc1bb5a421" />


### 4. Magic
```bash
sudo apt-get install m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev libncurses-dev
git clone https://github.com/RTimothyEdwards/magic
cd magic
./configure
make
sudo make install
magic
```
<img width="1854" height="827" alt="image" src="https://github.com/user-attachments/assets/8f5e8715-f095-4830-9a97-18ede3e6bfa9" />

### 5. OpenLane

##### Step 1 - Install Docker

```bash
# Remove legacy installations (optional)
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install dependencies
sudo apt-get update
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Add Docker’s GPG key and repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
   https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Confirm installation
sudo docker run hello-world
```
<img width="1857" height="580" alt="image" src="https://github.com/user-attachments/assets/d9a551e7-b9be-4388-a839-48df393fa8a1" />

#### Step 2 - Make Docker Available Without Root

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot # REBOOT!
```
#### Step 3 - Install OpenLane
##### Required Packages

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
make
make test

# To enter the Dockerized OpenLane environment
make mount
```
<img width="1857" height="287" alt="image" src="https://github.com/user-attachments/assets/fc7310f6-450d-47a1-a9ac-7cfdaa105967" />

## References
- https://github.com/YosysHQ/yosys.git
- https://github.com/steveicarus/iverilog.git
- https://github.com/RTimothyEdwards/magic
- https://github.com/The-OpenROAD-Project/OpenLane
  
</details>

</details>
