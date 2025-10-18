# Week 4 – CMOS Circuit Design & SPICE Simulation (Sky130-PDK)

<details>
 <summary>Day 1: Introduction to Circuit Design & SPICE Simulations</summary>
<br>

## Circuit Design and SPICE Simulation

**Circuit Design** is the process of creating the **functionality of an electronic system** — it defines what the circuit should do and how it will accomplish this.

![Circuit Design](https://github.com/user-attachments/assets/bd30bae7-41e9-4ea9-8848-864318cbe27f)

The type of transistors used (**NMOS** and **PMOS**), their sizes (**W/L ratio**), and the way they’re connected all depend on the **required functionality**.

**SPICE simulation** is used to study how a circuit performs **before it is physically built**.  
It allows designers to see the **circuit’s output characteristics—such as voltage, current, and delay**—by displaying them as **waveforms on a graph**.

![SPICE Waveforms](https://github.com/user-attachments/assets/65ca0258-5a49-43a4-9387-8eb8c0878a16)


### Why we need SPICE

**SPICE (Simulation Program with Integrated Circuit Emphasis)** is essential because it allows us to find the **real, accurate delay values** of circuits *before manufacturing*.

<img width="1640" height="543" alt="image" src="https://github.com/user-attachments/assets/9108b8a9-dbb9-4412-a726-ab7fa346176a" />

Consider a circuit with several **buffers**.  
Each buffer is built using different **NMOS** and **PMOS** transistors and drives a different **load**.  
Because of this, each buffer type (e.g., **Type 1** and **Type 2**) has **different delay values** — these depend on:
- Circuit design  
- Transistor sizes  
- Loading conditions  

SPICE simulations are used to measure these delays by analysing how the circuit responds under various:
- **Input slews** (signal transition times)  
- **Output loads** (capacitive loads)  
> The resulting **delay values** are then stored in **lookup tables**.

| lookup table 1 | lookup table 2 |
|-----------|-----------|
| <img width="830" height="453" alt="image" src="https://github.com/user-attachments/assets/d52f1ff9-a7cd-4242-a99b-b9ae91f48406" />  | <img width="842" height="463" alt="image" src="https://github.com/user-attachments/assets/12e13c45-cab0-4f9d-8b6a-f12a9266de76" />|

| Delay values - 1 | Delay values - 2 |
|-----------------|-----------------|
| <img width="810" height="447" alt="image" src="https://github.com/user-attachments/assets/40d3665c-1429-4714-af6f-3990ad473361" /><br>i/p slew = 40ps<br>o/p load = 60fF<br>delay value = Interpolation & Extrapolation of values | <img width="788" height="449" alt="image" src="https://github.com/user-attachments/assets/b5303f98-24fd-471b-8a04-086b9fb6cb3e" /><br>i/p slew = 40ps<br>o/p load = 60fF<br>delay value = y15 |
           
Below are the questions we aim to answer after the end of this week:

#### 1️⃣ Where does the delay of a cell actually come from?

#### 2️⃣ Are the delay models accurate?

#### 3️⃣ How do we verify that what STA is reporting is correct?

### NMOS and PMOS Transistors

| NMOS | PMOS |
|------|------|


**NMOS** stands for **N-channel Metal Oxide Semiconductor** 
Electrons are the majority carriers
An NMOS transistor is a 4-terminal device: 
```
1. Source (S)
2. Drain (D)
3. Gate (G)
4. Substrate or Body (B)
```








































It’s a type of MOSFET (Metal Oxide Semiconductor Field Effect Transistor) that uses electrons as the charge carriers.

An NMOS transistor has:

Source (S)

Drain (D)

Gate (G)

Substrate or Body (B) – typically p-type silicon

A thin oxide layer (SiO₂) separates the gate from the substrate.

When a positive voltage is applied to the gate, it attracts electrons near the surface under the oxide, forming an n-type channel between the source and drain.


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

## Connection to Static Timing Analysis (STA)

When tools like **Static Timing Analysis (STA)** check circuit timing, they **don’t calculate delays using simple formulas**.  
Instead, they **read delay numbers directly** from the SPICE-generated tables to ensure **timing accuracy**.

## Importance of Correct SPICE Setup

If the SPICE setup is incorrect — for example, if:

- Transistor models are wrong  
- Load values are unrealistic  
- Input transition times are inaccurate  

Then the resulting **STA results will also be inaccurate** and won’t match **real silicon behaviour**.

## Reference
- https://sourceforge.net/projects/ngspice/files/
- https://github.com/kunalg123/sky130CircuitDesignWorkshop.git


</details>
