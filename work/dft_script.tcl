


# scan in/out ports
for { set i 1 } {$i <= 2} {incr i} {
  define_scan_chain -name chain$i -sdi scan_in_${i} -sdo scan_out_${i} -non_shared_output
}

check_dft_rules

set_compatible_test_clocks -all

connect_scan_chains












