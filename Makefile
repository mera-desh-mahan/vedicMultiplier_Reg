clean:
	rm -rf a.out vedicmultiplier.vcd proton.log* proton.cmd* workarea

sim: clean
	iverilog -o a.out test/test.v  src/adder*.v src/vedic*.v src/halfAdder.v ; ./a.out
	gtkwave vedicmultiplier.vcd

create: clean
		mkdir workarea

gen: create
	cd workarea ; python3 /proj_pd/user_dev/rsrivastava/pyspark_cad/graphs/buffer_chain_generator.py --ins 20 --outs 20 --length 30 --random --sdc 
	/proj_pd/user_dev/rsrivastava/mlpd/tt-spark/create_spark_run_directory.sh  workarea

presta:
		cd workarea ;  /root/OpenSTA/build/sta ../scripts/sf4_sta_synth.tcl
fplan:
	cd workarea ; proton_hier --nogui --cleanlog --nolog -f ../scripts/sf4_cpnr.tcl
	cd workarea ; cp buffer_chain.v inputs/ ; cp buffer_chain.sdc inputs/ ; cp buffer_chain.def inputs

dp:
	cd workarea ; python3 run_spark.py

app:
	apptainer shell --bind /tech:/tech --bind /proj_pd:/proj_pd --bind /home/rsrivastava/:/home/rsrivastava/  /proj_pd/user_dev/rsrivastava/potato/INSTALL/podman/pysparkcad.sif

opensta:
	cd workarea ;  /root/OpenSTA/build/sta  ../scripts/sf4_sta_place.tcl

app2:
	apptainer shell --bind /tech:/tech --bind /proj_pd:/proj_pd --bind /home/rsrivastava/:/home/rsrivastava/  /proj_pd/user_dev/rsrivastava/potato/INSTALL/podman/pysparkbuild.sif 

view:
	cd workarea ; python3 /proj_pd/ML4PD/releases/kaleidoscope/v1.0.0/python/kaleidoscope_pcl.py --def  outputs_final/buffer_chain_final.def.gz --timing buffer_chain.setup.rpt
