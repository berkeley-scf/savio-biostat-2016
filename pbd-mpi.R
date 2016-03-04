## @knitr pbd-mpi

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r openmpi
# mpirun Rscript pbd-mpi.R > pbd-mpi.Rout


library(pbdMPI, quiet = TRUE )
init()

myRank <- comm.rank() # comm index starts at 0 , not 1
comm.print(myRank , all.rank=TRUE)

if(myRank == 0) {
    comm.print(paste0("hello, world from the master: ", myRank), all.rank=TRUE)
} else comm.print(paste0("hello from ", myRank), all.rank=TRUE)

if(comm.rank() == 0) print(date())
set.seed(myRank)  # see Section 9 for more on parallel random number generation
N.gbd <- 1e7
X.gbd <- matrix ( runif ( N.gbd * 2) , ncol = 2)
r.gbd <- sum ( rowSums ( X.gbd^2) <= 1)
ret <- allreduce ( c ( N.gbd , r.gbd ) , op = "sum" )
PI <- 4 * ret [2] / ret [1]
comm.print(paste0("Pi is roughly: ", PI))
if(comm.rank() == 0) print(date())

finalize ()
