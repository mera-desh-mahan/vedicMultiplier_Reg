clean:
	rm -rf a.out vedicmultiplier.vcd proton.log* proton.cmd* workarea

sim: clean
	iverilog -o a.out test/test.v  src/adder*.v src/vedic*.v src/halfAdder.v ; ./a.out
	gtkwave vedicmultiplier.vcd

syn: create
	#cd workarea ; yosys -s ../scripts/synthesis.tcl ; cat vedic.vg  | egrep -v "\(\*" > vedic_filter.vg
	cd workarea ; yosys -s ../scripts/sf4_synthesis.tcl ; cat vedic.vg  | egrep -v "\(\*" > vedic_filter.vg

presta:
		cd workarea ;  /root/OpenSTA/build/sta ../scripts/sf4_sta_synth.tcl
cpnr:
	cd workarea ; proton_hier --nogui --cleanlog --nolog -f ../scripts/nangate_cpnr.tcl

create: clean
		mkdir workarea

app:
	apptainer shell --bind /tech:/tech --bind /proj_pd:/proj_pd --bind /home/rsrivastava/:/home/rsrivastava/  ~/podman/pysparkcad.sif

test1:
	cd workarea ; proton_hier --nogui --cleanlog --nolog -f ../scripts/sf4_cpnr.tcl
