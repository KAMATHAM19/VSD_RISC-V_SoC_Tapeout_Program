# =============================================================================
# SDC Constraints for vsdbabysoc Module (synthesized netlist)
# Generated for OpenSTA Static Timing Analysis
# Clock period: 11 ns (~90.9 MHz)
# =============================================================================

set_units -time ns

# Clock definition
create_clock -name clk -period 11 [get_pins pll/CLK]

set_clock_latency -source 2 [get_clocks clk]
set_clock_latency 1 [get_clocks clk]
set_clock_uncertainty -setup 0.5 [get_clocks clk]
set_clock_uncertainty -hold 0.5 [get_clocks clk]

# Design constraints
set_max_area 8000
set_max_fanout 5 vsdbabysoc
set_max_transition 10 vsdbabysoc

# Input constraints
set_input_delay -clock clk -max 4 [get_ports {reset VCO_IN ENb_CP ENb_VCO REF VREFH}]
set_input_delay -clock clk -min 1 [get_ports {reset VCO_IN ENb_CP ENb_VCO REF VREFH}]
set_input_transition -max 0.4 [get_ports {reset VCO_IN ENb_CP ENb_VCO REF VREFH}]
set_input_transition -min 0.1 [get_ports {reset VCO_IN ENb_CP ENb_VCO REF VREFH}]

# Output constraints
set_load -max 0.5 [get_ports OUT]
set_load -min 0.5 [get_ports OUT]
set_output_delay -clock clk -max 0.5 -clock clk [get_ports OUT]
set_output_delay -clock clk -min 0.5 -clock clk [get_ports OUT]

# Path delay
set_max_delay 10 -from [get_clocks clk] -to [get_ports OUT]

