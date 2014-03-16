
SCALING_FACTORS:=0.01 0.1 

TARGET:=target
TPCH_DIR:=$(TARGET)/tpch/tpch_2_16_1
DBGEN_DIR:=$(TPCH_DIR)/dbgen

DATASET_DIR:=$(TARGET)/dataset
DATASET:=$(addsuffix .log,$(addprefix $(DATASET_DIR)/,$(SCALING_FACTORS)))

dataset: $(DATASET)
dbgen: $(DBGEN_DIR)/dbgen

$(TPCH_DIR).zip:
	mkdir -p $(@D)
	curl -o $@ http://www.tpc.org/tpch/spec/tpch_2_16_1.zip

$(TPCH_DIR): $(TPCH_DIR).zip
	mkdir -p $(TARGET)/tpch
	unzip -o $< -d $(TARGET)/tpch/

$(DBGEN_DIR)/dbgen: $(DBGEN_DIR)/Makefile
	cd $(DBGEN_DIR) && make 

$(DBGEN_DIR)/Makefile: $(TPCH_DIR)
	cd $(DBGEN_DIR) && \
	cp makefile.suite Makefile && \
	perl -i -npe "s/CC\s*=/CC=gcc/" Makefile && \
	perl -i -npe "s/DATABASE\s*=.*/DATABASE=ORACLE/" Makefile && \
	perl -i -npe "s/MACHINE\s+=.*/MACHINE=LINUX/" Makefile && \
	perl -i -npe "s/WORKLOAD\s+=.*/WORKLOAD=TPCH/" Makefile && \
	perl -i -npe "s/CFLAGS\s+=(.*)/CFLAGS=\1 -D_POSIX_SOURCE/" Makefile 


$(DATASET_DIR)/%.log : $(DBGEN_DIR)/dbgen
	mkdir -p $(@:.log=)
	cd $(DBGEN_DIR) && \
	./dbgen -fv -s $(@F) 
	mv $(DBGEN_DIR)/*.tbl $(@:.log=)
	touch $@


