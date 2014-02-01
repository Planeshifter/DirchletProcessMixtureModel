

# 
# assumes x is a data frame where the columns are the features x_1, x_2, etc. 
#
dp.means = function(data, lambda, max.iterations = 100, tolerance = 10e-3)
  {
  K = 1 # set number of clusters k equal to one
  n_obs = nrow(data)
  mu.x1  = mean(data$x1) # initialize global mean 
  mu.x2  = mean(data$x2)
  assignments <- rep(1, n_obs)
  
  converged <- FALSE
  iteration <- 0
  
  ss.old <- Inf
  ss.new <- Inf
  
  while (!converged && iteration < max.iterations)
  {
  iteration <- iteration + 1
    
    for(i in 1:n_obs)
      {
      
      distances = rep(NA, K)
      
      for (k in 1:K)
        {
        distances[k] <- (data[i, 'x1'] - mu.x1[k])^2 + (data[i, 'x2'] - mu.x2[k])^2 # compute squared Euclidean distance   
        }

      if (min(distances) > lambda) 
        {
        K = K + 1
        assignments[i] = K
        mu.x1[K] = data[i,"x1"]
        mu.x2[K] = data[i,"x2"]
        }
      else
        {
        assignments[i] = which(distances==min(distances))    
        }
      for (k in 1:K)
        {
        if (length(assignments == k) > 0)
          {
          mu.x1[k] = mean(data[assignments==k,"x1"]) 
          mu.x2[k] = mean(data[assignments==k,"x2"])
          }
        }
      }
  
  ss.new <- 0
  
  for (i in 1:n_obs)
    {
      ss.new <- ss.new + (data[i, 'x1'] - mu.x1[assignments[i]])^2 + (data[i, 'x2'] - mu.x2[assignments[i]])^2
    }
  
  ss.change <- ss.old - ss.new
  ss.old <- ss.new
  
  if (!is.nan(ss.change) && ss.change < tolerance)
    {
      converged <- TRUE
    }
  }
  
  centers <- data.frame(x1 = mu.x1, x2 = mu.x2)
  
  ret = list("centers" = centers, "assignments" = factor(assignments), "K_hat" = K, "iterations" = iteration)
  return(ret)     
  }