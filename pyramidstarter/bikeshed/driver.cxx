#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxpos 20
#define maxndaugh 524288    // pow(2,maxpos-1)
#define maxn 100000000      // 10^8
#define maxl 1000000000000. // 10^12

/*
DRIVeR: Diversity Resulting from In Vitro Recombination

Copyright (C) by Andrew Firth and Wayne Patrick, March 2005

Read in sequence length N, mean number of crossovers per sequence lambda, 
  library size L, and positions of variable base-pairs (codons) A[i], i=1,M.  
  Calculate the probabilities P(b_i=0), P(B_i=1) of there being an even or 
  odd number respectively of crossovers between consecutive variable 
  base-pairs A[i] and A[i+1].  Calculate the relative probabilities of each of 
  the 2^M possible daughter sequences and the probability that each 
  daughter sequence will be present in the library.  Sum these probabilities to
  find the expected number of distinct sequences in the library.  

Input lambda can be the true underlying crossover rate (xtrue = 1) or the
  mean number of observable crossovers (xtrue = 0).

Also outputs file driver.dat (probability for each daughter sequence)

Also outputs the observed lambda for a given input true lambda.  The user 
  should try different input lambda values until the known observed lambda is
  reproduced.
*/

// Function declarations
double calcprob(double lambda, int N, int M, int nn[maxpos], int A[maxpos], 
		double lnn[maxpos], double Pb0[maxpos], double Pb1[maxpos], 
		int nseqs, double PBk[maxndaugh]);

