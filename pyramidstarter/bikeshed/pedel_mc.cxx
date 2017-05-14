#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxn 1000
#define maxl 100000
#define nhist 100

/*
Copyright (C) Andrew Firth and Wayne Patrick, March 2005

Programme to calculate the expected number of distinct sequences in an epPCR
  library using Monte Carlo simulations.

Asks for sequence length N, library size L, and mutation rate lambda.
Calculates expected number of distinct sequences in the library.
*/

int main(int argc, char* argv[])
{

  if (7 != argc) {
    cerr << "Usage '" << argv[0] << " library_size sequence_length "
	 << "mean_number_of_mutations_per_sequence random_seed "
	 << "use_approx_method_flag verbose_flag'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  double lambda, lN, ifac, r1, r2, sum, xmax, ymax, y1, yfac[maxn];
  int N, i, L, k, count[maxl], hist[nhist], seed, seq[maxn], s1, s2, pois;
  int x1, n1, approx, verbose;

  L = int(atof(argv[1]));
  N = int(atof(argv[2]));
  lambda = atof(argv[3]);
  seed = int(atof(argv[4]));
  approx = atoi(argv[5]);
  verbose = atoi(argv[6]);

  if (verbose) {
    if (approx) {
      cout << "Using approximate method.\n";
    } else {
      cout << "Not using approximate method.\n";
    }
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
  if (lambda < 0) {
    cerr << "Error: Mean number of mutations can't be negative.  "
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
  if (lambda > 0.75 * float(N)) {
    cerr << "Error: Maximum mutation rate is 0.75 * sequence length = " 
	 << 0.75 * float(N) << ".  "
	 << "You entered " << lambda << ".\n";
    exit(EXIT_FAILURE);
  }
  if (approx && lambda > 0.5 * float(N)) {
    cerr << "Error: Maximum mutation rate for approximate method is\n  "
	 << "0.5 * sequence length = " << 0.5 * float(N) << ".  "
	 << "You entered " << lambda << ".\n  "
	 << "Try the non-approximate method.\n";
    exit(EXIT_FAILURE);
  }
  if (verbose && approx && lambda > 0.1 * float(N)) {
    cout << "Warning: Mutation rate is greater than 0.1 * sequence length = "
	 << 0.1 * float(N) << ".\n  "
	 << "Maybe you shouldn't use the approximate method.\n";
  }

  // Check random seed.
  if (seed < 0) {
    seed = -seed;             
  }
  if (0 == seed) {
    seed = 1;             
  }
  srand(seed);

  for (i = 0; i < nhist; ++i) {
    hist[i] = 0;
  }

  ofstream outfile("mc.dat");
  if (!outfile) {
    cerr << "Failed to open file 'mc.dat'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);
  
  if (approx) {
    // Define boundary box for Poisson Monte Carlo simulation.
    //   Maximum y occurs at x=int(lambda) or x=int(lambda)+1.
    //   Choose maximum x to encompass at least 99% of the total probability.
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
    if (verbose) {
      cout << "Montecarlo bounding box on Poisson distribution:\n"
	   << "  lambda = " << lambda << ", "
	   << "  ymax = " << ymax << ", "
	   << "  xmax = " << xmax << ", "
	   << "  sum = " << sum << ".\n";
    }

    // Generate sample of L sequences
    for (k = 0; k < L; ++k) {
      // First use Poisson lambda to chose number of point mutations
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

      // Randomly pick the positions and type of the point mutations
      for (i = 0; i < N; ++i) {
	seq[i] = 0;
      }
      for (i = 0; i < x1; ) {
	r1 = float(rand())/float(RAND_MAX);
	s1 = int(float(N)*r1); // random integer from 0 to N-1
	r2 = float(rand())/float(RAND_MAX);
	s2 = int(3.*r2+1.);    // random integer from 1 to 3
	if (0 == seq[s1]) {
	  seq[s1] = s2;        // doesn't allow multiple muts at same site
	  i++;
	}
      }
      count[k] = x1;

      outfile << count[k] << " ";
      for (i = 0; i < N; ++i) {
	outfile << seq[i];
      }
      outfile << "\n";
      if (count[k] < nhist) {
	hist[count[k]] += 1;
      }
    }

  } else {
    
    lN = lambda / float(N);
    
    // Generate sample of L sequences
    for (k = 0; k < L; ++k) {
      count[k] = 0;
      // Go through sequence - each base-pair has a lN = lambda/N probability 
      //   of mutating 0 -> 1, 2 or 3
      for (i = 0; i < N; ++i) {
	r1 = float(rand())/float(RAND_MAX);
	if (r1 > lN) {
	  seq[i] = 0;
	} else {
	  r2 = float(rand())/float(RAND_MAX);
	  s2 = int(3.*r2+1);
	  seq[i] = s2;
	  count[k] += 1;
	}
      }
      outfile << count[k] << " ";
      for (i = 0; i < N; ++i) {
	outfile << seq[i];
      }
      outfile << "\n";
      if (count[k] < nhist) {
	hist[count[k]] += 1;
      }
    }
    
  }

  outfile.close();

  // Write normalized histogram.
  if (verbose) {
    ofstream histfile("hist.dat");
    if (!histfile) {
      cerr << "Failed to open file 'hist.dat'.\n";
      exit(EXIT_FAILURE);
    }
    histfile << setprecision(4);
    ifac = exp(-lambda);
    histfile << 0 << " " << hist[0]/float(L) << " " << ifac << "\n";
    for (i = 1; i < nhist; ++i) {
      ifac *= lambda / float(i);
      histfile << i << " " << hist[i]/float(L) << " " << ifac << "\n";
    }
    histfile.close();
  }

}
