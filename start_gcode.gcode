G90 ; use absolute coordinates
M83 ; extruder relative mode
M104 S{is_nil(idle_temperature[0]) ? 150 : idle_temperature[0]} ; set temporary nozzle temp to prevent oozing during homing
M140 S{first_layer_bed_temperature[0]} ; set final bed temp
G4 S30 ; allow partial nozzle warmup
G28 ; home all axis


; Mesh Calibration
M420 S0  ; Turning off bed leveling while probing, if firmware is set
         ; to restore after G28
M117 Heating the bed ; send message to printer display
M190 S60 ; waiting until the bed is fully warmed up
M300 S1000 P500 ; chirp to indicate bed mesh levels is initializing
M117 Creating the bed mesh levels ; send message to printer display
M155 S30 ; reduce temperature reporting rate to reduce output pollution
@BEDLEVELVISUALIZER	; tell the plugin to watch for reported mesh
G29 T	   ; run bilinear probing
M155 S3  ; reset temperature reporting
M140 S0 ; cooling down the bed
M500 ; store mesh in EEPROM
M300 S440 P200 ; make calibration completed tones
M117 Bed mesh levels completed ; send message to printer display



G1 Z50 F240
G1 X2.0 Y10 F3000
M104 S{first_layer_temperature[0]} ; set final nozzle temp
M190 S{first_layer_bed_temperature[0]} ; wait for bed temp to stabilize
M109 S{first_layer_temperature[0]} ; wait for nozzle temp to stabilize
G1 Z0.28 F240
G92 E0
G1 X2.0 Y140 E10 F1500 ; prime the nozzle
G1 X2.3 Y140 F5000
G92 E0
G1 X2.3 Y10 E10 F1200 ; prime the nozzle
G92 E0
