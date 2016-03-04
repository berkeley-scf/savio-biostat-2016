## @knitr foreach-multicore

# example invocation
# sbatch -A ac_scsguest -p savio  -N 1 -t 30:0 job.sh
#
# job.sh:
# R CMD BATCH --no-save foreach-multicore.R foreach-multicore.Rout

install.packages('doParallel', repos = 'http://cran.cnr.berkeley.edu')

library(doParallel)
taskFun <- function(){
	mn <- mean(rnorm(10000000))
	return(mn)
}
nCores <- Sys.getenv('SLURM_CPUS_ON_NODE')
registerDoParallel(nCores) 

nTasks <- 60
print(system.time(out <- foreach(i = 1:nTasks) %dopar% {
	cat('Starting ', i, 'th job.\n', sep = '')
	outSub <- taskFun()
	cat('Finishing ', i, 'th job.\n', sep = '')
	outSub # this will become part of the out object
}))

