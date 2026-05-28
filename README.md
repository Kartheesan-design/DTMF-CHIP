
# DTMF Block Implementation — Cadence Innovus with Stylus Common UI

A complete IC physical implementation walkthrough using the **DTMF chip design** as the reference design, running through the full PnR flow in **Cadence Innovus 25.1** with the Stylus Common UI.

---

## Design Overview

| Parameter | Value |
|---|---|
| Design | DTMF chip (hierarchical Verilog netlist) |
| Instances | ~6,000 |
| I/O count | 57 |
| Nets | ~6,400 |
| Process technology | 180 nm, 6 metal layers |
| DMA source clock | `DTMF_INST/clk` |
| SPI clock | `DTMF_INST/spi_clk` |
| Scan clock | `scan_clk` |
| Power/Ground nets | `VDD` / `VSS` |

---

## Prerequisites

- Cadence Innovus Implementation System 25.1 with Stylus Common UI
- License for Innovus and NanoRoute
- Working directory: `FPR/work`
- QRC technology file: `t018s6mm.tch`

### System check

Before starting, verify memory, disk space, and patch levels:

```bash
checkSysConf
```

The command should return `PASS` for all checks.

---

## Flow Overview

```
Synthesis → Floorplan → Power Planning → Placement → Timing (pre-CTS)
    → Clock Tree Synthesis → Detail Route → Timing (post-route) → Verification → ECO
```

---

## Stage 1 — Synthesis 


<img width="469" height="469" alt="image" src="https://github.com/user-attachments/assets/bd0d7315-5e8c-424d-ba64-b0cd98a8043c" />

Start Innovus in Stylus mode:

```bash
cd FPR/work
innovus -stylus
```

Read timing files (MMMC format), physical libraries (LEF), and elaborate the HDL:

```tcl
read_mmmc dtmf_syn.mmmc
read_physical -lef {../lef/all.lef}
elaborate_design -script hdl.tcl
init_design
read_io_file dtmf.io
read_floorplan dtmf_power_syn.fp
```

Define DFT test signals:

```tcl
define_test_signal -name test_mode -active high -function test_mode test_mode
define_test_signal -name scan_en -active high -function shift_enable -default scan_en
```

Run synthesis and DFT:

```tcl
synthesize_design
dft_design -script dft_script.tcl
```

Write out the gate-level netlist:

```tcl
write_netlist inv_syn_dtmf_dft.v
```

---

## Stage 2 — Design Import & Floorplanning 

### Import 

```bash
innovus -stylus
```
<img width="750" height="344" alt="image" src="https://github.com/user-attachments/assets/305a6cfe-0787-4b50-a8d7-b7239946f7a5" />

Via GUI: **File → Import Design**, then fill in:

| Field | Value |
|---|---|
| Verilog files | `../verilog/dtmf_chip_ak.v` |
| LEF files | `../lef/all.lef` |
| Power Nets | `VDD` |
| Ground Nets | `VSS` |
| MMMC View Definition File | `dtmf.mmmc` |

Place I/Os from a DEF file:

```tcl
read_def DTMF_CHIP_io.def
```

Press `f` to fit the design to the screen.

### Floorplan initialization 

Initialize the floorplan via **Floorplan → Initialize Floorplan**. Ungroup the `DTMF_INST` module once:

```tcl
# Select DTMF_INST in the Physical view, then press Shift-G once
```
<img width="547" height="547" alt="image" src="https://github.com/user-attachments/assets/a8615580-009e-4e25-b045-7798aa2dfa30" />

Check the design via **Verify → Check Design** before proceeding.

### Power planning & relative floorplanning 

Place hard macro blocks using relative floorplanning:

```tcl
create_relative_floorplan -place DTMF_INST/ARB_INST/ROM_512x16_0_INST \
    ...
create_relative_floorplan -place DTMF_INST/PLLCLK_INST \
    -ref DTMF_INST/ARB_INST/ROM_512x16_0_INST \
    ...
```

Load the block floorplan and add a placement halo around the PLL:

```tcl
# File → Load → Floorplan → dtmf_blocks.fp
create_place_halo -halo_deltas {30 30 30 30} -inst DTMF_INST/PLLCLK_INST
```

Create power rings, stripes, and followpin routes via **Route → Special Route**.

### Early rail analysis

