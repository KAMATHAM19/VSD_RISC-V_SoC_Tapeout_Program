
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