int main(int argc, char* argv[])
{

  if (7 != argc) {
    cout << "Usage '" << argv[0] << " library_size sequence_length "
	 << "mean_number_of_crossovers_per_sequence "
	 << "list_of_variable_positions_file outfile xtrue'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  int i, k, N, M, A[maxpos], nn[maxpos], nseqs, xtrue, iter, maxiter;
  int Meff;
  double lambda, Pb0[maxpos], Pb1[maxpos], lnn[maxpos], lobs, L, Mm1, lobsin;
  double PBk[maxndaugh], Xk[maxndaugh], Xk2[maxndaugh], Xksum, Xk2sum;
  double lambda1, lambda2, lambdam, lobs1, lobs2, lobsm, diff, tolerance;

  L = atof(argv[1]);
  N = int(atof(argv[2]));
  lambda = atof(argv[3]);
  xtrue = atoi(argv[6]);
  tolerance = 0.001;
  maxiter = 200;

  if (L < 0) {
    cout << "Error: Library size can't be negative.  "
	 << "You entered " << L << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (N < 1) {
    cout << "Error: Sequence length must be positive integer.  "
	 << "You entered " << N << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (lambda <= 0) {
    cout << "Error: Mean number of crossovers must be positive.  "
	 << "You entered " << lambda << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (N > maxn) {
    cout << "Error: Maximum sequence length is " << maxn << ".  "
	 << "You entered " << N << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (L > maxl) {
    cout << "Error: Maximum library size is " << maxl << ".  "
	 << "You entered " << L << ".<br>\n";
    exit(EXIT_FAILURE);
  }

  // Read in variable positions.  (Must be in numerical order.)
  ifstream infile(argv[4]);
  if (!infile) {
    cout << "Failed to open file '" << argv[4] << "'.\n";
    exit(EXIT_FAILURE);
  }
  infile >> M;
  Meff = M;
  Mm1 = float(M-1);
  nseqs = int(pow(2.,Mm1));
  if (M > maxpos) {
    cout << "Error: Maximum number of variable positions is " << maxpos 
	 << ".  You entered " << M << ".<br>\n"; 
    exit(EXIT_FAILURE);
  }
  if (M < 1) {
    cout << "Error: You didn't enter any variable positions.<br>\n"; 
    exit(EXIT_FAILURE);
  }
  infile.ignore(1000,'\n');
  for (i = 0; i < M; ++i) {
    infile >> A[i];
    if (A[i] > N) {
      cout << "Error: Variable position " << A[i] 
	   << " is greater than sequence length " << N << ".<br>\n"; 
      exit(EXIT_FAILURE);
    }
    if (i > 0 && A[i] <= A[i-1]) {
      cout << "Error: Variable positions must be in numerical order.<br>\n"; 
      exit(EXIT_FAILURE);
    }
    if (i > 0 && A[i] == A[i-1]+1) { // Adjacent variable positions
      Meff -= 1;
      cout << "Warning: Variable positions " << A[i-1] << " and " << A[i]
	   << " are adjacent.  They will be linked in all daughter "
	   << "sequences.<br>\n";
    }
    infile.ignore(1000,'\n');
  }
  infile.close();

  if (xtrue) {
    if (lambda > float(N-M-1)) {
      cout << "Error: Mean number of crossovers can't exceed "
	   << "'sequence length - number of variable positions - 1' = "
	   << N-M-1 << ".  " << "You entered " << lambda << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (lambda > 0.1 * float(N-M-1)) {
      cout << "Warning: Crossover rate is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
  }

  if (!xtrue) { // Need to calculate true crossover rate
    if (lambda > float(Meff-1)/2) {
      cout << "Error: Mean number of <i>observable</i> crossovers can't "
	   << "exceed '0.5 x (number of non-adjacent variable positions - 1)' "
	   << "= " << float(Meff-1)/2 << ".  " << "You entered " << lambda
	   << ".  Did you mean to choose the 'all crossovers' option?<br>\n";
      exit(EXIT_FAILURE);
    }
    iter = 0;
    lobsin = lambda;
    lambda1 = 0;
    lambda2 = float(N-M-1);
    lobs1 = calcprob(lambda1, N, M, nn, A, lnn, Pb0, Pb1, nseqs, PBk);
    lobs2 = calcprob(lambda2, N, M, nn, A, lnn, Pb0, Pb1, nseqs, PBk);
    diff = (lobsin-lobs2)/lobsin;
    while (abs(diff) > tolerance) {
      if (iter > maxiter) {
	cout << "Error: failed to converge on true crossover rate in " 
	     << maxiter << " iterations.<br>\n";
	exit(EXIT_FAILURE);
      }
      iter += 1;
      lambdam = 0.5*(lambda1+lambda2);
      lobsm = calcprob(lambdam, N, M, nn, A, lnn, Pb0, Pb1, nseqs, PBk);
      if (lobsm > lobsin) {
	lobs2 = lobsm;
	lambda2 = lambdam;
      } else {
	lobs1 = lobsm;
	lambda1 = lambdam;
      }
      diff = (lobsin-lobs2)/lobsin;
    }
    lambda = lambda2;

    if (lambda > 0.1 * float(N-M-1)) {
      cout << "Warning: Crossover rate is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
  }

  ofstream outfile(argv[5]);
  if (!outfile) {
    cout << "Failed to open file '" << argv[5] << "'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);
  outfile << "<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\"><tr>\n"
	  << "<th align=\"center\">coordinates of interval</th>\n"
	  << "<th align=\"center\">number of nt</th>\n"
	  << "<th align=\"center\">mean number of crossovers</th>\n"
	  << "<th align=\"center\">P(even number of crossovers)</th>\n"
	  << "<th align=\"center\">P(odd number of crossovers)</th></tr>\n";

  lobs = calcprob(lambda, N, M, nn, A, lnn, Pb0, Pb1, nseqs, PBk);

  for (i = 0; i < M-1; ++i) {
    outfile << "<tr align=\"right\"><td>" << A[i] << "--" << A[i+1] 
	    << "</td><td>" << nn[i] << "</td><td>" << lnn[i]
	    << "</td><td>" << Pb0[i] << "</td><td>" << Pb1[i] 
	    << "</td></tr>\n";
  }
  outfile << "</table><br>\n";
  outfile.close();

  // Calculate expected number of variants in library
  Xksum = 0.;
  Xk2sum = 0.;
  for (k = 0; k < nseqs; ++k) {
    // using approximation
    Xk[k] = 1. - exp(-L*(PBk[k]*0.5));
    // no approximation
    Xk2[k] = 1. - pow((1.-(PBk[k]*0.5)),L);
    Xksum += Xk[k];
    Xk2sum += Xk2[k];
  }
  // Times 2 to get full number of daughter sequences
  Xksum *= 2.;
  Xk2sum *= 2.;

  //  cout << "Expected number of distinct sequences = " << Xksum 
  //       << " (approx), " << Xk2sum << " (no approx).<br>\n";
  cout << "Total number of possible sequences = " << 2 * nseqs << ".<br>\n";
  cout << "Expected number of distinct sequences = " << Xk2sum << ".<br>\n";
  cout << "Mean number of actual crossovers per sequence = " << lambda 
       << ".<br>\n";
  cout << "Mean number of observable crossovers per sequence = " << lobs
       << ".<br>\n";

}

double calcprob(double lambda, int N, int M, int nn[maxpos], int A[maxpos], 
		double lnn[maxpos], double Pb0[maxpos], double Pb1[maxpos], 
		int nseqs, double PBk[maxndaugh])

{  

  int i, k, sum, lct, b[maxpos];
  double lobs;
    
  // Calculate probabilities  P(b_i=0) and P(b_i=1) for an even or odd number 
  //   of crossovers between consecutive varying base-pairs A[i] and A[i+1].
  for (i = 0; i < M-1; ++i) {
    // number of allowed crossover points between A[i] and A[i+1]
    nn[i] = A[i+1] - A[i] - 1;
    // poisson lambda for the interval
    lnn[i] = float(nn[i]) * lambda / float(N-M-1);
    // P(even no. crossovers in interval)
    //    Pb0[i] = exp(-lnn[i]) * cosh(lnn[i]);
    Pb0[i] = 0.5*(1.+exp(-2.*lnn[i]));
    // P(odd no. crossovers in interval)
    //    Pb1[i] = exp(-lnn[i]) * sinh(lnn[i]);
    Pb1[i] = 0.5*(1.-exp(-2.*lnn[i]));
  }

  // Encode possible daughter sequences as binary sequences (1 = odd number of 
  //   crossovers, 0 = even number of crossovers) and calculate their 
  //   probabilities P(B_k).  By symmetry, we only need to calculate 
  //   probabilities for half 2^(M-1) of the possible daughter sequences.
  lobs = 0.;
  for (k = 0; k < nseqs; ++k) {
    lct = 0;
    sum = k + 1;
    PBk[k] = 1.;
    // M-1 binary digits
    for (i = 0; i < M-1; ++i) {
      // b[i] is the binary sequence
      b[i] = sum - 2 * int(sum/2);
      if (0 == b[i]) {
	// calculating probability
	PBk[k] *= Pb0[i];
      } else if (1 == b[i]) {
	// calculating probability
	PBk[k] *= Pb1[i];
	// count observable crossovers for lambda^obs
	lct += 1;
      } else {
	cout << "Error: Can't get here.<br>\n"; 
	exit(EXIT_FAILURE);
      }
      sum = (sum - b[i]) / 2;
    }
    // PBk[k]*0.5 since each binary sequence corresponds to two `inverse' 
    //   daughter sequences
    // Calculate lambda^obs - the mean number of _observable_ crossovers
    //   per sequence
    lobs += PBk[k] * float(lct);
  }

  return(lobs);

}
