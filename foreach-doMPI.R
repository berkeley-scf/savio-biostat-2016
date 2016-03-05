## @knitr foreach-doMPI

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r openmpi Rmpi
# mpirun R CMD BATCH --no-save foreach-doMPI.R foreach-doMPI.Rout


library(doMPI)

cl = startMPIcluster()  # by default will start one fewer workers than SLURM_NTASKS (one for master) -- you may want to change this to have one worker on all cores

nTasks <- 120

registerDoMPI(cl)
print(clusterSize(cl)) # just to check

taskFun <- function(){
	mn <- mean(rnorm(10000000))
	return(mn)
}

print(system.time(out <- foreach(i = 1:nTasks) %dopar% {
	outSub <- taskFun()
	outSub # this will become part of the out object
}))


closeCluster(cl)

mpi.quit()
