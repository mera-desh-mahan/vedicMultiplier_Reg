read_config_file -config /proj_pd/user_dev/rsrivastava/mlpd/tech/library.config -technode 4nm -foundary samsung -layer 16

read_verilog -v buffer_chain.v
elaborate
set_floorplan_parameters -WIDTH 55 -HEIGHT 50
set_floorplan --force

#create_net -type power -name VDD
#create_net -type ground -name GND
#addPowerRing -offset {0.2,0.2} -spacing 0.5 -width 1 -layerH 3 -layerV 2 -nets {VDD,GND}
#addPowerRows -width 0.5 -layer 1 -nets {VDD,GND}
#addPowerVias
#

prePlaceData --noTrace --noLevel
seedPlace
syncPlace
snapPlace --iosOnly
remove_pins_overlap

add_endcap -cell FILL1_DX_L_S6P25TL_C54L04
add_wellties -cell FILLTIE_DX_L_S6P25TR_C54L04 -x 15
write_sdef
write_sgraph
#write_lef -tech also -output all.lef
write_def -output buffer_chain.def --overwrite
