set DESIGN async_fifo
set SYN_EFF medium
set MAP_EFF medium
set OPT_EFF medium

set _OUTPUTS_PATH OUTPUT/outputs
set _REPORTS_PATH OUTPUT/reports

if {![file exists ${_OUTPUTS_PATH}]} {
    file mkdir ${_OUTPUTS_PATH}
    puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
    file mkdir ${_REPORTS_PATH}
    puts "Creating directory ${_REPORTS_PATH}"
}

set rtlDir ../src

set_db init_lib_search_path {. ./lib }
set_db script_search_path { . }
set_db init_hdl_search_path { . ../src }

set_db syn_generic_effort $SYN_EFF
set_db syn_map_effort $MAP_EFF
set_db syn_opt_effort $OPT_EFF

# idk what these do
set_db tns_opto true
# set_db lp_insert_clock_gating true

set rtlList " \
${rtlDir}/fifo.sv \
${rtlDir}/mem.sv \
${rtlDir}/sync.sv \
${rtlDir}/w_full.sv \
${rtlDir}/r_empty.sv \
"


# synthesis flow
read_mmmc ./mmmc.tcl

read_physical -lefs {
./lef/tsmcn28_10lm5X2Y2RUTRDL.tlef
./lef/tcbn28hpcplusbwp30p140hvt.lef
}
# ./lef/tcbn28hpcplusbwp30p140lvt.lef

read_hdl -sv $rtlList
elaborate $DESIGN

init_design
time_info init_design
check_design -unresolved

syn_generic

write_snapshot -directory $_OUTPUTS_PATH -tag syn_generic 
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC

syn_map

write_snapshot -directory $_OUTPUTS_PATH -tag syn_map 
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED

syn_opt

write_snapshot -innovus -directory $_OUTPUTS_PATH -tag syn_opt
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after syn_opt"
time_info OPT

report_summary -directory $_REPORTS_PATH
report_timing > $_REPORTS_PATH/timing.rpt
write_db -to_file ${DESIGN}.db
write_netlist > ${DESIGN}.v