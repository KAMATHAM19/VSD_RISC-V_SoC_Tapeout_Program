# Week 4 – CMOS Circuit Design & SPICE Simulation (Sky130-PDK)

<details>
 <summary>Introduction to Circuit Design & SPICE Simulations</summary>
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
- \( D1, D2 \): Known delay values from the LUT  
- \( X1, X2 \): Corresponding known input slew or output load points  
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
- \( D1, D2 \): Delay values from the **nearest two known LUT entries**  
- \( X1, X2 \): Corresponding **input slew or output load** points  
- \( X \): The **out-of-range** value for which the delay is being estimated
  
> **Note:**  
> Extrapolated delay values should be used **only when necessary**.  
> Designers should aim to keep analysis **within the characterized LUT range**  
> for more **reliable and consistent timing results**.

           
Below are the questions we aim to answer after the end of this week:

#### 1️⃣ Where does the delay of a cell actually come from?

#### 2️⃣ Are the delay models accurate?

#### 3️⃣ How do we verify that what STA is reporting is correct?
</details>

<details>
 <summary> NMOS Transistor</summary>
 
## NMOS Transistor

**NMOS** stands for **N-channel Metal Oxide Semiconductor** 

<div align="center">
<img width="551" height="378" alt="nmos" src="https://github.com/user-attachments/assets/b9015ff4-d6d9-4a31-b979-0767f5eb7c22" />
</div>

- An NMOS transistor is a 4-terminal device: 
```
1. Source (S)
2. Drain (D)
3. Gate (G)
4. Substrate or Body (B)
```
- Consists of P-substrate, Gate oxide (SiO2), n+ diffusion region, Poly-silicon
- In p-type substrates, the majority carriers are holes and the minority carriers are electrons
  
Case I: When **V<sub>GS</sub> = 0**:

<div align="center">
<img width="551" height="378" alt="nmos1" src="https://github.com/user-attachments/assets/c207284f-64d2-4d94-85e8-f328ca509ad1" />
</div>

- The **source, drain, and bulk (body)** are all connected to **ground**.  
- The **substrate-to-source (B–S)** and **substrate-to-drain (B–D)** each form a **PN junction diode**.  
- Both diodes are **reverse-biased**, because the voltage difference is 0 V.

Looking at it from **Ohm's Law**:

- The resistance is given by `R = V / I`.  
- Here, `V = 0` and `I = 0`, so the resistance becomes **very large**—effectively **infinite**.

### Implications for the MOSFET:

- The device shows **very high resistance** between source and drain.  
- **No current flows** through the device.  
- **No conductive channel** is formed between the source and drain.

> **Summary:** With V<sub>GS</sub> = 0, the MOSFET remains **OFF**, acting like an open circuit.

Case II: 

<div align="center">
<img width="551" height="378" alt="nmos2" src="https://github.com/user-attachments/assets/12f03ad9-2f32-48fc-bb0c-9acc97d53917" />
</div>

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

Case III:

<div align="center">
<img width="551" height="378" alt="nmos3" src="https://github.com/user-attachments/assets/676d4b2e-c6d2-4c46-a8dd-d2316c6c7447" />
</div>

When we **increase the gate voltage (V<sub>GS</sub>)** in an **NMOS transistor** (with a p-type substrate):

- The **depletion region** under the gate becomes **wider**, as **holes** (the majority carriers in the p-type substrate) are **repelled** from the surface.  
- **Free electrons** (the minority carriers) begin to gather near the surface, replacing the repelled holes.  
- At the **Si–SiO₂ interface**, the **p-type substrate** is gradually converted into an **n-type region**.  
- This phenomenon is called **strong inversion** or **surface inversion**.

- The value of **V<sub>GS</sub>** at which strong inversion occurs is known as the **threshold voltage (V<sub>T</sub>)**.

Increasing V<sub>GS</sub> Beyond Threshold

- When **V<sub>GS</sub>** is increased **beyond the threshold voltage**, there is **no further significant increase** in the depletion width, since the region is already depleted of holes.  
- Instead, **electrons** (negatively charged carriers) from the **heavily doped n⁺ source region** are **attracted toward the gate region**, forming a **thin n-type channel** just beneath the oxide layer.  
- As the gate voltage continues to rise, **more electrons accumulate**, and the **channel width increases**, improving conductivity.  
- A continuous **n-channel** now connects the **source** and **drain**, allowing **current (I<sub>D</sub>)** to flow when a voltage is applied between them.  
- The **conductivity of this channel** is **modulated by the gate voltage**, meaning higher V<sub>GS</sub> produces a stronger (lower resistance) channel.

The **Body Effect** (also called the **Substrate Bias Effect**) describes how the **threshold voltage (V<sub>T</sub>)** of an NMOS transistor changes when the **source-to-body voltage (V<sub>SB</sub>)** is not zero.

<div align="center">
<img width="512" height="201" alt="vsb" src="https://github.com/user-attachments/assets/33d115cc-60fe-4b55-ab6f-4bd224905ba1" />
</div>

This comparison shows NMOS operation under two cases:  
1. **V<sub>SB</sub> = 0**  
2. **V<sub>SB</sub> > 0**
   
 <div align="center"> 
<img width="512" height="201" alt="vsb1" src="https://github.com/user-attachments/assets/5fac33c1-1bc1-4b48-aa7b-9df6f446a5da" />
 </div>

Case I: V<sub>SB</sub> = 0

- The **source**, **drain**, and **body (substrate)** are at the same potential.  
- When **V<sub>GS</sub>** increases, **normal channel formation** occurs.  
- The **semiconductor surface** inverts to **n-type** when the gate voltage reaches the **threshold voltage (V<sub>T0</sub>)**.  

> Channel forms when  **V<sub>GS</sub> = V<sub>T0</sub>**

Case II: V<sub>SB</sub> > 0 (Positive Substrate Bias)

- A **reverse bias** is introduced between the **source** and the **body (substrate)**.  
- This **increases the depletion region width** near the source.  
- As a result:
  - The **threshold voltage (V<sub>T</sub>)** **increases**.  
  - The **depletion layer** becomes slightly wider near the source.  
  - **More gate voltage (V<sub>GS</sub>)** is required to **turn ON** the transistor and achieve **strong inversion**.

> Channel forms when  **V<sub>GS</sub> = V<sub>T0</sub> + ΔV<sub>T</sub>**

> This effect is known as the **Body Effect** or **Substrate Bias Effect**.

**Threshold Voltage Equation**

The modified threshold voltage is given by:

**V<sub>T</sub> = V<sub>T0</sub> + γ [ √(|−2ϕ<sub>F</sub> + V<sub>SB</sub>|) − √(|−2ϕ<sub>F</sub>|) ]**

where:

- **V<sub>T</sub>** → Threshold voltage with body bias  
- **V<sub>T0</sub>** → Threshold voltage when V<sub>SB</sub> = 0 (process-dependent)  
- **γ (gamma)** → Body-effect coefficient, expresses how V<sub>T</sub> changes with body bias  
- **ϕ<sub>F</sub>** → Fermi potential, related to substrate doping  

Body Effect Coefficient (γ)

**γ = √( (2 × q × ε<sub>Si</sub> × N<sub>A</sub>) / C<sub>ox</sub> )**

Where:

| Symbol | Meaning | Typical Value / Notes |
|---------|----------|-----------------------|
| **q** | Electron charge | 1.6 × 10⁻¹⁹ C |
| **ε<sub>Si</sub>** | Permittivity of silicon | 11.7 × ε₀ |
| **N<sub>A</sub>** | Acceptor doping concentration | Depends on substrate |
| **C<sub>ox</sub>** | Oxide capacitance | C<sub>ox</sub> = ε<sub>ox</sub> / t<sub>ox</sub> |
| **ε<sub>ox</sub>** | Permittivity of SiO₂ | ≈ 3.45 × 10⁻¹¹ F/m |
| **t<sub>ox</sub>** | Oxide thickness | Process-dependent |

