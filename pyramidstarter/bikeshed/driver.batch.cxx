#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxpos 15
#define maxndaugh 16384   // pow(2,maxpos-1)
#define nlibsteps 5
#define nlambdasteps 50
#define maxn 100000000      // 10^8
#define maxl 1000000000000. // 10^12

/*
DRIVeR: Diversity Resulting from In Vitro Recombination (batch mode)

Copyright (C) by Andrew Firth and Wayne Patrick, March 2005

Calculates expected number of variants for a grid of library sizes (from 0.06
  to 32 times the input library size in 2*nlibsteps steps) and lambda values 
  (from 0.03 to 32 times the input lambda value in 2*nlambdasteps steps)

Outputs to file batch.dat: rows correspond to different lambda values, 
  columns corresponds to different library sizes

Input lambda can be the true underlying crossover rate (xtrue = 1) or the
  mean number of observable crossovers (xtrue = 0).
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

  int i, k, N, M, A[maxpos], nn[maxpos], j1, j2, nseqs, xtrue, iter, maxiter;
  int Meff;
  double lambda, Pb0[maxpos], Pb1[maxpos], lnn[maxpos], L, lambda0, L0, Mm1;
  double Xk2sum[2*nlibsteps][2*nlambdasteps], Xk2[maxndaugh];
  double lobs[2*nlibsteps][2*nlambdasteps], PBk[maxndaugh], lobsin;
  double lambda1, lambda2, lambdam, lobs1, lobs2, lobsm, diff, tolerance;
  char file2[100];

  L0 = atof(argv[1]);
  N = int(atof(argv[2]));
  lambda0 = atof(argv[3]);
  xtrue = atoi(argv[6]);
  tolerance = 0.001;
  maxiter = 200;

  if (L0 <= 0) {
    cout << "Error: Library size must be positive.  "
	 << "You entered " << L0 << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (N < 1) {
    cout << "Error: Sequence length must be positive integer.  "
	 << "You entered " << N << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (lambda0 <= 0) {
    cout << "Error: Mean number of crossovers must be positive.  "
	 << "You entered " << lambda0 << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (N > maxn) {
    cout << "Error: Maximum sequence length is " << maxn << ".  "
	 << "You entered " << N << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (L0 > maxl) {
    cout << "Error: Maximum library size is " << maxl << ".  "
	 << "You entered " << L0 << ".<br>\n";
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
    if (lambda0 > float(N-M-1)) {
      cout << "Error: Mean number of crossovers can't exceed "
	   << "'sequence length - number of variable positions - 1'.  "
	   << "You entered " << lambda0 << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (lambda0 > 0.1 * float(N-M-1)) {
      cout << "Warning: Crossover rate is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
  }

  if (!xtrue) { // Need to calculate true crossover rate
    if (lambda0 > float(Meff-1)/2) {
      cout << "Error: Mean number of <i>observable</i> crossovers can't "
	   << "exceed '0.5 x (number of non-adjacent variable positions - 1)' "
	   << "= " << float(Meff-1)/2 << ".  " << "You entered " << lambda0
	   << ".  Did you mean to choose the 'all crossovers' option?<br>\n";
      exit(EXIT_FAILURE);
    }
    iter = 0;
    lobsin = lambda0;
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
    lambda0 = lambda2;

    if (lambda0 > 0.1 * float(N-M-1)) {
      cout << "Warning: Crossover rate is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
  }

  for (j1 = 0; j1 < 2*nlibsteps; ++j1) {  // grid of library sizes
    L = L0 * pow(2.,(j1-nlibsteps));
    for (j2 = 0; j2 < 2*nlambdasteps; ++j2) {  // grid of lambda values
      lambda = lambda0 * pow(10.,(float(j2-nlambdasteps)*0.03));
      if (lambda > float(N-M-1)) {
	break;
      }
      lobs[j1][j2] = calcprob(lambda, N, M, nn, A, lnn, Pb0, Pb1, nseqs, PBk);
      Xk2sum[j1][j2] = 0.;
      for (k = 0; k < nseqs; ++k) {
	Xk2[k] = 1. - pow((1.-(PBk[k]*0.5)),L);
	Xk2sum[j1][j2] += Xk2[k];
      }
      Xk2sum[j1][j2] *= 2.;
    }
  }

  ofstream outfile(argv[5]);
  if (!outfile) {
    cerr << "Failed to open file '" << argv[5] << "'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);
  strcpy(file2,argv[5]);
  strcat(file2,"2");
  ofstream outfile2(file2);
  if (!outfile2) {
    cerr << "Failed to open file '" << file2 << "'.\n";
    exit(EXIT_FAILURE);
  }
  outfile2 << setprecision(4);
  outfile << "Columns = different library sizes.<br>\n"
	  << "Rows = different mean number of crossovers per sequence.<br>\n"
	  << "<br>\n";
  outfile << "<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\">\n";
  outfile << "<tr><td></td><td></td><th align=\"center\" colspan=\"" 
	  << 2*nlibsteps << "\">Expected number of distinct sequences for "
	  << "different library sizes</th></tr>\n" ;
  outfile << "<tr><th align=\"center\">true mean number of crossovers per "
	  << "sequence</th>\n"
	  << "<th align=\"center\">observed mean number of crossovers per "
	  << "sequence</th>\n";
  for (j1 = 0; j1 < 2*nlibsteps; ++j1) {
    outfile << "<th align=\"center\">" 
	    << L0 * pow(2.,(j1-nlibsteps)) << "</th>";
  }
  outfile << "</tr>\n";
  for (j2 = 0; j2 < 2*nlambdasteps; ++j2) {
    lambda = lambda0 * pow(10.,(float(j2-nlambdasteps)*0.03));
    if (lambda > float(N-M-1)) {
      break;
    }
    outfile << "<tr align=\"right\"><td>" << lambda << "</td><td>" 
	    << lobs[0][j2];
    outfile2 << lambda << " " << lobs[0][j2];
    for (j1 = 0; j1 < 2*nlibsteps; ++j1) {
      outfile << "</td><td>" << Xk2sum[j1][j2];
      outfile2 << " " << Xk2sum[j1][j2];
    }
    outfile << "</td></tr>\n";
    outfile2 << "\n";
  }
  outfile << "</table><br>\n";
  outfile.close();
  outfile2.close();

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