```tcl
innovus -stylus
source dtmf.setup
# File → Load → Floorplan → dtmf_power.fp

# Run static power analysis:
# Power → Power Analysis → Setup → Static → OK
# Power → Power Analysis → Run → Results Directory: ./run1 → OK

source power.tcl

# Run rail analysis:
# Power → Rail Analysis → Setup
#   Analysis Stage: Early
#   Analysis View: default_analysis_view_setup
#   QRC Tech File: t018s6mm.tch
# Power → Rail Analysis → Run
#   Net Based, VDD=0.9V, Threshold=0.81V, Ground Net: VSS

read_power_rail_results -power_db run1/power.db \
    -rail_directory run1/VDD_25C_avg_1
# Power → Report → Power Rail Result
```

Save the session:

```tcl
# File → Save Design → floorplan.inn
```
<img width="547" height="547" alt="image" src="https://github.com/user-attachments/assets/58e04139-ba7c-42c4-8a57-a9fb6c0b1689" />

---

## Stage 3 — Placement 

```tcl
innovus -stylus
source dtmf.setup
# File → Load → Floorplan → dtmf.fp

read_def scan_input.def
place_opt_design
write_def_by_section scan.def -no_nets -no_comp -scan_chains
write_db placeOpt.inn
```
<img width="625" height="625" alt="image" src="https://github.com/user-attachments/assets/bddad5cf-a200-4c06-ad23-c54d42267f56" />

Check post-placement status, WNS, and scan chain display via **Place → Display → Scan Chain**.

### Early global route 

```tcl
# Route → Early Global Route
#   Min Layer: Metal1, Max Layer: Metal3 → OK
```

Analyze the congestion map (**eGR-2D / eGR-3D**). Congestion notation: `V:4` means 4 more vertical tracks required than available.

Save:

```tcl
# File → Save Design → earlyGlobalrouted.inn
```

---

## Stage 4 — Pre-CTS Timing Analysis 

### RC extraction

```tcl
# Timing → Extract RC → OK
# Status bar should change to "RC Extracted"
```

### Delay calculation

```tcl
write_sdf dtmf.sdf -ideal_clock_network
```

### Timing analysis

```tcl
# Timing → Report Timing
#   Pre-CTS: ON, Setup: ON → OK

time_design -pre_cts -hold
```

Review failing paths in **Timing → Debug Timing**. Check Worst Negative Slack (WNS) and Total Negative Slack (TNS) for both setup and hold.

Save:

```tcl
# File → Save Design → preCTSopt.inn
```

---

## Stage 5 — Clock Tree Synthesis 

```tcl
read_db ../saved/preCTSopt.inn
source dtmf.ccopt              # Sets cts_buffer_cells and cts_inverter_cells
create_clock_tree_spec -out_file dtmf_clk.spec
clock_opt_design
```

Check the CTS log for constraint violations. View the clock tree in the **Clock → CCOpt Clock Tree Debugger**.
<img width="625" height="625" alt="image" src="https://github.com/user-attachments/assets/6c5b7053-e71c-42a6-81f9-d0e958d3405c" />

Post-CTS timing:

```tcl
time_design -post_cts
time_design -post_cts -hold

# If hold violations exist:
opt_design -post_cts -hold
```

Save:

```tcl
# File → Save Design → postCTSopt.inv
```

### RC scale factors (Lab 15-2)

For better correlation between native extraction and signoff extraction:

```tcl
read_db routedExtracted.inv.dat
report_rc_factors -pre_route true -post_route medium \
    -reference external_spef -spef_map_file spef.map
# Source the generated scaleFactor.tcl and regenerate MMMC with write_mmmc
```

---

## Stage 6 — Detail Routing 

Load the post-CTS design and set critical net attributes:

```tcl
innovus -stylus
# File → Restore Design → postCTSopt.inv

# Shield the read_data net with VDD
set_route_attributes \
    -nets DTMF_INST/TDSP_CORE_INST/read_data \
    -shield_nets VDD

# Add spacing around the clock net
set_route_attributes -nets DTMF_INST/clk -preferred_extra_space_tracks 2
```

Route the shielded net first via **Route → NanoRoute → Route** with Timing Driven and SI Driven enabled, Selected Nets Only, layers Metal1–Metal6.

Then route all remaining nets with concurrent optimization:

```tcl
set_db route_selected_net_only false
set_db route_design_detail_use_multi_cut_via_effort medium
set_db timing_analysis_type ocv
route_opt_design
```

Verify timing closure:

```tcl
time_design -post_route
time_design -post_route -hold

# Repair residual violations if needed:
route_opt_design -opt -setup
route_opt_design -opt -hold
```

Save:

```tcl
# File → Save Design → DTMF_detailrouted.inn
```
<img width="656" height="656" alt="image" src="https://github.com/user-attachments/assets/52a35ede-5f72-4a22-8e28-8fcf582b041d" />

