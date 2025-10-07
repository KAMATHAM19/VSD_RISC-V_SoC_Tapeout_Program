


## Installation of OpenSTA

```bash
sudo apt-get update
sudo apt-get install build-essential tcl-dev tk-dev cmake git libeigen3-dev autoconf m4 perl automake 

git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
cd OpenSTA
mkdir build
cd build
cmake ..
```
- if any errors occur

```bash
cd
git clone https://github.com/ivmai/cudd.git
cd cudd
autoreconf -I
mkdir build
cd build
../configure --prefix=$HOME/cudd
make
make install
```
> CUDD is installed successfully

```bash
cd OpenSTA
cd build
cmake .. -DUSE_CUDD=ON -DCUDD_DIR=$HOME/cudd
make
sudo make install
sta
```
<img width="926" height="163" alt="image" src="https://github.com/user-attachments/assets/5a494ae0-a203-43fd-a008-b49a3c5e7331" />

## Timing Analysis Using Inline Commands

> Once you are in the OpenSTA interactive shell (indicated by the % prompt), you can execute the following inline commands to perform a basic static timing analysis:

```tcl
# Change to directory
cd OpenSTA/examples

# To invoke the tool
sta

# Load the standard cell timing library (Liberty format)
read_liberty ./nangate45_slow.lib.gz

# Load the gate-level Verilog netlist
read_verilog ./example1.v

# Link the top-level module with the loaded timing library
link_design top

# Define a 10 ns clock named 'clk' for inputs clk1, clk2, and clk3
create_clock -name clk -period 10 {clk1 clk2 clk3}

# Set input delay of 0 ns for signals in1 and in2 relative to clock 'clk'
set_input_delay -clock clk 0 {in1 in2}
```
<img width="926" height="173" alt="image" src="https://github.com/user-attachments/assets/6eecc46f-091a-440e-b41a-30b0b2e4f704" />

```tcl
# Generate a timing check report for the design
report_checks

or

report_checks -path_delay max
```
<img width="928" height="319" alt="image" src="https://github.com/user-attachments/assets/ae76cfc1-0db2-40d0-8056-58ea25430bc3" />

> report_check by default is setup/max checks

```tcl
report_checks -path_delay min

```
<img width="929" height="308" alt="image" src="https://github.com/user-attachments/assets/2167d039-8d2c-4395-83c5-dd363bc87c0d" />

> other command report_checks -path_delay min_max

```verilog
module top (in1, in2, clk1, clk2, clk3, out);
  input in1, in2, clk1, clk2, clk3;
  output out;
  wire r1q, r2q, u1z, u2z;

  DFF_X1 r1 (.D(in1), .CK(clk1), .Q(r1q));
  DFF_X1 r2 (.D(in2), .CK(clk2), .Q(r2q));
  BUF_X1 u1 (.A(r2q), .Z(u1z));
  AND2_X1 u2 (.A1(r1q), .A2(u1z), .ZN(u2z));
  DFF_X1 r3 (.D(u2z), .CK(clk3), .Q(out));
endmodule // top
```
```tcl
cd /OpenSTA/examples/
yosys
read_liberty -lib nangate45_slow.lib.gz
read_verilog example1.v
synth -top top
```
<img width="926" height="245" alt="image" src="https://github.com/user-attachments/assets/d61f4834-ba1c-42ba-81a2-4d466a28ec69" />

```
show
```

<img width="926" height="170" alt="image" src="https://github.com/user-attachments/assets/c557017b-97d1-492f-bff6-11180f836141" />


<img width="926" height="427" alt="sta" src="https://github.com/user-attachments/assets/8352ac1e-e0a4-428d-b9c1-f14c22f7583f" />

