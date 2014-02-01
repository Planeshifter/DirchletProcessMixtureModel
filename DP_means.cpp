#include <Rcpp.h>
#include <algorithm> 
#include <iterator>   
#include <iostream>     // std::cout

using namespace Rcpp;
using namespace std;

bool elem_in_vector(NumericVector labels, int k)
  {
  bool ret = false;  
  
  for (int i = 0; i < labels.size(); i++)
    {
    if (labels[i] == k) {ret = true;}; 
    }
  return ret;
  }
  
// -------------------------------------------------------------------

NumericVector subsetter(NumericVector input_vec, LogicalVector cond) {
  
    NumericVector res;
    
    for (int i = 1; i < input_vec.size(); i++)
      {
      if (cond[i] == TRUE) res.push_back(input_vec[i]);   
      }

    return res;    
}
// ----------------------------------------------------------------

// [[Rcpp::export]]
List dp_means(NumericVector x1, NumericVector x2, double lambda, int max_iterations = 50, double tolerance = 10e-3)
  {
  int K = 1; // set number of clusters k equal to one
   
  int n_obs = x1.size();
  NumericVector mu_x1(1);
  mu_x1[0] = mean(x1);
  
  NumericVector mu_x2(1);
  mu_x2[0] = mean(x2);
  
  NumericVector labels(n_obs);

  int iteration = 0;
  bool converged = FALSE;
  
  double wcss_old = 1.0/0.0;
  double wcss_new = 1.0/0.0;

  while (!converged && iteration < max_iterations)
  {
  iteration = iteration + 1;
    
    for(int i = 0; i < n_obs; i++)
      {
        
      NumericVector squared_distances(K, NA_REAL);
      
      for (int k = 0; k < K; k++)
        {
        double x1_dist = x1[i] - mu_x1[k];
        double x2_dist = x2[i] - mu_x2[k];
        squared_distances[k] = pow(x1_dist, 2) + pow(x2_dist, 2); // compute squared Euclidean distance 
        }

      NumericVector::iterator it = min_element(squared_distances.begin(), squared_distances.end());
      double min_Value = *it;
      if (min_Value > lambda) 
       {
          K++;
          labels[i] = K - 1;
          mu_x1.push_back(x1[i]);
          mu_x2.push_back(x2[i]);
       }
      else
        {
        labels[i] = it - squared_distances.begin(); 
        }
        
      for (int k = 0; k < K; k++)
        {
        if (elem_in_vector(labels, k))
          {
          LogicalVector match(labels==k);
          NumericVector x1_k = subsetter(x1, match);
          NumericVector x2_k = subsetter(x2, match);
          mu_x1[k] = mean(x1_k);
          mu_x2[k] = mean(x2_k);
          }
        }

      }
      
    wcss_new = 0;
  
    for (int i = 0; i < n_obs; i++)
      {
        double cluster = labels[i];
        double x1_cluster_mean = mu_x1[cluster];
        double x2_cluster_mean = mu_x2[cluster];
        wcss_new = wcss_new + pow(x1[i] - x1_cluster_mean, 2) + pow(x2[i] - x2_cluster_mean, 2);
      }
    
    double wcss_change = wcss_old - wcss_new;
    wcss_old = wcss_new;
    
    if (wcss_change < tolerance)
      {
        converged = TRUE;
      }
    }

  List ret = List::create(Named("mu_x1") = mu_x1, Named("mu_x2") = mu_x2, Named("K")=K, Named("labels") = labels,
  Named("iterations") = iteration);
  return ret;
  }
