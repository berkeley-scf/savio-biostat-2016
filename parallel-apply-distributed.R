## @knitr parallel-apply-distributed

# example invocation
# sbatch -A ac_scsguest -p savio  -n 40 -t 30:0 job.sh
#
# job.sh:
# module load r
# R CMD BATCH --no-save parallel-apply-distributed.R parallel-apply-distributed.Rout

library(parallel)

machines=rep(strsplit(Sys.getenv("SLURM_NODELIST"), ",")[[1]],
             each = as.numeric(Sys.getenv("SLURM_CPUS_ON_NODE")) )

cl = makeCluster(machines)

nTasks <- 60
input <- 1:nTasks

taskFun <- function(){
        mn <- mean(rnorm(1000000))
        return(mn)
}

# if the processes need objects (x and y, here) from the master's workspace:
# clusterExport(cl, c('x', 'y'))

res <- parSapply(cl, input, taskFun)