```java
r2/Q (clock-to-Q)   = 0.23 ns                       Clock period        = 10 ns
u1 (BUF delay)      = 0.08 ns                       library setup time  = -0.16 ns
u2 (AND2 delay)     = 0.10 ns                       ---------------------------------
---------------------------------                   data required time  = 9.84 ns
Total arrival time  = 0.41 ns                       (trequired​=Tclk​−tsetup​)
(tarrival​=tclk_q​+tbuf​+tand​)

                                                  Slack Calculation
                                           ------------------------------------
                                            Slack = Required Time − Arrival Time 
                                            (Slacksetup​=trequired​−tarrival​)
                                            Slack = 9.84 − 0.41
                                                   = 9.43 ns (+ve MET)
                                           -------------------------------------
```

<img width="925" height="423" alt="sta_hold" src="https://github.com/user-attachments/assets/2580316d-a232-4f51-bff9-b3cc38f9e9d6" />

- For hold check, we consider the shortest path
  
```java
Data arrival time = 0.00 ns (tarrivalmin​=tclk_q​+tcomb_min​)
Data required time = 0.01 ns (trequiredhold​=thold​)
-------------------------------------
Slack = Data arrival time − Data required time (Slackhold​=tarrivalmin​−trequiredhold​)
      =  0.00 − 0.01
      = −0.01 ns (VIOLATED)
-------------------------------------
```
> If Slack < 0, → Hold violation (data arrives too early)
> data arrives 10 ps too early, causing a hold violation

## SPEF-Based Timing Analysis

```tcl
# Change to the directory containing OpenSTA examples
cd OpenSTA/examples

# Invoke the OpenSTA tool
sta

# Load the standard cell timing library (Liberty format)
read_liberty ./nangate45_slow.lib.gz

# Load the gate-level Verilog netlist for analysis
read_verilog ./example1.v

# Link the top-level module in the Verilog netlist with the loaded timing library
link_design top

# Load the parasitic SPEF file for accurate delay calculation
read_spef ./example1.dspef

# Define a 10 ns clock named 'clk' for signals clk1, clk2, and clk3
create_clock -name clk -period 10 {clk1 clk2 clk3}

# Set input delay of 0 ns for signals in1 and in2 relative to the clock 'clk'
set_input_delay -clock clk 0 {in1 in2}
```

<img width="925" height="221" alt="image" src="https://github.com/user-attachments/assets/52456189-f659-4f5a-a011-290d59086695" />

```
# Generate a timing check report for the design
report_checks
```
<img width="926" height="326" alt="image" src="https://github.com/user-attachments/assets/2afabe16-e85c-472b-a782-f9e71dbbc98e" />

```
report_checks -path_delay min
```
<img width="926" height="300" alt="image" src="https://github.com/user-attachments/assets/4ac06f55-8307-4270-a1a6-d7cf529867d4" />


```
report_checks -digits 4 -fields capacitance
```
<img width="924" height="323" alt="image" src="https://github.com/user-attachments/assets/07014e8a-1a92-430b-868c-cff049675424" />

```
report_checks -digits 4 -fields [list capacitance slew input_pins fanout]
```
<img width="928" height="350" alt="image" src="https://github.com/user-attachments/assets/be972b0a-9623-400a-ada8-bfa7d4089296" />

```
report_power
```
<img width="928" height="155" alt="image" src="https://github.com/user-attachments/assets/538796b5-7d82-4487-959c-191dd81b9e7c" />

```
report_pulse_width_checks
```
<img width="926" height="119" alt="image" src="https://github.com/user-attachments/assets/513bc772-3c02-4891-b1aa-634f1bce0715" />

```
report_units
```
<img width="930" height="107" alt="image" src="https://github.com/user-attachments/assets/8fba9221-1ee7-49c2-90e5-94560198a9ad" />


## Timing Report Comparison: Normal vs SPEF-based




# Timing Report Comparison: Without SPEF vs With SPEF

