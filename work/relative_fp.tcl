create_relative_floorplan -place DTMF_INST/ARB_INST/ROM_512x16_0_INST \
-ref_type core_boundary \
-horizontal_edge_separate {1 -40 1} \
-vertical_edge_separate {0 -10 0} 

create_relative_floorplan -place DTMF_INST/PLLCLK_INST  \
-ref_type object \
-ref DTMF_INST/ARB_INST/ROM_512x16_0_INST \
-horizontal_edge_separate {1 10 1} \
-vertical_edge_separate {2 40 0} 

delete_relative_floorplan DTMF_INST/ARB_INST/ROM_512x16_0_INST

