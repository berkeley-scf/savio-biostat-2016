module swap intel gcc
module load r openmpi

# first install pbdSLAP and pbdMPI as pbdBASE depends on them
cat <<EOF > ~/R-packages.txt
pbdSLAP
pbdMPI
EOF

Rscript -e "pkgs <- scan('~/R-packages.txt', what = 'char'); install.packages(pkgs, repos = 'http://cran.cnr.berkeley.edu')"

# current 0.4-3 pbdBASE pkg has a bug so install patched version from Github; next version on CRAN should be fine
git clone https://github.com/wrathematics/pbdBASE
R CMD build pbdBASE
R CMD INSTALL pbdBASE_0.4-3.tar.gz

# now install the remaining pbd packaged, which depend on pbdBASE
cat <<EOF > ~/R-packages.txt
pbdDMAT
pbdDEMO
EOF

Rscript -e "pkgs <- scan('~/R-packages.txt', what = 'char'); install.packages(pkgs, repos = 'http://cran.cnr.berkeley.edu')"

# you can ignore the messages about "An MPI process has executed an operation involving a call to..."
