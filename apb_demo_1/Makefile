all: comp verdi

comp:
	vcs -f file.f \
	    -sverilog \
	    -timescale=1ns/1ns \
		-fsdb  -full64 -R  +vc  +v2k  -debug_acc+all -debug_region+cell+encrypt \
	    |  tee  vcs.log 

verdi:
	verdi -f file.f -ssf apb_master.fsdb

clean:
	rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd
