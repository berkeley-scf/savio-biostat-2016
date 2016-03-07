## @knitr pbd-linalg

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r openmpi
# mpirun Rscript pbd-linalg.R > pbd-linalg.Rout

library(pbdDMAT, quiet = TRUE )

n <- 4096*2  # did a test with a 16k by 16k matrix, but for quicker demo do 8k by 8k

init.grid()

if(comm.rank()==0) print(date())

# pbd allows for parallel I/O, but here
# we keep things simple and distribute
# an object from one process
if(comm.rank() == 0) {
    x <- rnorm(n^2)
    dim(x) <- c(n, n)
} else x <- NULL
dx <- as.ddmatrix(x)

# sigma = X'*X
timing <- comm.timer(sigma <- crossprod(dx))

if(comm.rank()==0) {
    print(date())
    print(timing)
}

# Cholesky factor of sigma
timing <- comm.timer(out <- chol(sigma))

if(comm.rank()==0) {
    print(date())
    print(timing)
}


finalize()
