set sdc_version 1.4

current_design async_fifo

set_units -time ns

# 50 MHz
create_clock -name "WCLK" -add -period 20 -waveform {0.0 10.0} [get_ports w_clk]
set_clock_uncertainty -setup 0.1 [get_clocks WCLK]
set_clock_uncertainty -hold 0.1 [get_clocks WCLK]
# 500 MHz
create_clock -name "RCLK" -add -period 2 -waveform {0.0 1.0} [get_ports r_clk]
set_clock_uncertainty -setup 0.1 [get_clocks RCLK]
set_clock_uncertainty -hold 0.1 [get_clocks RCLK]

# set clock asynchronous
set_clock_groups -asynchronous -group WCLK -group RCLK

# Async reset
set_false_path -from [get_ports rst]

# Synchronizer inputs
set_false_path -to [get_pins r2w_sync/ptr_in]
set_false_path -to [get_pins w2r_sync/ptr_in]

# Synchronizer ff
set_max_delay 0.3 -from [get_pins r2w_sync/ptr_in]
set_max_delay 0.3 -to [get_pins r2w_sync/ptr_out]
set_max_delay 0.3 -from [get_pins w2r_sync/ptr_in]
set_max_delay 0.3 -to [get_pins r2w_sync/ptr_out]

# Inputs
set_input_delay -clock [get_clocks RCLK] 0.3 [get_ports r_en]

set_input_delay -clock [get_clocks WCLK] 0.3 [get_ports w_en]
set_input_delay -clock [get_clocks WCLK] 0.3 [get_ports w_data]

# Outputs
set_output_delay -clock [get_clocks RCLK] 0.3 [get_ports out]
set_output_delay -clock [get_clocks RCLK] 0.3 [get_ports empty]
set_output_delay -clock [get_clocks RCLK] 0.3 [get_ports almost_empty]

set_output_delay -clock [get_clocks WCLK] 0.3 [get_ports full]
set_output_delay -clock [get_clocks WCLK] 0.3 [get_ports almost_full]

# idk how to calculate or choose this stuff
set_max_fanout 15.000 [current_design]
set_max_transition 1.2 [current_design]