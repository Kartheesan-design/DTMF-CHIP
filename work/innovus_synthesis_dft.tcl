#########################
#Innovus Synthesis Flow
#Date: 04/01/2025
#Version: 0.1
#########################


#Reading MMMC File
read_mmmc dtmf_syn.mmmc

#Reading Lef file
read_physical -lef {../lef/all.lef}

#Elaborate Design
#set_dont_touch [get_cells IOPADS_INST/*]
elaborate_design -script hdl.tcl
init_design

#Pin/Pad Assignment
read_io_file dtmf.io

#Floorplan
read_floorplan dtmf_power_syn.fp

#DFT setup
define_test_signal -name test_mode -active high -function test_mode test_mode
define_test_signal -name scan_en -active high -function shift_enable -default scan_en

#synthesize 
synthesize_design 

dft_design -script dft_script.tcl

#Writing Synthesized Netlist
write_netlist inv_syn_dtmf_dft.v


######### place_opt_design ###########
#place_opt_design
#write_db dbs/place.db


######### clock_opt_design ###########
#clock_opt_design
#write_db dbs/clock.db

######### route_opt_design ###########
#route_opt_design
#write_db dbs/route.db

#report_metric -format vivid -file final.html
#report_metric -format text



gui_show
