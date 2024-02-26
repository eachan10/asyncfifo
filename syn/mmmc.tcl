create_library_set -name ltlv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtssg0p72v0c.lib
}
create_library_set -name ltnv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtssg0p9v0c.lib
}
create_library_set -name lthv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtffg0p99v0c.lib
}
create_library_set -name ntlv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvttt0p8v25c.lib
}
create_library_set -name ntnv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvttt0p9v25c.lib
}
create_library_set -name nthv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvttt1v25c.lib
}
create_library_set -name htlv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtssg0p72v125c.lib
}
create_library_set -name htnv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtssg0p9v125c.lib
}
create_library_set -name hthv -timing {
    ./lib/tcbn28hpcplusbwp30p140hvtffg0p99v125c.lib
}

create_opcond -name opcond_ltlv -process 1 -voltage 0.72 -temperature 0
create_opcond -name opcond_ltnv -process 1 -voltage 0.9 -temperature 0
create_opcond -name opcond_lthv -process 1 -voltage 099 -temperature 0
create_opcond -name opcond_ntlv -process 1 -voltage 0.8 -temperature 25
create_opcond -name opcond_ntnv -process 1 -voltage 0.9 -temperature 25
create_opcond -name opcond_nthv -process 1 -voltage 1 -temperature 25
create_opcond -name opcond_htlv -process 1 -voltage 0.72 -temperature 125
create_opcond -name opcond_htnv -process 1 -voltage 0.9 -temperature 125
create_opcond -name opcond_hthv -process 1 -voltage 0.99 -temperature 125

create_timing_condition -name timing_cond_ltlv -opcond opcond_ltlv -library_sets { ltlv }
create_timing_condition -name timing_cond_ltnv -opcond opcond_ltnv -library_sets { ltnv }
create_timing_condition -name timing_cond_lthv -opcond opcond_lthv -library_sets { lthv }
create_timing_condition -name timing_cond_ntlv -opcond opcond_ntlv -library_sets { ntlv }
create_timing_condition -name timing_cond_ntnv -opcond opcond_ntnv -library_sets { ntnv }
create_timing_condition -name timing_cond_nthv -opcond opcond_nthv -library_sets { nthv }
create_timing_condition -name timing_cond_htlv -opcond opcond_htlv -library_sets { htlv }
create_timing_condition -name timing_cond_htnv -opcond opcond_htnv -library_sets { htnv }
create_timing_condition -name timing_cond_hthv -opcond opcond_hthv -library_sets { hthv }

# add capTbl file
create_rc_corner -name rc_corner -cap_table ./captables/cln28hpc+_1p10m+ut-alrdl_5x2y2r_typical.captab

create_delay_corner -name delay_corner_ltlv -early_timing_condition timing_cond_ltlv \
                    -late_timing_condition timing_cond_ltlv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_ltnv -early_timing_condition timing_cond_ltnv \
                    -late_timing_condition timing_cond_ltnv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_lthv -early_timing_condition timing_cond_lthv \
                    -late_timing_condition timing_cond_lthv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_ntlv -early_timing_condition timing_cond_ntlv \
                    -late_timing_condition timing_cond_ntlv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_ntnv -early_timing_condition timing_cond_ntnv \
                    -late_timing_condition timing_cond_ntnv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_nthv -early_timing_condition timing_cond_nthv \
                    -late_timing_condition timing_cond_nthv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_htlv -early_timing_condition timing_cond_htlv \
                    -late_timing_condition timing_cond_htlv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_htnv -early_timing_condition timing_cond_htnv \
                    -late_timing_condition timing_cond_htnv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_hthv -early_timing_condition timing_cond_hthv \
                    -late_timing_condition timing_cond_hthv -early_rc_corner rc_corner \
                    -late_rc_corner rc_corner

create_constraint_mode -name functional_ltlv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_ltnv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_lthv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_ntlv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_ntnv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_nthv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_htlv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_htnv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_hthv -sdc_file { \
    ./constraints/ntnv.sdc
}
create_constraint_mode -name functional_ntnv -sdc_file { \
    ./constraints/ntnv.sdc
}

create_analysis_view -name view_ltlv -constraint_mode functional_ltlv -delay_corner delay_corner_ltlv
create_analysis_view -name view_ltnv -constraint_mode functional_ltnv -delay_corner delay_corner_ltnv
create_analysis_view -name view_lthv -constraint_mode functional_lthv -delay_corner delay_corner_lthv
create_analysis_view -name view_ntlv -constraint_mode functional_ntlv -delay_corner delay_corner_ntlv
create_analysis_view -name view_ntnv -constraint_mode functional_ntnv -delay_corner delay_corner_ntnv
create_analysis_view -name view_nthv -constraint_mode functional_nthv -delay_corner delay_corner_nthv
create_analysis_view -name view_htlv -constraint_mode functional_htlv -delay_corner delay_corner_htlv
create_analysis_view -name view_htnv -constraint_mode functional_htnv -delay_corner delay_corner_htnv
create_analysis_view -name view_hthv -constraint_mode functional_hthv -delay_corner delay_corner_hthv

set_analysis_view -setup { view_ltlv view_ltnv view_lthv view_ntlv view_ntnv view_nthv view_htlv view_htnv view_hthv}