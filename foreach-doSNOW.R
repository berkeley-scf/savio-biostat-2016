## @knitr foreach-doSNOW

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r
# R CMD BATCH --no-save foreach-doSNOW.R foreach-doSNOW.Rout

install.packages(c('doSNOW'), repos = 'http://cran.cnr.berkeley.edu')

library(doSNOW)
machines=rep(strsplit(Sys.getenv("SLURM_NODELIST"), ",")[[1]],
             each = as.numeric(Sys.getenv("SLURM_CPUS_ON_NODE")) )

cl = makeCluster(machines)

registerDoSNOW(cl)

taskFun <- function(){
	mn <- mean(rnorm(10000000))
	return(mn)
}

nTasks <- 120

print(system.time(out <- foreach(i = 1:nTasks) %dopar% {
	outSub <- taskFun()
	outSub # this will become part of the out object
}))