| Node / Signal               | Without SPEF Delay / Time (ns) | With SPEF Delay / Time (ns) |
|------------------------------|-------------------------------|----------------------------|
| clock clk (rise edge)        | 0.00 / 0.00                   | 0.00 / 0.00                |
| clock network delay (ideal)  | 0.00 / 0.00                   | 0.00 / 0.00                |
| ^ r2/CK (DFF_X1)             | 0.00 / 0.00                   | 0.00 / 0.00                |
| r2/Q (DFF_X1)                | 0.23 / 0.23                   | 2.58 / 2.58                |
| u1/Z (BUF_X1)                | 0.08 / 0.31                   | 2.58 / 5.16                |
| u2/ZN (AND2_X1)              | 0.10 / 0.41                   | 2.75 / 7.91                |
| r3/D (DFF_X1)                | 0.00 / 0.41                   | 0.00 / 7.92                |
| Data Arrival Time             | 0.41                            | 7.92                       |
| clock clk (rise edge)         | 10.00 / 10.00                 | 10.00 / 10.00              |
| clock network delay (ideal)   | 0.00 / 10.00                  | 0.00 / 10.00               |
| clock reconvergence pessimism | 0.00 / 10.00                  | 0.00 / 10.00               |
| r3/CK (DFF_X1)               | 10.00 / 10.00                 | 10.00 / 10.00              |
| Library Setup Time            | -0.16 / 9.84                  | -0.57 / 9.43               |
| Data Required Time            | 9.84                            | 9.43                       |
| Slack                        | 9.43 (MET)                     | 1.52 (MET)                 |


### Observations

- **Without SPEF**: Only library cell delays are considered → **smaller path delays**, **larger slack**.  
- **With SPEF**: Includes parasitic RC delays → **larger path delays**, **smaller slack**.  
- SPEF-based slack is closer to real post-route timing and is critical for **final timing verification**.



# VSDBabySoC

```tcl

cd Desktop/SoC/VSDBabySoC

sta

# Load Liberty Libraries (standard cell + IPs)
read_liberty  ./src/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty  ./src/lib/avsdpll.lib
read_liberty ./src/lib/avsddac.lib

# Read Synthesized Netlist
read_verilog ./src/module/vsdbabysoc.synth.v

# Link the Top-Level Design
link_design vsdbabysoc

# Apply SDC Constraints
read_sdc ./src/sdc/vsdbabysoc_synthesis.sdc
```
```sdc
set_units -time ns
create_clock [get_pins {pll/CLK}] -name clk -period 11
```

<img width="924" height="253" alt="image" src="https://github.com/user-attachments/assets/9eef44aa-1acf-4d25-ab55-c917487f9c07" />

```
# Generate Timing Report
report_checks
```

<img width="923" height="319" alt="image" src="https://github.com/user-attachments/assets/2d1e547e-d86a-449a-881e-00ba8de3d152" />

```
report_checks -path_delay min
```
<img width="929" height="307" alt="image" src="https://github.com/user-attachments/assets/1e528851-ee7b-4219-ae11-8b576d8bc537" />

# PVT Corners and Timing Analysis

### Timing Libraries

Timing libraries required for this analysis can be downloaded from:

