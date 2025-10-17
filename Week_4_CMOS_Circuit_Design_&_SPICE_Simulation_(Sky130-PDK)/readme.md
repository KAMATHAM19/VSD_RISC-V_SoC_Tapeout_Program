# Week 4 – CMOS Circuit Design & SPICE Simulation (Sky130-PDK)

<details>
 <summary>Day 1: Introduction to Circuit Design & SPICE Simulations</summary>
<br>
 


## Installation of NGSPICE


Download the tarball from [SourceForge](https://sourceforge.net/projects/ngspice/files/) to your local directory.  
Then unpack it using:

```bash
tar -zxvf ngspice-44.tar.gz 
cd ngspice-44 
mkdir release 
cd release 
../configure --with-x --with-readline=yes --disable-debug 
 make 
 sudo make install
ngspice
```

<img width="1848" height="330" alt="image" src="https://github.com/user-attachments/assets/8ddd04f0-4955-45c4-a061-1a9ebcf343b4" />


## Workshop Collaterals

```
git clone https://github.com/kunalg123/sky130CircuitDesignWorkshop.git
cd sky130CircuitDesignWorkshop
ls
```
<img width="920" height="427" alt="image" src="https://github.com/user-attachments/assets/27cc04de-0551-4a41-bd44-a1ec821c98bb" />

Experiment 1: MOSFET Behaviour (Id vs Vds)


Title: From Transistor Behavior to Timing Analysis (STA): The CMOS Design Flow

Mind-Map Structure

Level 1:
Transistor Behavior (Device Physics)

↳ Foundation: individual NMOS/PMOS operation

Branches:
- I–V Characteristics (Id vs. Vds / Vgs)
  * Linear & Saturation regions
  * Threshold voltage (Vt) extraction
  * Velocity saturation in short-channel devices

- Device Parameters
  * W/L ratio → Drive strength
  * Tox, doping, channel length → Vt variation
  * Supply voltage (VDD) → Switching speed

Level 2:
CMOS Inverter Behavior (Circuit Level)

↳ Combination of NMOS + PMOS devices

Branches:
- VTC Curve (Vout vs. Vin)
  * Defines switching threshold (Vm)
  * Basis for noise margins (NMH, NML)
- Transient Response
  * Rise/fall delay
  * Load capacitance and drive current impact
- Noise Margin Analysis
  * Determines logical robustness

Level 3:
Timing Behavior (Digital Logic Level)

↳ Behavior of gates in real timing conditions

Branches:
- Propagation Delays (tPHL, tPLH)
  * Used in timing libraries (.lib)
- Variation Effects
  * Delay, threshold, and noise margins under PVT corners
- Power Supply Variation Impact
  * Dynamic delay & power trade-off

Level 4:
Static Timing Analysis (System Level)

↳ How EDA tools use transistor data to verify chip timing

Branches:
- From SPICE → .lib Models
 * Extracted delay tables
 * Slew, load, and drive strength dependencies
- STA Concepts
  * Arrival time, required time, slack
  * Setup/Hold margins derived from transistor behavior
- Goal:
Accurate timing closure under variation and process constraints.


```scss

Transistor Physics
      ↓
Device I–V Characteristics
      ↓
CMOS Inverter (VTC + Transient)
      ↓
Delay, Noise Margin, Variation
      ↓
Timing Models (.lib)
      ↓
Static Timing Analysis (STA)

```



## Reference
- https://sourceforge.net/projects/ngspice/files/
- https://github.com/kunalg123/sky130CircuitDesignWorkshop.git


</details>
