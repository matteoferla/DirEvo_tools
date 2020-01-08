#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxvar 10000000        // 10^7
#define maxnsims 100000        // 10^5
#define maxnlibrary 100000000  // 10^8

/*
Copyright (C) Andrew Firth and Wayne Patrick, March 2005

A MonteCarlo simulation for finding the completeness of a library where
  each sequence is chosen at random from a set of equiprobable variants.
*/

int main(int argc, char* argv[])
{

  if (5 != argc) {
    cerr << "Usage '" << argv[0] << " nvariants library_size nsims seed'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  int variants[maxvar], nzero[maxnsims], i, k, nsamples, nvariants, nsims;
  int seed;
  double histogram[100], sample, sum, ssq, csum, num, ifac, lambda, stddev;

  nvariants = int(atof(argv[1]));
  nsamples = int(atof(argv[2]));
  nsims = int(atof(argv[3]));
  seed = int(atof(argv[4]));

  if (nvariants < 1) {
    cerr << "Error: Number of variants must be positive integer.  "
         << "You entered " << nvariants << ".\n";
    exit(EXIT_FAILURE);
  }
  if (nsamples < 1) {
    cerr << "Error: Library size must be positive integer.  "
         << "You entered " << nsamples << ".\n";
    exit(EXIT_FAILURE);
  }
  if (nsims < 1) {
    cerr << "Error: Number of simulations must be positive integer.  "
         << "You entered " << nsims << ".\n";
    exit(EXIT_FAILURE);
  }
  if (nvariants > maxvar) {
    cerr << "Error: Maximum number of variants " << maxvar << ".  "
         << "You entered " << nvariants << ".\n";
    exit(EXIT_FAILURE);
  }
  if (nsamples > maxnlibrary) {
    cerr << "Error: Maximum library size " << maxnlibrary << ".  "
         << "You entered " << nsamples << ".\n";
    exit(EXIT_FAILURE);
  }
  if (nsims > maxnsims) {
    cerr << "Error: Maximum number of simulations " << maxnsims << ".  "
         << "You entered " << nsims << ".\n";
    exit(EXIT_FAILURE);
  }
  if (seed < 0) {
    seed = -seed;             
  }
  if (0 == seed) {
    seed = 1;             
  }
  srand(seed);

  for (i = 0; i < 100; ++i) {
    histogram[i] = 0;
  }
  for (i = 0; i < nsims; ++i) {
    nzero[i] = 0;
  }

  // Cycle through trials
  for (k = 0; k < nsims; ++k) {
    for (i = 0; i < nvariants; ++i) {
      variants[i] = 0;
    }
    for (i = 0; i < nsamples; ++i) {
      sample = float(rand())/float(RAND_MAX);
      variants[int(sample*nvariants)] += 1;
    }
    // Histogram of the number of times each variant occurs in the sample.
    //   histogram[0] = number of variants which occur 0 times
    //   histogram[1] = number of variants which occur 1 time   etc.
    //   Expected to follow Poisson distribution.
    for (i = 0; i < nvariants; ++i) {
      if (variants[i] < 100) {
	histogram[variants[i]] += 1;   
      }
    }
    // Count how many variants are not present.
    for (i = 0; i < nvariants; ++i) {
      if (0 == variants[i]) {
	nzero[k] += 1;
      }
    }
  }

  // Write normalized histogram.
  ofstream outfile("histogram.dat");
  if (!outfile) {
    cerr << "Failed to open file 'histogram.dat'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);
  ifac = 1.;
  lambda = float(nsamples)/float(nvariants);
  outfile << 0 << " " << float(histogram[0]) / float(nvariants*nsims) << " " 
	  << exp(-lambda) << "\n";
  for (i = 1; i < 100; ++i) {
    ifac *= lambda / float(i);
    outfile << i << " " << float(histogram[i]) / float(nvariants*nsims) << " " 
	    << exp(-lambda) * ifac << "\n";
  }
  outfile.close();
     
  // Calculate mean completeness, standard deviation and fraction of 
  //   samples that are 100% complete
  sum = 0.;
  ssq = 0.;
  csum = 0.;
  num = float(nsims);
  for (k = 0; k < nsims; ++k) {
    sum += float(nzero[k]);
    ssq += float(nzero[k]) * float(nzero[k]);
    if (0 == nzero[k]) {
      csum += 1.;
    }
  }
  sum /= float(nvariants);
  ssq /= (float(nvariants)*float(nvariants));
  cout << "Mean completeness of samples = " << 1.-sum/num << ".\n";
  if (((num/(num-1.))*((ssq/num)-(sum/num)*(sum/num))) > 0.) {
    stddev = sqrt((num/(num-1.))*((ssq/num)-(sum/num)*(sum/num)));
  } else {
    stddev = 0.;
  }
  cout << "Standard deviation = " << stddev << ".\n"; 
  cout << "Proportion of samples containing all variants = " << csum/num 
       << ".\n";

}