**[SkyWater PDK – sky130_fd_sc_hd Timing Libraries](https://github.com/efabless/skywater-pdk-libs-sky130_fd_sc_hd/tree/master/timing)**


script for downloading all lib files

```
#!/usr/bin/env tclsh

# List of .lib files to download
set files {
    sky130_fd_sc_hd__ff_100C_1v65.lib
    sky130_fd_sc_hd__ff_100C_1v95.lib
    sky130_fd_sc_hd__ff_n40C_1v56.lib
    sky130_fd_sc_hd__ff_n40C_1v65.lib
    sky130_fd_sc_hd__ff_n40C_1v76.lib
    sky130_fd_sc_hd__ff_n40C_1v95.lib
    sky130_fd_sc_hd__ss_100C_1v40.lib
    sky130_fd_sc_hd__ss_100C_1v60.lib
    sky130_fd_sc_hd__ss_n40C_1v28.lib
    sky130_fd_sc_hd__ss_n40C_1v35.lib
    sky130_fd_sc_hd__ss_n40C_1v40.lib
    sky130_fd_sc_hd__ss_n40C_1v44.lib
    sky130_fd_sc_hd__ss_n40C_1v76.lib
    sky130_fd_sc_hd__ss_n40C_1v60.lib 
    sky130_fd_sc_hd__tt_025C_1v80.lib
    sky130_fd_sc_hd__tt_100C_1v80.lib
}

# Base URL for the raw files
set base_url "https://github.com/efabless/skywater-pdk-libs-sky130_fd_sc_hd/raw/master/timing"

# Use existing folder 'lib'
cd lib

# Download each file (always overwrite)
foreach file $files {
    puts "Downloading $file..."
    if {[catch {exec wget -O $file --quiet --show-progress $base_url/$file} err]} {
        puts "Failed to download $file: $err" 
    } else {
        puts "Finished downloading $file"
    }
}

puts "\n All downloads complete!"

```
chmod 777 pvt_corners_download.tcl
tclsh pvt_corners_download.tcl


<img width="929" height="169" alt="image" src="https://github.com/user-attachments/assets/f2c68f4b-f80e-4848-94ce-70b4c3d55b26" />

- script to run sta for all pvt corners
```
 set list_of_lib_files(1) "sky130_fd_sc_hd__ff_n40C_1v95.lib"
 set list_of_lib_files(2) "sky130_fd_sc_hd__ff_100C_1v65.lib"
 set list_of_lib_files(3) "sky130_fd_sc_hd__ff_100C_1v95.lib"
 set list_of_lib_files(4) "sky130_fd_sc_hd__ff_n40C_1v56.lib"
 set list_of_lib_files(5) "sky130_fd_sc_hd__ff_n40C_1v65.lib"
 set list_of_lib_files(6) "sky130_fd_sc_hd__ff_n40C_1v76.lib"
 set list_of_lib_files(7) "sky130_fd_sc_hd__ss_100C_1v40.lib"
 set list_of_lib_files(8) "sky130_fd_sc_hd__ss_100C_1v60.lib"
 set list_of_lib_files(9) "sky130_fd_sc_hd__ss_n40C_1v28.lib"
 set list_of_lib_files(10) "sky130_fd_sc_hd__ss_n40C_1v35.lib"
 set list_of_lib_files(11) "sky130_fd_sc_hd__ss_n40C_1v40.lib"
 set list_of_lib_files(12) "sky130_fd_sc_hd__ss_n40C_1v44.lib"
 set list_of_lib_files(13) "sky130_fd_sc_hd__ss_n40C_1v76.lib"
set list_of_lib_files(14) "sky130_fd_sc_hd__ss_n40C_1v60.lib "
set list_of_lib_files(15) "sky130_fd_sc_hd__tt_025C_1v80.lib"
set list_of_lib_files(16) "sky130_fd_sc_hd__tt_100C_1v80.lib"

 read_liberty ./src/lib/avsdpll.lib
 read_liberty ./src/lib/avsddac.lib

 for {set i 1} {$i <= [array size list_of_lib_files]} {incr i} {
 read_liberty ./src/lib/$list_of_lib_files($i)
 read_verilog ./src/module/vsdbabysoc.synth.v
 link_design vsdbabysoc
 current_design
 read_sdc ./src/sdc/vsdbabysoc_synthesis.sdc
 check_setup -verbose

mkdir sta_outputs
report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits {4} > ./sta_outputs/min_max_$list_of_lib_files($i).txt

 exec echo "$list_of_lib_files($i)" >> ./sta_outputs/sta_worst_max_slack.txt
 report_worst_slack -max -digits {4} >> ./sta_outputs/sta_worst_max_slack.txt

 exec echo "$list_of_lib_files($i)" >> ./sta_outputs/sta_worst_min_slack.txt
 report_worst_slack -min -digits {4} >> ./sta_outputs/sta_worst_min_slack.txt

 exec echo "$list_of_lib_files($i)" >> ./sta_outputs/sta_tns.txt
 report_tns -digits {4} >> ./sta_outputs/sta_tns.txt

 exec echo "$list_of_lib_files($i)" >> ./sta_outputs/sta_wns.txt
 report_wns -digits {4} >> ./sta_outputs/sta_wns.txt
 }

```


```
#!/usr/bin/env tclsh
#---------------------------------------------
#  Multi-corner STA Automation Script (OpenSTA)
#---------------------------------------------

# Define list of timing libraries (corners)
set list_of_lib_files {
    sky130_fd_sc_hd__ff_n40C_1v95.lib
    sky130_fd_sc_hd__ff_100C_1v65.lib
    sky130_fd_sc_hd__ff_100C_1v95.lib
    sky130_fd_sc_hd__ff_n40C_1v56.lib
    sky130_fd_sc_hd__ff_n40C_1v65.lib
    sky130_fd_sc_hd__ff_n40C_1v76.lib
    sky130_fd_sc_hd__ss_100C_1v40.lib
    sky130_fd_sc_hd__ss_100C_1v60.lib
    sky130_fd_sc_hd__ss_n40C_1v28.lib
    sky130_fd_sc_hd__ss_n40C_1v35.lib
    sky130_fd_sc_hd__ss_n40C_1v40.lib
    sky130_fd_sc_hd__ss_n40C_1v44.lib
    sky130_fd_sc_hd__ss_n40C_1v76.lib
    sky130_fd_sc_hd__ss_n40C_1v60.lib
    sky130_fd_sc_hd__tt_025C_1v80.lib
    sky130_fd_sc_hd__tt_100C_1v80.lib
}

#---------------------------------------------
#  Load base cell libraries and design files
#---------------------------------------------
read_liberty ./src/lib/avsdpll.lib
read_liberty ./src/lib/avsddac.lib

#---------------------------------------------
#  Create output folder
#---------------------------------------------
file mkdir sta_outputs

#---------------------------------------------
#  Loop through each .lib file (corner)
#---------------------------------------------
set i 1
foreach lib_file $list_of_lib_files {

    puts "\n=== Running STA for corner: $lib_file ==="

    # Load corner-specific library
    read_liberty ./src/lib/$lib_file

    # Read design and constraints
    read_verilog ./src/module/vsdbabysoc.synth.v
    link_design vsdbabysoc
    current_design vsdbabysoc
    read_sdc ./src/sdc/vsdbabysoc_synthesis.sdc

    # Perform timing checks
    check_setup -verbose

    #-----------------------------------------
    # Generate detailed reports
    #-----------------------------------------
    report_checks \
        -path_delay min_max \
        -fields {nets cap slew input_pins fanout} \
        -digits 4 \
        > ./sta_outputs/min_max_$lib_file.txt

    #-----------------------------------------
    # Save key metrics (WNS, TNS)
    #-----------------------------------------
    exec echo "$lib_file" >> ./sta_outputs/sta_worst_max_slack.txt
    report_worst_slack -max -digits 4 >> ./sta_outputs/sta_worst_max_slack.txt

    exec echo "$lib_file" >> ./sta_outputs/sta_worst_min_slack.txt
    report_worst_slack -min -digits 4 >> ./sta_outputs/sta_worst_min_slack.txt

    exec echo "$lib_file" >> ./sta_outputs/sta_tns.txt
    report_tns -digits 4 >> ./sta_outputs/sta_tns.txt

    exec echo "$lib_file" >> ./sta_outputs/sta_wns.txt
    report_wns -digits 4 >> ./sta_outputs/sta_wns.txt

    incr i
}
puts "\n All corners analysed. Reports saved in ./sta_outputs/"

```


## References

https://github.com/The-OpenROAD-Project/OpenSTA.git

https://github.com/ivmai/cudd.git

https://github.com/spatha0011/spatha_vsd-hdp/tree/main/Day7

https://github.com/arunkpv/vsd-hdp/blob/main/docs/Day_19.md



