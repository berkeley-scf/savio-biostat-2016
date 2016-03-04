## @knitr parallel-apply-multicore


# example invocation
# sbatch -A ac_scsguest -p savio  -N 1 -t 30:0 job.sh
#
# job.sh:
# module load r
# R CMD BATCH --no-save parallel-apply-multicore.R parallel-apply-multicore.Rout


library(parallel)

nCores <- as.numeric(Sys.getenv('SLURM_CPUS_ON_NODE'))
cl <- makeCluster(nCores) 

nTasks <- 60
input <- 1:nTasks

taskFun <- function(i){
        mn <- mean(rnorm(1000000))
        return(mn)
}

# if the processes need objects (x and y, here) from the master's workspace:
# clusterExport(cl, c('x', 'y')) 

res <- parSapply(cl, input, taskFun)
