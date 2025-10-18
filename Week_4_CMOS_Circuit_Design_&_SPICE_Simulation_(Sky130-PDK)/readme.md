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

> Below is a simplified example of a delay lookup table for an inverter (`INVX1`):

```liberty
cell (INVX1) {
    pin (A) {
        direction : input;
        capacitance : 0.005;
    }

    pin (Y) {
        direction : output;
        function : "(!A)";
        max_capacitance : 0.1;

        timing() {
            related_pin : "A";
            timing_sense : negative_unate;

            cell_rise (delay_template_2d) {
                index_1 ("10, 30, 50, 70, 90");         // Input Slew (ps)
                index_2 ("10, 30, 50, 70, 90, 110");     // Output Load (fF)
                values (
                    "0.05, 0.07, 0.09, 0.11, 0.13, 0.15",
                    "0.06, 0.08, 0.10, 0.12, 0.14, 0.16",
                    "0.07, 0.09, 0.11, 0.13, 0.15, 0.17",
                    "0.08, 0.10, 0.12, 0.14, 0.16, 0.18",
                    "0.09, 0.11, 0.13, 0.15, 0.17, 0.19"
                );
            }
        }
    }
}
```
| Delay values - **CBUF1** | Delay values - **CBUF2** |
|-----------------|-----------------|
| <img width="810" height="447" alt="image" src="https://github.com/user-attachments/assets/40d3665c-1429-4714-af6f-3990ad473361" /><br>**Input Slew = 40 ps**<br>**Output Load = 60 fF**<br>**Delay Value** = However, 60 fF is **not explicitly listed** in the LUT <br> <br>The closest columns are: <br> x₉ - 50 fF <br> x₁₀ -  70 fF <br>To estimate the delay at **60 fF**, we perform linear interpolation between **x₉** and **x₁₀**: <br> Delay_60fF = x9 + [(60fF - 50fF) / (70fF - 50fF)] * (x10 - x9)| <img width="788" height="449" alt="image" src="https://github.com/user-attachments/assets/b5303f98-24fd-471b-8a04-086b9fb6cb3e" /><br><br>**Input Slew = 60 ps**<br>**Output Load = 50 fF**<br> <br>Fortunately, **50 fF** is explicitly listed in the LUT <br>So we can directly pick the delay value from the table<br> <br>60 ps(slew)- 50 fF(load) - y₁₅(delay)<br> <br> Delay_CBUF2 = y_15|

### Interpolation and Extrapolation in Delay Calculation

In real-world **Static Timing Analysis (STA)**, it’s uncommon for the required input slew and output load to match the exact entries in the **cell delay lookup tables (LUTs)**.  
To estimate delay values accurately, **interpolation** or **extrapolation** techniques are applied.

#### Interpolation
- **Used when:** The required values **fall between** two known points in the LUT.  
- **Purpose:** To estimate delay or transition values **within the characterized range**.  
- **Method:** STA tools perform **linear** or **bilinear interpolation** between neighboring entries based on:
  - Input slew  
  - Output load  
- **Accuracy:** High — since it stays within the characterised (measured) data range.
  
$$
Delay_{est} = D_1 + \frac{(X - X_1)}{(X_2 - X_1)} \times (D_2 - D_1)
$$

Where:
- \( D_1, D_2 \): Known delay values from the LUT  
- \( X_1, X_2 \): Corresponding known input slew or output load points  
- \( X \): The required (intermediate) value for which delay is being estimated  



#### Extrapolation
- **Used when:** The required slew or load **falls outside** the bounds of the LUT  
  (e.g., >110 fF or <10 fF).  
- **Purpose:** To estimate delay values **beyond the characterized range**.  
- **Method:** Extends the slope of the nearest known data points to estimate new values.  
- **Accuracy:** Lower — results can **deviate from SPICE simulation** or real silicon.  

$$
Delay_{ext} = D_1 + \frac{(X - X_1)}{(X_2 - X_1)} \times (D_2 - D_1)
$$

Where:
- \( D_1, D_2 \): Delay values from the **nearest two known LUT entries**  
- \( X_1, X_2 \): Corresponding **input slew or output load** points  
- \( X \): The **out-of-range** value for which the delay is being estimated
  
> **Note:**  
> Extrapolated delay values should be used **only when necessary**.  
> Designers should aim to keep analysis **within the characterized LUT range**  
> for more **reliable and consistent timing results**.

           
Below are the questions we aim to answer after the end of this week:

#### 1️⃣ Where does the delay of a cell actually come from?

#### 2️⃣ Are the delay models accurate?

#### 3️⃣ How do we verify that what STA is reporting is correct?

### NMOS and PMOS Transistors

| NMOS | PMOS |
|------|------|


**NMOS** stands for **N-channel Metal Oxide Semiconductor** 

<img width="551" height="378" alt="nmos" src="https://github.com/user-attachments/assets/b9015ff4-d6d9-4a31-b979-0767f5eb7c22" />

- An NMOS transistor is a 4-terminal device: 
```
1. Source (S)
2. Drain (D)
3. Gate (G)
4. Substrate or Body (B)
```
- Consists of P-substrate, Gate oxide (SiO2), n+ diffusion region, Poly-silicon
- In p-type substrates, the majority carriers are holes and the minority carriers are electrons
  

Case i : 

<img width="551" height="378" alt="nmos1" src="https://github.com/user-attachments/assets/c207284f-64d2-4d94-85e8-f328ca509ad1" />
</br>

When **V<sub>GS</sub> = 0**:

- The **source, drain, and bulk (body)** are all connected to **ground**.  
- The **substrate-to-source (B–S)** and **substrate-to-drain (B–D)** each form a **PN junction diode**.  
- Both diodes are **reverse-biased**, because the voltage difference is 0 V.

Looking at it from **Ohm's Law**:

- The resistance is given by `R = V / I`.  
- Here, `V = 0` and `I = 0`, so the resistance becomes **very large**—effectively **infinite**.

Implications for the MOSFET:

- The device shows **very high resistance** between source and drain.  
- **No current flows** through the device.  
- **No conductive channel** is formed between the source and drain.

> **Summary:** With V<sub>GS</sub> = 0, the MOSFET remains **OFF**, acting like an open circuit.

case II : 

<img width="551" height="378" alt="nmos2" src="https://github.com/user-attachments/assets/12f03ad9-2f32-48fc-bb0c-9acc97d53917" />

When a **small positive voltage** is applied to the gate of a MOS structure:

- The **metal gate** becomes positively charged.  
- The **oxide layer** between the gate and the substrate acts as a **dielectric**, so together with the p-type substrate, they form a **capacitor**.

This positive voltage on the gate affects the p-type substrate:

- It **repels the majority carriers (holes)** from the surface.  
- As a result, **immobile negative ions** (the acceptor atoms) are left behind, creating a region of **negative charge**.  
- **Electrons**, which are the minority carriers, are slightly **attracted toward the surface**, but at this stage, there aren’t enough to form a **conduction channel**.

Because of this separation of charges:

- The p-type substrate near the surface behaves similarly to a **reverse-biased PN junction**.  
- This leads to the formation of a **depletion region**, where mobile carriers are scarce and only immobile ions remain.
































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
  * Setup/Hold margins derived from transistor behaviour
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
