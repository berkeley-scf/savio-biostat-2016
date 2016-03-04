## @knitr pbd-apply

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r openmpi
# mpirun Rscript pbd-apply.R > pbd-apply.Rout

library(pbdMPI, quiet = TRUE )
init()

if(comm.rank()==0) {
    x <- matrix(rnorm(1e6*50), 1e6)
}

sm <- comm.timer(pbdApply(x, 1, mean, pbd.mode = 'mw', rank.source = 0))
if(comm.rank()==0) {
    print(sm)
}

finalize()