Fermi Potential (ϕ<sub>F</sub>)

**ϕ<sub>F</sub> = −ϕ<sub>T</sub> × ln(n<sub>i</sub> / N<sub>A</sub>)**

or equivalently,

**2ϕ<sub>F</sub> = −2ϕ<sub>T</sub> × ln(n<sub>i</sub> / N<sub>A</sub>)**

Where:
- **n<sub>i</sub>** = Intrinsic carrier concentration  
- **N<sub>A</sub>** = Substrate doping concentration  
- **ϕ<sub>T</sub>** = Thermal voltage = (kT / q)

> As **V<sub>SB</sub>** increases, the **threshold voltage (V<sub>T</sub>)** also increases.

### NMOS Transistor — Resistive (Linear) Region of Operation

**Condition:**  
V<sub>GS</sub> > V<sub>T</sub> and **small** V<sub>DS</sub>

<div align="center">
<img width="1024" height="683" alt="image" src="https://github.com/user-attachments/assets/cca4724f-2d5c-43c1-8425-8d71873666a4" />
</div>

- When **V<sub>GS</sub> ≥ V<sub>T</sub>**, a **channel is formed** due to strong inversion.  
- Charge carriers (electrons, for NMOS) flow **from the source to the drain**.  
- The **local potential** along the channel is represented as **v(x)**.  
- The **gate-to-channel voltage** at a point *x* is:  
  **V<sub>GS</sub> − V(x)**  

The **induced charge density** (Q<sub>i</sub>) in the channel is proportional to **(V<sub>GS</sub> − V<sub>T</sub>)**.

Channel Charge Relationship

The **local inversion charge per unit area** is:

**Q<sub>i</sub>(x) = −C<sub>ox</sub> × ([V<sub>GS</sub> − V(x)] − V<sub>T</sub>)**

Where:
- **C<sub>ox</sub>** → Oxide capacitance per unit area  
- **V(x)** → Potential at point *x* along the channel  
- **V<sub>GS</sub>** → Gate-to-source voltage  
- **V<sub>T</sub>** → Threshold voltage  

The **effective channel length (L)** and the **voltage profile** along the x-axis determine the **current flow**.

> In this region, the MOSFET behaves like a **voltage-controlled resistor**.

Current Components

1. **Drift Current**
- Dominant in the **resistive (linear)** region.  
- Caused by the **electric field** established by **V<sub>DS</sub>** across the channel.  
- Electrons are accelerated through the channel by this field.

2. **Diffusion Current**
- Due to **carrier concentration differences** along the channel.  
- Usually much smaller than the drift current in this region.


### Drift Current 

In the resistive region (V<sub>GS</sub> > V<sub>T</sub>, small V<sub>DS</sub>):

**Drift current (I<sub>D</sub>)** is given by:

**I<sub>D</sub> = (carrier velocity) × (available charge) × (channel width)**

or equivalently,

**I<sub>D</sub> = −v<sub>n</sub>(x) · Q<sub>i</sub>(x) · W**

Where:
- **v<sub>n</sub>(x)** = electron drift velocity = μ<sub>n</sub> × E = μ<sub>n</sub> × (dv/dx)  
- **μ<sub>n</sub>** = electron mobility  
- **W** = channel width  

Substitute Q<sub>i</sub>(x):

**I<sub>D</sub> = μ<sub>n</sub> · C<sub>ox</sub> · W · ([V<sub>GS</sub> − v(x)] − V<sub>T</sub>) · (dv/dx)**

Integration Across the Channel

Integrate from:
- **x = 0 → L**, and  
- **v = 0 → V<sub>DS</sub>**

