
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
    read_sdc ./src/sdc/updated_synth.sdc

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
puts "\n All corners analyzed. Reports saved in ./sta_outputs/"

