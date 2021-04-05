#!/bin/bash
AMBERHOME=/opt/amber

# This CPPtraj script does a few things in one script. Edit to suit your needs.
############################
# write a cpptraj input file#
############################
cat > CPPtraj.in << EOF
#############################################
# Specify the topology file, and its location
#############################################
parm ../../md_corrected/md_250k/cln025.new_H_mass.top
#############################################
# Specific the crd/trj file(s), and locations
############################################
trajin ../../md_corrected/md_250k/md.x

#########################################################
# Specify the crd/trj output file.                      #
# Specify 'nobox' if you plan to strip and use gas phase#
# topology file for VMD'ing or analyses                  #
# crd extension tells cpptraj to use amber text trajectory format
#########################################################
trajout ./5awl.md.crd nobox
##########################

# cpptraj allows multiple reference structures to be used
# they each need a "tag" that you refer to when using the reference structure

 reference ../../md_corrected/md_250k/min.r [min]
 reference ../references/5awl_ref.crd [folded]

# calculate backbone rmsd to initial structure
 rmsd rms1 ref [min] :2-8@CA,N,C,O out rmsd.5awl_250k.ref_init.2-19.bb.dat

# calculate backbone rmsd to folded structure
 rmsd rms2 ref [folded] :2-8@CA,N,C,O out rmsd.5awl_250k.ref_native.2-19.bb.dat

########################################
#Stop writing to the CPPtraj input file#
########################################
EOF
####################################################
# Run CPPtraj, using the above input file...#
####################################################
$AMBERHOME/bin/cpptraj -i CPPtraj.in
