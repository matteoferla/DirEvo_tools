#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxniter 100000
#define maxn 2000
#define maxl 1000000
#define maxpos 12
#define maxndaugh 4096   // pow(2,maxpos)

/*
DRIVeR: Diversity Resulting from In Vitro Recombination (Monte Carlo mode)

Copyright (C) by Andrew Firth and Wayne Patrick, March 2005

As for driver.cxx except it does a full Monte Carlo simulation.  Useful for 
 checking the analytic calculations used in driver.cxx, but due to CPU 
 constraints etc the max sequence length is maxn, and max number of variable 
 codons is maxpos.  Otherwise use driver.cxx.
*/

int main(int argc, char* argv[])
{

  if (8 != argc) {
    cout << "Usage '" << argv[0] << " library_size sequence_length "
	 << "mean_number_of_crossovers_per_sequence "
	 << "list_of_variable_positions_file random_seed "
	 << "nsims use_approx_method_flag'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  int N, L, M, A[maxpos], niter, n1, i, x1, k, pois, seq[maxn], s1, j, j1;
  int variants[maxndaugh], bin[maxpos-1], var, bin2, distinct[maxniter], seed;
  int approx, nseqs;
  double lambda, lN, ymax, xmax, sum, y1, Mm1, yfac[maxn], ssm, ssq, num;
  double r1, r2, stddev;

  L = int(atof(argv[1]));
  N = int(atof(argv[2]));
  lambda = atof(argv[3]);
  seed = int(atof(argv[5]));
  niter = int(atof(argv[6]));
  approx = atoi(argv[7]);

  if (approx) {
    cout << "Using approximate method.\n";
  } else {
    cout << "Not using approximate method.\n";
  }

  if (L < 1) {
    cerr << "Error: Library size must be positive integer.  "
	 << "You entered " << L << ".\n";
    exit(EXIT_FAILURE);
  }
  if (N < 1) {
    cerr << "Error: Sequence length must be positive integer.  "
	 << "You entered " << N << ".\n";
    exit(EXIT_FAILURE);
  }
  if (niter < 1) {
    cerr << "Error: Number of simulations must be positive integer.  "
	 << "You entered " << niter << ".\n";
    exit(EXIT_FAILURE);
  }
  if (lambda < 0) {
    cerr << "Error: Mean number of crossovers can't be negative.  "
	 << "You entered " << lambda << ".\n";
    exit(EXIT_FAILURE);
  }
  if (N > maxn) {
    cerr << "Error: Maximum sequence length is " << maxn << ".  "
	 << "You entered " << N << ".\n";
    exit(EXIT_FAILURE);
  }
  if (L > maxl) {
    cerr << "Error: Maximum library size is " << maxl << ".  "
	 << "You entered " << L << ".\n";
    exit(EXIT_FAILURE);
  }
  if (niter > maxniter) {
    cerr << "Error: Maximum number of simulations is " << maxniter << ".  "
	 << "You entered " << niter << ".\n";
    exit(EXIT_FAILURE);
  }

  // Check random seed.
  if (seed < 0) {
    seed = -seed;             
  }
  if (0 == seed) {
    seed = 1;             
  }
  srand(seed);

  // Read in variable positions.  (Must be in numerical order.)
  ifstream infile(argv[4]);
  if (!infile) {
    cout << "Failed to open file '" << argv[4] << "'.\n";
    exit(EXIT_FAILURE);
  }
  infile >> M;
  Mm1 = float(M);
  nseqs = int(pow(2.,Mm1));
  if (M > maxpos) {
    cout << "Error: Maximum number of variable positions is " << maxpos 
	 << ".  You entered " << M << ".\n"; 
    exit(EXIT_FAILURE);
  }
  infile.ignore(1000,'\n');
  for (i = 0; i < M; ++i) {
    infile >> A[i];
    if (A[i] > N) {
      cout << "Error: Variable position " << A[i] 
	   << " is greater than sequence length " << N << ".\n"; 
      exit(EXIT_FAILURE);
    }
    if (i > 0 && A[i] <= A[i-1]) {
      cout << "Error: Variable positions must be in numerical order.\n"; 
      exit(EXIT_FAILURE);
    }
    infile.ignore(1000,'\n');
  }
  infile.close();

  if (!approx && lambda > 0.75 * float(N-M-1)) {
    cout << "Error: Maximum mean number of crossovers is 0.75 * sequence "
	 << "length = " << 0.75 * float(N-M-1) << ".\n  "
	 << "You entered " << lambda << ".\n";
    exit(EXIT_FAILURE);
  }
  if (approx && lambda > 0.5 * float(N-M-1)) {
    cerr << "Error: Maximum mean number of crossovers for approximate "
	 << "method is\n  0.5 * sequence length = " << 0.5 * float(N-M-1) 
	 << ".  " << "You entered " << lambda << ".\n  "
	 << "Try the non-approximate method.\n";
    exit(EXIT_FAILURE);
  }
  if (approx && lambda > 0.1 * float(N-M-1)) {
    cout << "Warning: Mean number of crossovers is greater than 0.1 * "
	 << "sequence length = " << 0.1 * float(N-M-1) << ".\n  "
	 << "Maybe you shouldn't use the approximate method.\n";
  }

  ofstream outfile("mc.dat");
  if (!outfile) {
    cerr << "Failed to open file 'mc.dat'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);

  if (approx) {      
    // Define boundary box for Poisson Monte Carlo simulation
    //   maximum y occurs at x=int(lambda) or x=int(lambda)+1
    //   choose maximum x to encompass at least 99% of the total probability
    n1 = int(lambda);
    ymax = exp(-lambda);
    for (i = 1; i <= n1; ++i) {
      ymax *= lambda;
      ymax /= float(i);
    }
    if (ymax < (ymax * lambda / float(n1+1))) {
      ymax *= lambda / float(n1+1);
    }
    n1 = 0;
    yfac[0] = exp(-lambda);
    sum = yfac[0];
    while (sum < 0.99) {
      n1 += 1;
      yfac[n1] = yfac[n1-1] * lambda / float(n1);
      sum += yfac[n1];
    }
    xmax = float(n1);
    cout << "Montecarlo bounding box on Poisson distribution:\n"
	 << "  lambda = " << lambda << ", "
	 << "  ymax = " << ymax << ", "
	 << "  xmax = " << xmax << ", "
	 << "  sum = " << sum << ".\n";
  } else {
    lN = lambda / float(N-M-1);
  }
  
  for (k = 0; k < niter; ++k) {  // step through simulated libraries.
    for (j = 0; j < maxndaugh; ++j) {
      variants[j] = 0;
    }
    for (i = 0; i < L; ++i) {  // for each library randomly produce L sequences
      for (j = 0; j < maxn; ++j) {
	seq[j] = 0;
      }
      // Label variable positions.
      for (j = 0; j < M; ++j) {
	seq[A[j]] = 9;
	}

      if (approx) {
	// First use Poisson lambda to chose number of crossovers
	pois = 0;
	while (0 == pois) {
	  r1 = float(rand())/float(RAND_MAX);
	  r2 = float(rand())/float(RAND_MAX);
	  x1 = int(r1*(xmax+1.));
	  y1 = r2 * ymax;
	  if (y1 < yfac[x1]) {
	    pois = 1;
	  }
	}
	// Exits do loop with x1 being a random Poisson variable 

	// Randomly pick the positions of the x1 crossovers
	for (j = 0; j < x1; ) {
	  r1 = float(rand())/float(RAND_MAX);
	  s1=int(float(N-1)*r1); // random integer from 0 to N-1
	  if (0 == seq[s1]) {
	    seq[s1] = 1; // crossover
	    j++;
	  }
	}
	for (j = 0; j < maxn; ++j) {
	  if (9 == seq[j]) {
	    seq[j] = 0;
	  }
	}


      } else { // not using approx method
	// Go through sequence.  At each space between base-pairs there is a 
	//   lambda/N probability of a crossover.  No crossovers allowed
	//   at variable positions (seq[j] = 9).
	for (j = 0; j < N-1; ++j) {
	  if (9 != seq[j]) { 
	    r1 = float(rand())/float(RAND_MAX);
	    if (r1 > lN) {
	      seq[j] = 0;
	    } else {
	      seq[j] = 1;
	    }
	  } else {
	    seq[j] = 0;
	  }
	}
      } // end choice of approx/non-approx methods

      // Identify the daughter sequence by a binary sequence
      for (j = 0; j < M-1; ++j) {
	bin[j] = 0; // binary code for daughter sequence
	// Count spaces between variable positions
	for (j1 = A[j]; j1 < A[j+1]; ++j1) {
	  if(1 == seq[j1]) { // crossover
	    if (0 == bin[j]) {
	      bin[j] = 1; // odd number of crossovers in interval
	    } else {
	      bin[j] = 0; // even number of crossovers in interval
	    }
	  }
	}
      }
      // Exits loop with bin[j] = binary code for daughter sequence

      // Convert binary sequence to integer in range 1,2,...,2^M and add to 
      //   counter in variants[]
      var = 0;
      bin2 = 1;
      for (j = 0; j < M-1; ++j) {
	if (1 == bin[j]) {
	  var += bin2;
	}
	bin2 *= 2;
      }

      // So far we have not distinguished a sequence from it's inverse but we 
      //   need to do that now   
      r1 = float(rand())/float(RAND_MAX);
      if (r1 > 0.5) {
	var += nseqs / 2;
      }
      variants[var] += 1;

    }  // end loop over L sequences in library

    // Find total number of distinct sequences in the library
    distinct[k] = 0;
    for (j = 0; j < nseqs; ++j) {
      if (variants[j] > 0) {
	distinct[k] += 1;
      }
    }

  } // end loop over niter simulated libraries

  // Output variant, N(variant) data for the final iteration
  for (j = 0; j < nseqs; ++j) {
    outfile << j << " " << variants[j] << "\n";
  }
  outfile.close();

  // Output mean and standard deviation of the number of distinct sequences 
  //   over all the iterations
  ssm = 0.;
  ssq = 0.;
  num = float(niter);
  for (k = 0; k < niter; ++k) {
    ssm += float(distinct[k]);
    ssq += float(distinct[k]) * float(distinct[k]);
  }
  cout << "Number of iterations = " << niter << ".\n";
  cout << "Mean number of distinct daughter sequences = " << ssm/num << ".\n";
  if (((num/(num-1.))*((ssq/num)-(ssm/num)*(ssm/num))) > 0.) {
    stddev = sqrt((num/(num-1.))*((ssq/num)-(ssm/num)*(ssm/num)));
  } else {
    stddev = 0.;
  }
  cout << "Standard deviation = " << stddev << ".\n"; 

}
