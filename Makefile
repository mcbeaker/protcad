export TOP=$(PWD)
export SRCDIR=$(TOP)/src
export TNTINCLUDE=$(TOP)/src
export BINDIR=$(TOP)/bin
export OBJDIR=$(TOP)/obj
export PROJDIR=$(TOP)/projects

export CXX = g++
export F77 = g77
export MAKE = make

SHELL = /bin/sh

TARGETS = example

.SUFFIXES:
.SUFFIXES: .cc .o .h .a

LIB_TARGETS = lib

LIB_CC_OBJECTS = ran1.o ran.o point.o treeNode.o atom.o atomIterator.o residue.o chain.o residueTemplate.o allowedResidue.o secondaryStructure.o chainPosition.o residueIterator.o chainModBuffer.o molecule.o protein.o ensemble.o CMath.o generalio.o pdbData.o pdbReader.o pdbWriter.o amberVDW.o aaBaseline.o amberElec.o rotamer.o rotamerLib.o annealer.o PDBAtomRecord.o PDBInterface.o ruler.o line.o lineSegment.o unitSphere.o helixPropensity.o parse.o ramachandranMap.o

#DEFS = -DHAVE_OPENGL=1 -D_ALLOWED_RESIDUE_DEBUG
#DEFS = -DHAVE_OPENGL=1 -D__STL_USE_EXCEPTIONS
#DEFS = -DHAVE_OPENGL=1 -D__STL_USE_EXCEPTIONS -DMICROENV_DEBUG_ATOM_TYPES -DATOM_TYPE_DEBUG \
-DMICROENVDB_DEBUG

DEFS = -DHAVE_OPENGL=1 -D__STL_USE_EXCEPTIONS -DMICROENV_DEBUG_ATOM_TYPES -DATOM_TYPE_DEBUG

FLAG_OPT = -Wall -O -g -felide-constructors -Wno-deprecated
FLAG_OPT2 = -Wall -O2 -g -Wno-deprecated
FLAG_OPT3 = -Wall -O3  -g -felide-constructors -Wno-deprecated
FLAG_PROF = -Wall -O3 -felide-constructors -pg -Wno-deprecated
FLAG_DEBUG = -Wall -g2 -felide-constructors -Wno-deprecated
FLAG_DEBUG2 = -Wall -g2 -ansi -pedantic -Wno-deprecated
FLAG_OPTMAX = -Wall -O2 -ftree-vectorize -march=native -mtune=native -pipe -msse3 -Wno-deprecated -fopenmp

CFLAGS = $(FLAG_OPTMAX) $(DEFS)
FFLAGS = -Wall -g 

INC_BASE = -I$(SRCDIR)/ensemble -I$(SRCDIR)/io \
-I$(SRCDIR)/math -I$(SRCDIR)/database -I$(SRCDIR)/algorithm \
-I$(TNTINCLUDE)

LIB_BASE = -L$(OBJDIR) -lprotcad  -lc -lm -lstdc++

vpath %.h $(SRCDIR)/algorithm:$(SRCDIR)/ensemble:$(SRCDIR)/database:\
	$(SRCDIR)/ensemble:$(SRCDIR)/io:\
	$(SRCDIR)/math

vpath %.cc $(SRCDIR)/algorithm:$(SRCDIR)/ensemble:$(SRCDIR)/database:\
	$(SRCDIR)/ensemble:$(SRCDIR)/io:\
	$(SRCDIR)/math:$(PROJDIR):
	
vpath %.f $(SRCDIR)/math

vpath %.a $(OBJDIR)

vpath %.o $(OBJDIR)

all : $(LIB_TARGETS) $(TARGETS)

lib : libprotcad.a

libprotcad.a : $(LIB_CC_OBJECTS) $(LIB_F77_OBJECTS)
		cd $(OBJDIR) && ar rv libprotcad.a $?
		cd $(OBJDIR) && ranlib libprotcad.a

example : libprotcad.a example.cc
	cd $(OBJDIR) && $(CXX) $(CFLAGS) $^ -o $@ $(INC_BASE) $(LIB_BASE)
	cd $(OBJDIR) && mv $@ $(BINDIR)

$(LIB_CC_OBJECTS): %.o: %.cc %.h
	$(CXX) -c $(CFLAGS) $(INC_BASE) $< -o $@
	mv $@ $(OBJDIR)

clean: 
	rm -f $(OBJDIR)/*.o 
	rm -f $(OBJDIR)/*.a
	cd $(BINDIR) && rm -f $(TARGETS)
