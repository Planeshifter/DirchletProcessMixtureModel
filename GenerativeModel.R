generate_clustered_obs = function(K, n, alpha0, Sigma, rho)
{
require(MCMCpack)
g = rdirichlet(1, rep(alpha0,times=K))
theta = matrix(data=0, nrow=K, ncol=2)

for (k in 1:K)
  {
  theta[k,] = mvrnorm(1, mu=c(0,0), Sigma = rho*diag(2)) 
  }

z = rep(0, times=n)
x = matrix(0, nrow=n, ncol=2)

for (i in 1:n)
  {
  z[i] = which(rmultinom(1, size=1, prob=g) == 1)
  x[i,] = mvrnorm(1, mu=theta[z[i],], Sigma = Sigma)  
  }

df = data.frame(x1=x[,1],x2=x[,2], z=as.factor(z))
return(df)
}