---

## Stage 7 — Wire Editing 

For manual routing or wire modifications, load `EditRoute.dat` and use the Interactive Wire Editor (press `e` to open). Key bindkeys:

| Key | Action |
|---|---|
| `Shift+A` | Enter Add Wire mode (pencil cursor) |
| `1`–`6` | Switch to Metal layer N |
| `u` / `d` | Move to next higher / lower layer |
| `Ctrl+W` | Undo last wire segment |
| `Shift+N` / `Shift+P` | Cycle via types |
| `e` | Open Edit Route form |
| `a` | Return to Select mode |

---

## Stage 8 — Verification 

```tcl
innovus -stylus
read_db tdsp_core.enc.dat
connect_global_net VDD -type pg_pin -pin VDD -inst_base_name *
connect_global_net VSS -type pg_pin -pin VSS -inst_base_name *
read_def tdsp_core_routed.def
```

Run DRC and connectivity checks:

```tcl
# Check → Check DRC → OK
# Verify → Verify Connectivity (Geometry Loop option) → OK
check_drc -view_window
```
<img width="688" height="227" alt="image" src="https://github.com/user-attachments/assets/d5a80e48-f519-4074-ace7-26c4369ce1b7" />

Browse violations via **Tools → Violation Browser**. Fix loop segments by selecting and pressing `d` → Delete. Rerun checks after each fix.

LEF influence spacing rule to be aware of for Metal4:
```
WIDTH 3.0 WITHIN 0.90 SPACING 0.90;
# A wire ≥3.0µm wide requires 0.9µm spacing from perpendicular wires within a 0.9µm halo
```

---

## Stage 9 — Engineering Change Orders 

```tcl
innovus -stylus
eco_design tdsp_core.dat tdsp_core tdsp_core_eco.v
write_def tdsp_core_routed_eco.def
eco_compare_netlist -def_file tdsp_core.def -out_file eco_file
```

---

## Stage 10 — Stylus Automated Flow 

Generate the full flow scripts:

```tcl
innovus -stylus
write_flow_template -type stylus -tools innovus
```

Configure the generated scripts:

```bash
cd scripts
mv innovus_config.template innovus_config.tcl
mv setup.yaml_template setup.yaml
mv flow_config.template flow_config.tcl
mv flow.yaml_template flow.yaml
mv eco_config.template eco_config.tcl
mv design_config.template design_config.tcl
```

Populate `setup.yaml` and `design_config.tcl` with technology, library, and clock routing info. Preview and run the flow:

```bash
flowtool -predict summary    # dry run — no databases saved
flowtool -reset              # full run
```

Review results:

```bash
cd reports
firefox qor.html &
```

The QoR report shows WNS, TNS, DRV violations, and total power at each flow stage.

---

## Key Files Reference

| File | Purpose |
|---|---|
| `dtmf.mmmc` | Multi-Mode Multi-Corner view definitions |
| `dtmf.io` | I/O pad placement |
| `dtmf.setup` | Library and DEF import script |
| `dtmf.ccopt` | CTS buffer/inverter cell constraints |
| `dtmf_syn.mmmc` | Synthesis MMMC file |
| `dtmf_clk.spec` | Generated clock tree spec |
| `t018s6mm.tch` | QRC technology file (180nm) |
| `scan_input.def` | Scan chain DEF |
| `power.tcl` | Global net power connection rules |
| `dtmf.pp` | Pad location XY file for rail analysis |
| `spef.map` | SPEF mapping for RC scale factor generation |

---

## Saved Design Checkpoints

| Checkpoint file | Flow stage |
|---|---|
| `floorplan.inn` | After floorplan + power routing |
| `placeOpt.inn` | After placement optimization |
| `earlyGlobalrouted.inn` | After early global route |
| `pr.inn` | After placement + early global route |
| `preCTSopt.inn` | After pre-CTS timing optimization |
| `postCTSopt.inv` | After CTS + post-CTS optimization |
| `DTMF_detailrouted.inn` | After detail routing |

---

## Useful Innovus Commands

```tcl
# Database inspection
get_db program_version
get_db base_cells
get_db base_cells PDO*
get_db base_cell:PDO04CDG .*
get_db timing_conditions

# Help on an object type
help -obj base_cell

# Restore a saved design
read_db path/to/design.inn
```

---

## References

- Cadence Innovus Implementation System documentation
- Innovus Block Implementation with Stylus Common UI — Lab Manual, Course Version 25.1 (May 2025)
- `designDTMF.pdf` — DTMF design reference (located in `FPR/doc/`)