![linerar](https://github.com/user-attachments/assets/f56abef8-fabc-4369-b5fd-ab3cd575f127)

Since I<sub>D</sub> is constant along the channel:

**∫₀ᴸ I<sub>D</sub> dx = μ<sub>n</sub> C<sub>ox</sub> W ∫₀ⱽᴰˢ ([V<sub>GS</sub> − v] − V<sub>T</sub>) dv**

Simplifying:

**I<sub>D</sub> · L = μ<sub>n</sub> C<sub>ox</sub> W [ (V<sub>GS</sub> − V<sub>T</sub>)V<sub>DS</sub> − (V<sub>DS</sub>² / 2) ]**

Simplified Drain Current Equation

Define **k′<sub>n</sub> = μ<sub>n</sub> C<sub>ox</sub>** (process transconductance parameter)

Then:

**I<sub>D</sub> = k′<sub>n</sub> (W / L) [ (V<sub>GS</sub> − V<sub>T</sub>)V<sub>DS</sub> − (V<sub>DS</sub>² / 2) ]**

Or, using the **gain factor (k<sub>n</sub>)**:

**k<sub>n</sub> = k′<sub>n</sub> × (W / L)**

Final form:

> **I<sub>D</sub> = k<sub>n</sub> [ (V<sub>GS</sub> − V<sub>T</sub>)V<sub>DS</sub> − (V<sub>DS</sub>² / 2) ]**

 Numerical Example

**Given:**

| Parameter | Symbol | Value |
|------------|---------|--------|
| Threshold voltage | V<sub>T</sub> | 0.454 V |
| Drain–Source voltage | V<sub>DS</sub> | 0.05 V |
| Gate–Source voltage | V<sub>GS</sub> | 1.0 V |

Step 1: Check Region of Operation

Compute:

**ΔV = V<sub>GS</sub> − V<sub>T</sub> = 1.0 − 0.454 = 0.546 V**

Compare:

**V<sub>DS</sub> = 0.05 V ≤ 0.546 V**
 Therefore, the transistor is operating in the **linear (resistive) region**.

Step 2: Use Linear Region Formula

The drain current in the **linear region** is given by:

**I<sub>D</sub> = Kn [ (V<sub>GS</sub> − V<sub>T</sub>)V<sub>DS</sub> − (V<sub>DS</sub>² / 2) ]**

Substitute the known values:

**I<sub>D</sub> = Kn [ (0.546)(0.05) − (0.05² / 2) ]**

Step 3: Simplify the Expression

**I<sub>D</sub> = Kn [ (0.02730) − (0.00125) ]**  
**I<sub>D</sub> = Kn × 0.02605**

Table (one-step numerical results)

| V<sub>GS</sub> (V) | ΔV = V<sub>GS</sub> − V<sub>T</sub> (V) | Region | I<sub>D</sub> (in terms of Kn) |
|--------------------:|-----------------------------------------:|:------:|-------------------------------:|
| 0.5                 | 0.05                                     | Linear (edge) | **0.00125 · Kn** |
| 1.0                 | 0.55                                     | Linear | **0.02625 · Kn** |
| 1.5                 | 1.05                                     | Linear | **0.05125 · Kn** |
| 2.0                 | 1.55                                     | Linear | **0.07625 · Kn** |
| 2.5                 | 2.05                                     | Linear | **0.10125 · Kn** |

**How each I<sub>D</sub> was computed (example for V<sub>GS</sub>=1.0):**

- ΔV = 1.0 − 0.45 = 0.55  
- (ΔV)·V<sub>DS</sub> = 0.55 × 0.05 = 0.02750  
- V<sub>DS</sub>² / 2 = 0.05² / 2 = 0.00125  
- Bracket = 0.02750 − 0.00125 = 0.02625  
- I<sub>D</sub> = **0.02625 · Kn**

- **ΔV = V<sub>GS</sub> − V<sub>T</sub>** is the gate overdrive. It controls how strong the inversion layer (n-channel) is. Larger ΔV → more electrons at the surface → lower channel resistance → higher I<sub>D</sub>.
- For the given V<sub>DS</sub> = 0.05 V, all tested V<sub>GS</sub> values satisfy **V<sub>DS</sub> ≤ ΔV**, so the device stays in the **linear (resistive) region** for every row. (When V<sub>DS</sub> > ΔV, the device would enter **saturation**.)
- The drain current in the linear region is approximately proportional to **ΔV·V<sub>DS</sub>** (minus the small V<sub>DS</sub>²/2 correction). Because V<sub>DS</sub> is small and fixed, **I<sub>D</sub> increases roughly linearly with ΔV (hence with V<sub>GS</sub>)**.
- The V<sub>GS</sub>=0.5 case is the **edge** case: ΔV = 0.05 equals V<sub>DS</sub>, so the transistor is just at the boundary between linear and saturation — it produces a very small current (0.00125·β).
- To convert the symbolic results to **amperes**, multiply each entry by the numerical value of **β** for the device/process.

When **(V<sub>GS</sub> − V<sub>DS</sub>) > V<sub>T</sub>**,  
a **conductive channel** is formed between the **source** and **drain**.


![l1](https://github.com/user-attachments/assets/d626e1ff-d3e9-4894-80f6-4f471197cd10)


Let’s consider an **NMOS transistor** where:

![l2](https://github.com/user-attachments/assets/b0158821-1feb-4af0-a9c5-217dea1fc2d9)

- **V<sub>GS</sub> = 1.0 V**  
- **V<sub>DS</sub> = 0.55 V**  
- **V<sub>T</sub> = 0.45 V**

At the **source end** of the channel:
- The gate-to-source voltage is **V<sub>GS</sub> = 1.0 V**.
- Since **V<sub>GS</sub> > V<sub>T</sub>**, an **n-type inversion layer** is formed, allowing electrons to flow.

At the **drain end** of the channel:
- The local channel voltage is reduced by **V<sub>DS</sub>**.  
- The **effective gate-to-channel voltage** becomes:


V_GC = V_GS - V_DS = 1.0 - 0.55 = 0.45 V

- Notice that **V<sub>GC</sub> = V<sub>T</sub>**, meaning the gate-to-channel voltage at the drain end has just reached the **threshold voltage**.

- When **V<sub>GC</sub> = V<sub>T</sub>**, the **inversion layer disappears** at the **drain side**.  
- This point is known as **pinch-off** — the channel **just ends** at the drain.  
- Beyond this point, increasing **V<sub>DS</sub>** further does **not significantly increase current**, because the **channel can’t extend any further** into the drain region.


![l3](https://github.com/user-attachments/assets/07b98bb2-11f8-4f3d-ade3-6eed78070113)


### Pinch-Off Condition

When the drain-source voltage (Vds) is increased further, the channel near the drain **disappears**. This occurs at the **pinch-off condition**, which is mathematically expressed as:

**VDS ≥ VGS - VT**

Where:  
- Vgs = Gate-Source Voltage  
- Vt = Threshold Voltage  

At this point, the **voltage along the channel** remains essentially **constant**:

**Vchannel ≈ VGS - VT**

Drain Current Before Pinch-Off

Before pinch-off, the drain current is given by:

**ID = Kn · (VGS - VT) · VDS**

Where Kn is the process transconductance factor.

At pinch-off, replace Vds with (Vgs - Vt):

**ID = (Kn / 2) · (VGS - VT)²**

Transistor Parameters

The parameter Kn is related to device geometry and mobility:

**Kn = k'n · (W / L)**

Where:  
- k'_n = μ_n · C_ox (process transconductance)  
- W = Channel Width  
- L = Channel Length  

Thus, the **saturated drain current** can also be written as:

**ID = (k'n / 2) · (W / L) · (VGS - VT)²**

### Channel Length Modulation (λ)

When Vds increases beyond pinch-off, the **depletion region at the drain expands**, effectively **shortening the channel**. This effect is called **channel-length modulation** and is modeled by the parameter λ.  

The drain current, considering channel-length modulation, is:

**ID = (k'n / 2) · (W / L) · (VGS - VT)² · (1 + λ · VDS)**

> λ increases as the channel length L decreases.  
> Shorter channel → larger λ → more pronounced channel-length modulation.
</details>



<details>
 <summary> Installation of NGSPICE and SPICE  </summary>

## Installation of NGSPICE and SPICE

### Installation of NGSPICE

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


### Workshop Collaterals

```
git clone https://github.com/kunalg123/sky130CircuitDesignWorkshop.git
cd sky130CircuitDesignWorkshop
ls
```
<img width="920" height="427" alt="image" src="https://github.com/user-attachments/assets/27cc04de-0551-4a41-bd44-a1ec821c98bb" />

**SPICE (Simulation Program with Integrated Circuit Emphasis)**, developed at **UC Berkeley**, is a fundamental tool for simulating analogue and mixed-signal circuits.  
It solves **nonlinear equations** for components like:

- Transistors  
- Resistors
- Capacitors
  
SPICE has evolved into several tools, both open-source and commercial:

- **Free:** Ngspice, LTSpice  
- **Commercial:** HSPICE, PSPICE  

<img width="1869" height="992" alt="image" src="https://github.com/user-attachments/assets/7cbfc064-4026-46ad-911d-f44a45e075d9" />


A **SPICE deck** is the input file that defines what the simulator should run.  
It includes:

1. **Netlist** – List of components and their interconnections  
2. **Device Models & Parameters** – Defines transistor or component behavior  
3. **Initial Conditions** – Specifies starting voltages or states  
4. **Inputs (Stimulus)** – Voltage/current sources for testing  
5. **Simulation Options & Commands** – Specify the type of analysis (e.g., DC, AC, transient)

1. **SPICE Netlist**
<img width="778" height="521" alt="image" src="https://github.com/user-attachments/assets/8f488612-3b2b-40c3-847f-f16e8173f68d" />

```spice
M1 VDD n1 0 0 nmos w=1.8u L=1.2u
R1 in n1 55
VDD vdd 0 2.5
Vin in 0 2.5
```
| **Element** | **Syntax / Meaning** | **Description** |
|--------------|----------------------|-----------------|
| **M1** | `M<name> Drain Gate Source Bulk Model W= L=` | Defines an **NMOS transistor**.<br>In this example:<br>→ Drain = `VDD`<br>→ Gate = `n1`<br>→ Source = `0` (ground)<br>→ Bulk = `0` (ground)<br>→ Uses model **nmos**<br>→ Width = **1.8 µm**, Length = **1.2 µm** |
| **R1 in n1 55** | `R<name> Node1 Node2 Resistance` | A **resistor** between nodes `in` and `n1` with resistance **55 Ω**. |
| **VDD vdd 0 2.5** | `V<name> +node -node Value` | A **DC voltage source** providing **2.5 V** between `vdd` and ground. |
| **Vin in 0 2.5** | `V<name> +node -node Value` | Another **voltage source**, possibly representing an **input signal**. |

2. **Technology File (Model File)**
A technology file (also called a model file) defines the electrical behavior of devices like transistors, resistors, and capacitors.

It provides process-specific parameters that describe how real silicon behaves

```spice
.MODEL nmos NMOS (Tox= , Vtho= , u0= , GAMMA= )
.end1
```
| **Parameter** | **Symbol** | **Description** | **Impact on Device Behavior** |
|----------------|-------------|-----------------|-------------------------------|
| **Threshold Voltage** | `Vt` or `Vtho` | The minimum gate-to-source voltage required to turn the MOSFET **on**. | Determines **switching voltage** and **drive strength**. |
| **Body Effect Coefficient** | `γ` (Gamma) | Models how the **bulk voltage** influences the **threshold voltage**. | Affects performance when the source and substrate are at different potentials. |
| **Oxide Thickness** | `TOX` | The physical thickness of the transistor’s **gate oxide layer**. | Controls **gate capacitance**, which affects speed and power. |
| **Carrier Mobility** | `U0` | Indicates how easily charge carriers (electrons/holes) move in the channel. | Higher mobility ⇒ **faster switching** and **higher drive current**. |
| **Other Process Parameters** | — | Include factors like channel length modulation (λ), surface potential (Φ), and junction capacitances. | Used for **fine-tuning** device accuracy in simulations. |
> These parameters depend on the CMOS technology node (e.g., 180 nm, 65 nm, 25 nm)

```
.lib "xxx_025um_model.mod" CMOS_MODELS
```
This line tells SPICE to load transistor model data from an external file (e.g., xxx_025um_model.mod), corresponding to a 0.25 µm CMOS technology.

- .lib — Loads a library file containing multiple models (NMOS, PMOS, etc.).
- "xxx_025um_model.mod" — File path to the model definitions.
- CMOS_MODELS — Specifies which section or model set to use.

3. **Simulation Commands**

```

.op
.dc Vin 0 2.5 0.1
.tran 1n 100n
```
| **Command** | **Type of Analysis** | **Purpose / Description** | **Typical Usage Example** |
|--------------|----------------------|----------------------------|----------------------------|
| **.op** | **Operating Point Analysis** | Calculates the **DC operating point** of the circuit — i.e., the steady-state voltages and currents with all sources constant. Useful for verifying **biasing conditions** of transistors and nodes. | `.op` |
| **.dc** | **DC Sweep Analysis** | Sweeps a **voltage or current source** across a specified range to study how circuit outputs respond (e.g., I–V or V–V characteristics). | `.dc Vin 0 2.5 0.1` (sweeps `Vin` from 0 V to 2.5 V in 0.1 V steps) |
| **.tran** | **Transient Analysis** | Simulates **time-domain behavior** — how voltages and currents change over time. Commonly used for pulse or signal analysis. | `.tran 1n 100n` (simulates 100 ns with 1 ns step) |
| **.ac** | **AC (Small-Signal) Analysis** | Analyzes **frequency response** by linearizing the circuit around the operating point and sweeping frequency. Useful for **gain**, **bandwidth**, and **phase** studies. | `.ac dec 10 1k 100Meg` (sweeps frequency from 1 kHz to 100 MHz, 10 points per decade) |


#### **Experiment 1: MOSFET Behaviour (Id vs Vds)**

```spice
* SKY130 NMOS Circuit Simulation Example

.param temp=27

* Include SKY130 model library (typical corner)
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

* Circuit netlist
XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=5 l=2
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

* Simulation commands
.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control
run
display
setplot dc1
.endc

.end
```
| **Item / Element** | **Syntax / Meaning** | **Description / Purpose** |
|-------------------|---------------------|---------------------------|
| `.param temp=27` | Defines a global parameter | Sets simulation temperature to **27°C**, affecting transistor properties like threshold voltage and carrier mobility. |
| `.lib` | Includes an external library file | Loads device models from a library. |
| `"sky130_fd_pr/models/sky130.lib.spice"` | Path to model file | SKY130 PDK model file providing NMOS/PMOS device definitions. |
| `tt` | Process corner | **Typical-Typical** — nominal NMOS and PMOS behavior. Other corners: SS (slow), FF (fast), FS/SF (mixed). |
| **XM1** | `M<name> Drain Gate Source Bulk Model W= L=` | NMOS transistor.<br>→ Drain = `Vdd`<br>→ Gate = `n1`<br>→ Source = `0`<br>→ Bulk = `0`<br>→ Model = `sky130_fd_pr__nfet_01v8`<br>→ W = 5 µm, L = 2 µm |
| **R1 n1 in 55** | `R<name> Node1 Node2 Resistance` | Resistor between nodes `n1` and `in` with **55 Ω**. |
| **Vdd vdd 0 1.8V** | `V<name> +node -node DC_value` | DC power supply providing **1.8 V**. |
| **Vin in 0 1.8V** | `V<name> +node -node DC_value` | Input voltage source of **1.8 V**, can be swept or pulsed. |
| `.op` | Operating Point Analysis | Computes **steady-state DC voltages and currents** at each node. Checks circuit bias conditions. |
| `.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2` | DC Sweep Analysis | Sweeps `Vdd` (0→1.8 V, step 0.1 V) and `Vin` (0→1.8 V, step 0.2 V) to study output variations with power and input. |
| `.control ... .endc` | Control block | Executes commands in Ngspice control interpreter. |
| `run` | Command in control block | Starts simulation using the defined analyses. |
| `display` | Command in control block | Lists all **available variables** (node voltages, currents, etc.). |
| `setplot dc1` | Command in control block | Selects the DC sweep data (named `dc1`) for plotting or further analysis. |


To run the simulation, launch the SPICE tool

```
ngspice day1_nfet_idvds_L2_W5.spice
```
<img width="928" height="431" alt="image" src="https://github.com/user-attachments/assets/a12c8aa9-c7fa-4d4b-a907-8822fcbcc250" />

Plot the waveforms using Ngspice

```
plot -vdd#branch
```

<img width="923" height="431" alt="image" src="https://github.com/user-attachments/assets/dfe171b5-0388-434e-9e71-2fc1d8c32b19" />

### References

1. UC Berkeley SPICE: https://bwrcs.eecs.berkeley.edu/Classes/IcBook/SPICE/

2. Ngspice: http://ngspice.sourceforge.net/

3. LTSpice: https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html

4. HSPICE: https://www.synopsys.com/verification/analog-mixed-signal/hspice.html

5. Circuit Design Workshop: https://github.com/kunalg123/sky130CircuitDesignWorkshop.git

</details>

<details>
  <summary>CMOS Inverter Analysis and MOSFET Behaviour in SPICE Simulations</summary>

## CMOS NMOS I–V Characteristics and Velocity Saturation

**NMOS transistor behavior** in long-channel and short-channel devices, using **SPICE simulations** to illustrate linear, saturation, and velocity-saturated regions. It also covers **peak current comparisons** and operational regimes.

We simulate NMOS devices using SPICE with the following parameters:

- **Long-channel:** W = 1.8 μm, L = 1.2 μm, W/L = 1.5
  
<img width="1698" height="1030" alt="image" src="https://github.com/user-attachments/assets/5eff9911-3cd6-4377-8797-23a238f34c01" />

- **Short-channel:** W = 0.375 μm, L = 0.25 μm, W/L = 1.5
  
<img width="1786" height="956" alt="image" src="https://github.com/user-attachments/assets/21b2ca5c-e43b-4831-84d8-8e47168a4d52" />


### Observation 1: Long-Channel vs Short-Channel NMOS

<img width="1903" height="996" alt="image" src="https://github.com/user-attachments/assets/dc1c25ea-2794-43f8-a35f-7e7b01bdcb77" />

We compare two devices with the same W/L = 1.5:

| Device Type   | Width (W) | Length (L) | Channel Type                  |
|---------------|-----------|------------|-------------------------------|
| Long-channel  | 1.8 μm    | 1.2 μm     | W/L > 250 nm → Long channel  |
| Short-channel | 0.375 μm  | 0.25 μm    | W/L < 250 nm → Short channel |

- Since the channel length is < 0.25 μm in the second device, it is classified as a **short-channel device**.
- Both devices have the **same W/L ratio (1.5)**, but different absolute dimensions, allowing direct comparison of their electrical behaviour.
  
<img width="1919" height="903" alt="image" src="https://github.com/user-attachments/assets/58ef765a-0b03-40a6-bbba-65a08af2f874" />

### Long-Channel Devices
- Drain current (**Id**) shows **quadratic dependence on VGS**  
- **Linear dependence on VDS** in the linear (ohmic) region  
- Saturation current is independent of further **VDS** increases  

### Short-Channel Devices
- Quadratic at low **VGS**, but becomes **linear at high VGS** due to **velocity saturation**  
- Peak drain current is reduced compared to long-channel devices  
- New operational mode appears: **velocity saturation** between linear and saturation regions  


 In **long-channel devices**, carriers accelerate freely, producing the ideal **quadratic Id-VGS curve**.  
 
 In **short-channel devices**, at low VGS the behaviour is similar, but at higher VGS the **carrier velocity saturates** due to high electric fields. 
 
Once the **velocity limit** is reached, the **Id-VGS curve flattens**, transitioning from quadratic to linear.  

> **Conclusion:** This comparison clearly demonstrates how **velocity saturation alters short-channel NMOS behaviour**, reducing peak current and introducing a new operational regime not present in long-channel devices.

<img width="444" height="218" alt="m" src="https://github.com/user-attachments/assets/257f313a-ddee-40bd-a375-5f490aa9a054" />

 **Low Electric Fields:** Carrier velocity (**v**) increases linearly with the electric field (**E**).  
  - - Carrier velocity (v) increases linearly with the electric field (E):
  
      v(x) = μ * E(x) = μ * dV(x)/dx

- Where:  
    μ = mobility  
    V(x) = channel potential  
  - Observed in **long-channel devices** at low VGS.

- **High Electric Fields:** Carrier velocity reaches a maximum (**v_sat**) and **saturates**.
- Carrier velocity reaches a maximum (v_sat) and **saturates**:

  v(E) = (μ * E) / (1 + E / Ec)  

- Where:  
  Ec = μ / v_sat  
   v_sat = technology-limited maximum carrier velocity (~10^5 m/s)
  
  - This is called **velocity saturation**.  
  - Observed in **short-channel devices** at high VGS.  
  - Limits the drain current and flattens the Id-VGS curve.
 
  For continuity:  
    v is linear when E <= Ec  
    v is constant (v_sat) when E >= Ec  

- **Effective saturation voltage (VDSAT)** occurs when velocity saturation dominates.

Charge per Unit Area in the Channel

Qi(x) = -Cox * [(VGS - V(x)) - VT]

 where : 
 - Cox = oxide capacitance per unit area  
- VGS = gate-source voltage  
- VT = threshold voltage  

Drain Current

ID = W * Qi(x) * v(x)

- W = transistor width  
- Qi(x) = channel charge  
- v(x) = carrier velocity  

<img width="287" height="59" alt="image" src="https://github.com/user-attachments/assets/3c38eebf-d83d-4cbd-bdf5-59eec2569e6d" />

> **Note:** Velocity saturation introduces a new operational regime not present in long-channel devices.

| Device Type         | Channel Length | Modes of Operation                                   | Notes                                           |
|--------------------|----------------|-----------------------------------------------------|------------------------------------------------|
| Long-Channel        | > 250 nm       | Cutoff → Resistive → Saturation                     | Standard long-channel behavior                 |
| Short-Channel       | < 250 nm       | Cutoff → Resistive → Velocity Saturation → Saturation | Velocity saturation introduces an additional mode |

<img width="1757" height="762" alt="image" src="https://github.com/user-attachments/assets/ecb3d7a7-8df2-4beb-a542-7b4d1a09eb25" />

Observation 2: Peak Current Comparison — Long-Channel vs Short-Channel NMOS

<img width="1905" height="868" alt="image" src="https://github.com/user-attachments/assets/aa55c264-8934-4808-b149-65bc65b93f61" />

| Device Type | W (μm) | L (μm) | Peak Id (μA) | Notes |
|-------------|--------|--------|---------------|-------|
| Long-channel | 1.8 | 1.2 | 410 | Free carrier acceleration; higher Id |
| Short-channel | 0.375 | 0.25 | 210 | Velocity saturation limits current |

- **Short-channel devices** allow for **faster switching** and **smaller sizes**, but their **peak drain current is lower** than long-channel devices.  
- This reduction is caused by **velocity saturation**, which limits the maximum carrier velocity in short-channel devices.  
- In **long-channel devices**, carriers can accelerate freely under the electric field, resulting in a **higher peak Id**.



### **Experiment 2: Threshold Voltage Extraction & Velocity Saturation**

 **ID vs VDS**: Drain current variation with drain-source voltage 

<img width="925" height="439" alt="image" src="https://github.com/user-attachments/assets/357a0651-10ae-42ef-a6d8-fe78cd34af97" />

 **ID vs VGS**: Drain current variation with gate-source voltage  

<img width="928" height="425" alt="image" src="https://github.com/user-attachments/assets/450c09d4-705c-4e6e-97c2-bdd7fec70838" />

### Analysis

1. MOSFET On/Off Conditions

<img width="388" height="231" alt="image" src="https://github.com/user-attachments/assets/931f4ff9-b92d-4bc2-82d5-d38ae315558d" />

MOSFET as a Switch

A MOSFET can act like an electronic switch, turning current on or off depending on the voltage applied to its gate.

1. OFF State

When the gate–source voltage V_GS is less than the threshold voltage V_th: |V_GS| < |V_th|
- The MOSFET does not conduct.
- It behaves like an open switch.
- The resistance between drain and source is very high (ideally infinite).

2. ON State

When the gate–source voltage exceeds the threshold voltage: |V_GS| > |V_th|
- The MOSFET conducts current from drain to source.
- It behaves like a closed switch.
- The resistance between drain and source is low (called R_DS(on)).

## CMOS Inverter 

<img width="1868" height="915" alt="image" src="https://github.com/user-attachments/assets/a8a9afee-ce53-42ac-9feb-1e5ab5b45397" />

A CMOS inverter is one of the simplest and most fundamental building blocks in digital electronics. Let’s break down its operation.

1. CMOS Inverter at the Transistor Level
- The PMOS transistor is connected to V_DD (supply voltage).
- The NMOS transistor is connected to V_SS (ground).
- The input voltage V_in is applied to the gates of both transistors.
- The output voltage V_out is taken from the common drain node, where the drains of PMOS and NMOS meet.
- C_L represents the load capacitance at the output.

2. Switch Model: Input V_in = V_DD

- When the input is high (V_in = V_DD):
- The NMOS transistor turns ON, acting like a resistor R_n.
- The PMOS transistor turns OFF, behaving as an open switch.
The output is pulled down to ground: V_out = 0

3. Switch Model: Input V_in = 0

- When the input is low (V_in = 0):
- The PMOS transistor turns ON, acting like a resistor R_p.
- The NMOS transistor turns OFF, behaving as an open switch.
The output is pulled up to V_DD: V_out = V_DD


### Load Line Curves for NMOS and PMOS

The load line method is a graphical way to find the DC operating point of a CMOS inverter by plotting the currents of NMOS and PMOS transistors versus the output voltage.

<img width="1909" height="1018" alt="image" src="https://github.com/user-attachments/assets/9a0f1f40-a446-4f97-b258-c1bd2ffb44e0" />

Step 1: Convert the PMOS gate-to-source voltage (VgsP) in terms of an equivalent input voltage (Vin). Replace all internal node voltages using only Vin, Vdd, Vss, and Vout

<img width="1919" height="1029" alt="image" src="https://github.com/user-attachments/assets/3539c093-e4b0-47ed-8460-40478fead0b7" />

Step 2: Convert the PMOS and NMOS drain-to-source voltages (VdsP and VdsN) in terms of the output voltage, Vout.

<img width="1906" height="1068" alt="image" src="https://github.com/user-attachments/assets/11710911-b2b6-4d70-8769-061b0f61ec0e" />

Step 3: Both Load Curves

<img width="1917" height="623" alt="image" src="https://github.com/user-attachments/assets/b26879be-ed7f-42a2-b49f-306e824f3f54" />

Step 4: Combine the NMOS and PMOS load curves by equating their drain currents (Ids) as functions of Vout. Then, plot the Voltage Transfer Characteristic (VTC) by sweeping Vin and mapping the corresponding Vout to illustrate the inverter’s switching behavior from logic HIGH to LOW.

<img width="1907" height="1072" alt="image" src="https://github.com/user-attachments/assets/ed17cb3e-5cee-4b5a-9572-a38899318525" />
</details>

<details>
  <summary>CMOS Inverter Analysis: Static, Dynamic, and SPICE-Based Characterisation</summary>

## CMOS Inverter Analysis: Static, Dynamic, and SPICE-Based Characterisation

### Voltage Transfer Characteristics and SPICE Simulations: CMOS Inverter SPICE Deck

This section explains how to set up a SPICE deck for simulating a CMOS inverter.

1. **Component Connectivity**: Start by defining how each element is connected. Specify the PMOS (M1) and NMOS (M2) transistors, the power supply (Vdd), ground (Vss), input (Vin), and output (Vout). Proper connections ensure the circuit functions as intended.

2. **Component Values**: Set the key parameters for each component. For transistors, define the width-to-length ratio (W/L). Specify the supply voltage (e.g., Vdd = 2.5V) and the load capacitance (e.g., Cload = 10 fF). These values influence the inverter’s electrical behaviour and timing.

3. **Identify Nodes**: Recognise all nodes in the circuit, including input, output, power, ground, and each transistor terminal. Understanding node locations is essential for accurate analysis.

4. **Name Nodes**: Assign clear and consistent names to all nodes. This makes it easier to interpret simulation results and debug the SPICE deck if needed.
   
<img width="1864" height="840" alt="image" src="https://github.com/user-attachments/assets/127a3f57-1c51-400e-9a6d-0f3850b98333" />

When setting up a SPICE simulation for a CMOS inverter, the deck is organized into several important sections:

*Model & Netlist Description*:
- M1 out in vdd vdd pmos W=0.375u L=0.25u – This defines the PMOS transistor M1. It has a width of 0.375 µm and length of 0.25 µm. The source is connected to VDD, the drain to the output node (out), the gate to the input (in), and the bulk tied to VDD.
- M2 out in 0 0 nmos W=0.375u L=0.25u – This defines the NMOS transistor M2 with the same dimensions. Its source is connected to ground, the drain to the output, the gate to the input, and the bulk tied to ground.
- cload out 0 10f – A load capacitor of 10 fF connected between the output node and ground, representing parasitic or external capacitance.

*Voltage Sources*:
- Vdd vdd 0 2.5 – Sets the DC supply voltage of 2.5 V between VDD and ground.
- Vin in 0 2.5 – Represents the input voltage, which will be swept during the simulation to observe inverter behavior.

*Simulation Commands*:
- .op – Performs an operating point analysis to determine the DC bias point of the circuit.
- .dc Vin 0 2.5 0.05 – Sweeps the input voltage from 0 V to 2.5 V in 0.05 V steps, generating the voltage transfer characteristic (VTC) of the inverter.

*Model Inclusion*:
- .include tsmc_025um_model.mod – Includes the technology-specific model file containing parameters for PMOS and NMOS transistors.
- .LIB "tsmc_025um_model.mod" CMOS_MODELS – An alternative way to reference the same transistor models.

*End Statement*:
- .end – Marks the end of the SPICE deck.
  
<img width="1790" height="744" alt="image" src="https://github.com/user-attachments/assets/602bddf8-3140-4d91-861a-4772e84e381a" />

### **Experiment 3: CMOS Inverter VTC**
 
```
ngspice day3_inv_vtc_Wp084_Wn036.spice
plot out vs in
```
<img width="926" height="432" alt="image" src="https://github.com/user-attachments/assets/45bad43c-cab7-4bb8-98b7-aba20cd2724c" />

### **Experiment 4: CMOS Inverter Transient Response**

```
ngspice day3_inv_tran_Wp084_Wn036.spice
plot out vs time in
```

<img width="923" height="419" alt="image" src="https://github.com/user-attachments/assets/0443d4be-fc81-4d35-b3ad-bc3bd4274666" />


**Calculating Rise Time and Fall Time from Transient Analysis**

When analysing the transient response of a CMOS inverter, the rise time and fall time describe how quickly the output transitions between logic levels. These are determined from the output voltage waveform as follows:

Output Rise Time (𝑡𝑟)
- This is the time it takes for the output to transition from LOW to HIGH.
- Measure the time when the output voltage reaches 50% of the HIGH level during the rising edge.

<img width="928" height="428" alt="o" src="https://github.com/user-attachments/assets/c66c575a-2b8a-40f6-afce-6f024abf51e3" />


Output Fall Time (𝑡𝑓)
- This is the time it takes for the output to transition from HIGH to LOW.
- Measure the time when the output voltage reaches 50% of the HIGH level during the falling edge.

<img width="927" height="431" alt="o1" src="https://github.com/user-attachments/assets/b4c7f460-1323-4c46-b2eb-6c3278014cbd" />

### Static Behaviour Evaluation — CMOS Inverter Robustness and Switching Threshold Voltage

When evaluating the robustness of a CMOS inverter, several key characteristics are considered:
- Switching Threshold Voltage (Vm)
- Noise Margin
- Power Supply Variations
- Device Variations

## **Switching Threshold Voltage (Vm)**

The switching threshold voltage (Vm) is the input voltage at which the inverter output equals the input: 𝑉in = 𝑉out
​Vm is a critical parameter because it directly affects the inverter’s noise margin and overall robustness. At Vm:
 - Both the NMOS and PMOS transistors are in the saturation region.
 - Both transistors are conducting simultaneously, producing a high voltage gain

<img width="1875" height="930" alt="image" src="https://github.com/user-attachments/assets/3ed4808b-fa20-4fd4-8f4f-babab8312960" />

### Impact of Transistor Sizing on Vm

| Case | Wn (µm) | Ln (µm) | Wp (µm) | Lp (µm) | (W/L)n | (W/L)p | Resulting Vm (V) | Notes |
|------|----------|----------|----------|----------|--------|--------|----------------|-------|
| Equal Sizing (Left graph) | 0.375 | 0.25 | 0.375 | 0.25 | 1.5 | 1.5 | 0.98 | Balanced NMOS & PMOS, Vm near mid-supply |
| Stronger PMOS (Right graph) | 0.375 | 0.25 | 0.9375 | 0.25 | 1.5 | 3.75 | 1.2 | PMOS stronger, Vm shifts higher |

**Regions of Operation**

Different portions of the voltage transfer curve correspond to different transistor operating regions:
1. PMOS Linear / NMOS OFF — Low input region.
2. PMOS Linear / NMOS Saturation — Input rising.
3. PMOS Saturation / NMOS Saturation — Vm occurs here, maximum gain.
4. PMOS Saturation / NMOS Linear — Input near high logic.
5. PMOS OFF / NMOS Linear — High input region.

> Understanding these regions helps in analysing switching behaviour and designing inverters for robust performance under process, voltage, and temperature variations.

<img width="1804" height="933" alt="image" src="https://github.com/user-attachments/assets/79050e1f-d839-403d-b528-30171ff5047a" />

**Current Balance at Vm**

At the switching threshold voltage (Vm), the inverter is in a special operating point where the currents through the NMOS and PMOS transistors are equal in magnitude but flow in opposite directions. Mathematically:  IDp​=−IDn​

This means the PMOS is sourcing the same current that the NMOS is sinking.

Since we are analysing at Vm:

- For the NMOS, the gate-to-source voltage is equal to the input voltage: VGSn​=Vm​
- For the PMOS, the gate-to-source voltage is the difference between the input and VDD: VGSp​=Vm​−VDD​​

This current balance is crucial because it defines the point of maximum voltage gain in the CMOS inverter and ensures symmetric switching behaviour.

<img width="1758" height="925" alt="image" src="https://github.com/user-attachments/assets/8cd43e2d-b772-425f-9420-f8edb62cffe0" />

Expressing Vm in Terms of Transistor Sizing and Mobility

To determine the switching threshold voltage Vm, we start with the current balance condition at Vm:

  IDp​+IDn​=0
  
This equation states that the current sourced by the PMOS exactly equals the current sunk by the NMOS, but in opposite directions.
By solving this equation for the ratio of PMOS to NMOS strengths (R), we can express Vm as a function of transistor sizing (W/L ratios) and carrier mobility factors

In other words, Vm depends on:
- The width-to-length ratios of the NMOS and PMOS transistors.
- The mobility of electrons and holes, which affects how strongly each transistor conducts.
- The supply voltage (VDD).

<img width="1859" height="946" alt="image" src="https://github.com/user-attachments/assets/e9a4cf12-f6a6-435a-bc93-33d5e6cef47f" />

**Determining the PMOS-to-NMOS Sizing Ratio for a Desired Vm**
This expression demonstrates how to calculate the required ratio of PMOS to NMOS strengths, (Wp/Lp​)/(Wn/Ln), for a specific switching threshold voltage Vm.

<img width="829" height="491" alt="image" src="https://github.com/user-attachments/assets/27ba0b1d-b4d5-4cde-8275-4b222444ab7b" />

**Effect of PMOS-to-NMOS Sizing on Inverter Performance**

<img width="1835" height="511" alt="image" src="https://github.com/user-attachments/assets/e692fb87-08c5-4eae-9580-34dcc768ce63" />

This table illustrates how changing the Wp/Wn ratio influences key inverter characteristics:
- Rise Delay – the time it takes for the output to transition from LOW to HIGH
- Fall Delay – the time it takes for the output to transition from HIGH to LOW
- Switching Threshold Voltage (Vm) – the input voltage at which the inverter switches

Key observations:

When the PMOS is roughly twice as strong as the NMOS (Wp/Lp≈2×Wn/Ln):
- Rise and fall delays are balanced, around 80 ps each.
- The switching threshold Vm​ ≈1.2 V

In this balanced condition, the clock buffer does not introduce duty cycle distortion, so no correction is needed.

If the rise and fall delays are mismatched due to PMOS/NMOS resistance (Ron) differences:
- Duty cycle distortion can occur.
- Duty cycle correction circuits are then added in the clock tree to maintain a 50% duty cycle.

> Balancing transistor strengths is therefore critical for fast, symmetric switching and reliable timing in CMOS circuits.

</details>


<details>
  <summary>CMOS Inverter Noise Margin and Robustness Analysis</summary>

## Introduction to Noise Margin

Noise margin is a measure of a CMOS circuit’s tolerance to voltage noise at its input without causing logic errors at the output. In other words, it tells us how much unwanted voltage fluctuation the circuit can safely handle while still interpreting signals correctly as logic HIGH or LOW.

- Ideal inverter characteristic:
  - The voltage transfer curve (VTC) has an infinite slope, meaning the output switches abruptly at VDD/2
  - There is no ambiguous region—logic HIGH and LOW are perfectly defined
- Actual inverter characteristic:
  - The VTC has a finite slope, so the transition from HIGH to LOW (or vice versa) is gradual.
  - This creates a transition region where the output is undefined, which limits the allowable noise voltage.
    
<img width="1204" height="690" alt="image" src="https://github.com/user-attachments/assets/00c9aa78-4cd5-497e-8f16-a6614b57b11b" />

Understanding Noise Margins and Critical Voltages

When analysing a CMOS inverter’s voltage transfer characteristic (VTC), several key points and regions define its noise tolerance and reliability:
- Left Plot – Critical Slopes:
   - The slope of the VTC equals −1 at two important points:

**VIL (Input Low Threshold Voltage)**: The maximum input voltage recognised as logic LOW.
**VIH (Input High Threshold Voltage)**: The minimum input voltage recognised as logic HIGH.

- Right Diagram – Output Levels and Thresholds:
 - VOH and VOL represent the valid output HIGH and LOW voltage levels, respectively.
- VIL and VIH indicate the input voltages where the VTC slope equals −1, marking the boundaries of the undefined region.

**Noise Margins**:
**NMH (Noise Margin High)** = VOH − VIH: The maximum noise voltage tolerated on a logic HIGH input.
**NML (Noise Margin Low)** = VIL − VOL: The maximum noise voltage tolerated on a logic LOW input.

**Undefined Region**:
The region between VIL and VIH is undefined, meaning the output logic may be unstable.
Any input noise in this region can lead to unpredictable or invalid outputs.

<img width="1126" height="661" alt="image" src="https://github.com/user-attachments/assets/437921ad-8836-4b4b-9815-69c300c0fae7" />

Input and Output Thresholds and Noise Bump Scenarios

To ensure reliable CMOS operation, it is important to understand the input and output voltage thresholds and how small voltage disturbances (noise bumps) affect logic interpretation:

**Input Thresholds**:
- VIL (Input Low Voltage): Input voltages below ~10% of VDD are reliably interpreted as logic ‘0’.
- VIH (Input High Voltage): Input voltages above ~90% of VDD are reliably interpreted as logic ‘1’.

**Output Thresholds**:
- VOL (Output Low Voltage): Output near 0 V, recognised as logic ‘0’ by the next gate.
- VOH (Output High Voltage): Output near VDD, recognised as logic ‘1’ by the next gate.

**Noise Bump Scenarios**:

1. Case (a): Noise bump between VOL and VIL → signal still interpreted as logic ‘0’.
2. Case (b): Noise bump between VIL and VIH → signal enters the undefined region, causing unstable or unpredictable output.
3. Case (c): Noise bump between VIH and VOH → signal still interpreted as logic ‘1’.


<img width="1279" height="613" alt="image" src="https://github.com/user-attachments/assets/dfd8b846-1c25-498d-88f7-80043dc8a822" />

**Experiment 5: CMOS Inverter Noise Margin Analysis**

```
ngspice day4_inv_noisemargin_wp1_wn036.spice
plot out vs in
```
<img width="929" height="436" alt="image" src="https://github.com/user-attachments/assets/de41e0ee-7936-4882-9443-e55e523cfe03" />


<img width="868" height="401" alt="4" src="https://github.com/user-attachments/assets/322e68b3-9582-405d-884f-5409b8a1ab25" />

<img width="923" height="374" alt="4 1" src="https://github.com/user-attachments/assets/5eca8053-e196-4d96-806d-73d59e87b628" />


</details>


<details>
  <summary>CMOS Inverter Robustness under Power Supply and Device Variations</summary>

## Static Behaviour Evaluation — CMOS Inverter Robustness under Power Supply Variation

Overview:
The power supply voltage (VDD) has a direct impact on the static behaviour of a CMOS inverter. Changing VDD affects:
- The switching threshold voltage (Vm)
- The noise margins (NMH and NML)
The overall robustness of the inverter against noise and variations

Lowering or increasing VDD shifts the inverter’s voltage transfer characteristic (VTC), potentially altering logic-level interpretation.

SPICE Simulation Example:
To study this effect, the CMOS inverter is simulated at two supply voltages:
 - Original supply: VDD = 2.5 V
 - Scaled-down supply: VDD = 1 V

Transistor dimensions remain constant:
 - PMOS: Wp = 0.9375 µm
 - NMOS: Wn = 0.375 µm

This simulation demonstrates how Vm and noise margins shift when the supply voltage changes, highlighting the importance of designing inverters that remain robust across different VDD levels.

<img width="1801" height="990" alt="image" src="https://github.com/user-attachments/assets/385ba066-f2e1-45e9-9402-153a2ce17232" />

**Switching Threshold (Vm)**:

As the supply voltage VDD decreases, the inverter’s switching threshold Vm tends to shift toward the midpoint of the supply range.
However, the noise margins shrink, making the inverter more susceptible to voltage fluctuations.

**Noise Margins**:

Lower VDD reduces the inverter’s noise immunity, meaning even small voltage disturbances can cause incorrect logic interpretation.
Higher VDD improves noise tolerance but comes at the cost of higher power consumption.

**Performance Impact**:

Low VDD operation reduces both static and dynamic power, which is desirable for low-power designs.
However, it limits noise robustness and increases sensitivity to process or supply variations.

High VDD operation increases noise margin and reliability but results in higher power dissipation.

<img width="1610" height="952" alt="image" src="https://github.com/user-attachments/assets/7dd4cf79-0293-4aeb-89f0-5dcc54104456" />
Using a 0.5 V Supply in CMOS Inverters

Advantages:
- Operating at a lower supply voltage (VDD = 0.5 V) offers significant benefits:
- Approximately 50% improvement in voltage gain.
- Around 90% reduction in energy consumption.
> This demonstrates the efficiency of power supply scaling in CMOS inverter design, making it attractive for low-power applications.

Disadvantages:
<img width="1360" height="877" alt="image" src="https://github.com/user-attachments/assets/726b428d-b72c-443e-82b7-f669f022927c" />
- Lowering VDD also comes with trade-offs:
- Reduced drive strength slows down the switching speed of the inverter.
- Circuits may exhibit slower performance, which can impact timing-critical applications.


**Experiment 6: Variation & Supply Study**

```
ngspice day5_inv_supplyvariation_Wp1_Wn036.spice
```
<img width="929" height="422" alt="image" src="https://github.com/user-attachments/assets/8c916549-dc5d-4669-b190-b705f4f1bb3a" />
<img width="886" height="428" alt="5" src="https://github.com/user-attachments/assets/6ab497ea-967c-43a0-a82c-aa2f29ede1b4" />
<img width="926" height="406" alt="5 1" src="https://github.com/user-attachments/assets/6ccbae76-a90f-4118-99e6-5686f96ecf43" />



Static Behaviour Evaluation — CMOS Inverter Robustness under Device Variation

Device Variation and CMOS Inverter Robustness
The robustness of a CMOS inverter is significantly influenced by device variations that arise during fabrication. These variations can occur due to:
- Etching variation
- Oxide thickness (Tox) variation
- Minor deviations in transistor dimensions (W and L)
- Etching Variation

<img width="1701" height="665" alt="image" src="https://github.com/user-attachments/assets/a9c15f9d-f433-4fc9-a7ce-601e066cf6a6" />


Etching is a critical step in semiconductor fabrication that defines the physical layout of transistors and interconnects.
Consider an inverter chain — multiple CMOS inverters connected in series to study delay, robustness, and performance variations across stages.

The layout layers include:
- Poly-silicon (gate)
- P-diffusion and N-diffusion regions (transistor channels)
- VDD and VSS rails
- Small deviations during etching can alter:
- Width (W) of NMOS and PMOS gates
> Length (L) of the gate, which corresponds to the technology node (e.g., 20 nm, 45 nm)

Metal layers and contacts between layers

<img width="1830" height="913" alt="image" src="https://github.com/user-attachments/assets/ca5ac4ba-b77f-469b-b8a0-8fb4884e765e" />

<img width="1412" height="746" alt="image" src="https://github.com/user-attachments/assets/a6da6788-495a-4cd7-9c97-accf568e538d" />


Impact:

Since the drain current (Id) depends on W and L, etching variations lead to changes in transistor drive strength.
This affects the switching threshold (Vm), noise margins, and overall circuit robustness.

Oxide Thickness (Tox) Variation
<img width="1827" height="877" alt="image" src="https://github.com/user-attachments/assets/649f3936-cf84-4646-8281-37e319f9999d" />
<img width="1173" height="144" alt="image" src="https://github.com/user-attachments/assets/3ea4e1ec-7d2c-4abe-a736-84ee988e68b6" />


During fabrication, the actual gate oxide thickness often differs from the intended design.
- The drain current Id depends on the gate oxide capacitance Cox
- Variations in Tox therefore directly impact Id, influencing inverter speed, Vm, and noise margins.

### Transistor Strength Definitions

<img width="1799" height="930" alt="image" src="https://github.com/user-attachments/assets/06428521-959c-4669-ac5c-5daf48832c82" />


| Transistor Type | Strength | Characteristics | How Achieved |
|-----------------|----------|----------------|--------------|
| PMOS            | Strong   | Lower resistance, charges output capacitor faster | Use wider PMOS |
| PMOS            | Weak     | Higher resistance, slower charging | Use narrower PMOS |
| NMOS            | Strong   | Lower resistance, discharges output quickly | Use wider NMOS |
| NMOS            | Weak     | Higher resistance, slower discharging | Use narrower NMOS |


<img width="1533" height="832" alt="image" src="https://github.com/user-attachments/assets/1686b271-2725-4ffa-903c-5d5fcda6b564" />

```
ngspice day5_inv_supplyvariation_Wp1_Wn036.spice
plot out vs in
```
<img width="927" height="433" alt="image" src="https://github.com/user-attachments/assets/c35faab9-3a2c-46bc-9566-1ebd593ad6a4" />

</details>


<details>
  <summary>From Transistor Behaviour to Timing Analysis (STA): The CMOS Design Flow</summary>

## Level 1: Transistor Behaviour (Device Physics)

**Foundation:** Individual NMOS / PMOS operation — the building blocks of all CMOS logic.

**Key Concepts:**
- **I–V Characteristics (Id vs. Vds / Vgs):**
  - Linear & Saturation regions  
  - Threshold voltage (Vt) extraction  
  - Velocity saturation in short-channel devices
- **Device Parameters:**
  - W/L ratio → Drive strength  
  - Tox, doping, channel length → Vt variation  
  - Supply voltage (VDD) → Switching speed

## Level 2: CMOS Inverter Behavior (Circuit Level)

**Foundation:** Combination of NMOS and PMOS — the simplest CMOS logic gate.

**Key Concepts:**
- **VTC Curve (Vout vs. Vin):**
  - Defines switching threshold (Vm)  
  - Forms the basis for noise margins (NMH, NML)
- **Transient Response:**
  - Rise/fall delay  
  - Effect of load capacitance and drive current
- **Noise Margin Analysis:**
  - Determines logical robustness

## Level 3: Timing Behavior (Digital Logic Level)

**Foundation:** How circuit-level behavior translates to timing in digital systems.

**Key Concepts:**
- **Propagation Delays (tPHL, tPLH):**
  - Used in standard timing libraries (`.lib`)
- **Variation Effects:**
  - Delay, threshold, and noise margins under **PVT corners**
- **Power Supply Variation Impact:**
  - Trade-off between delay and dynamic power

## Level 4: Static Timing Analysis (System Level)

**Foundation:** How EDA tools utilize transistor data for full-chip timing verification.

**Key Concepts:**
- **From SPICE → `.lib` Models:**
  - Extracted delay tables  
  - Slew, load, and drive strength dependencies
- **STA Concepts:**
  - Arrival time, required time, slack  
  - Setup/Hold margins derived from transistor-level behavior
- **Goal:**
  - Achieve accurate **timing closure** under process and variation constraints

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

</details>












