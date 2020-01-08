#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxnsteps 100

/*
Copyright (C) Andrew Firth and Wayne Patrick, March 2005

PEDEL: Programme for Estimating Diversity in Error-prone PCR Libraries
  (batch mode)

Programme to calculate the expected number of distinct sequences in an epPCR
 library.

As for PEDEL.cxx but while two of sequence length N, library size L, and 
  mutation rate lambda are fixed, the expected number of distinct sequences
  in the library is calculated for a given range of the third parameter. 

Usage (3 running modes):
  PEDEL.batch 1 L N lambda_0 lambda_1 nsteps
  PEDEL.batch 2 lambda N L_0 L_1 nsteps
  PEDEL.batch 3 L lambda N_0 N_1 nsteps
*/

// Function declarations
double seqsum(double L, double N, double lambda);

int main(int argc, char* argv[])
{

  if (8 != argc) {
    cout << "Usage '" << argv[0] << " 1 L N lambda_0 lambda_1 nsteps outfile',\n"
	 << "   or '" << argv[0] << " 2 lambda N L_0 L_1 nsteps outfile',\n"
	 << "   or '" << argv[0] << " 3 L lambda N_0 N_1 nsteps outfile',\n"
	 << "where\n"
	 << "  L = library size,\n"
         << "  N = sequence length,\n"
         << "  lambda = mean number of point mutations per sequence,\n"
	 << "and _0 _1 give a range covered with nsteps steps.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  int i, mode, nsteps;
  double L, lambda, L0, L1, lambda0, lambda1, N, N0, N1, temp, step, csum;
  double param[4];

  mode = atoi(argv[1]);
  nsteps = int(atof(argv[6]));
  if (nsteps < 2) {
    cout << "Error: Number of steps must be >= 2.  "
	 << "You entered " << nsteps << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  if (nsteps > maxnsteps) {
    cout << "Error: Maximum number of steps = " << maxnsteps
	 << ".  You entered " << nsteps << ".<br>\n";
    exit(EXIT_FAILURE);
  }
  nsteps -= 1;
  for (i = 0; i < 4; ++i) {
    param[i] = atof(argv[i+2]);
  }
  if (param[3] < param[2]) {
    temp = param[2];
    param[2] = param[3];
    param[3] = temp;
  }

  ofstream outfile(argv[7]);
  if (!outfile) {
    cout << "Failed to open file '" << argv[7] << "'.\n";
    exit(EXIT_FAILURE);
  }
  outfile << setprecision(4);

  cout << "<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\"><tr>\n"
       << "<th align=\"center\">library size</th>\n"
       << "<th align=\"center\">sequence length (nt)</th>\n"
       << "<th align=\"center\">mean number of mutations per "
       << "sequence</th>\n"
       << "<th align=\"center\">expected number of distinct sequences "
       << "in library</th></tr>\n";

  if (1 == mode) {
    // PEDEL.batch 1 L N lambda_0 lambda_1 nsteps
    L = param[0];
    N = param[1];
    lambda0 = param[2];
    lambda1 = param[3];
    if (L < 0.) {
      cout << "Error: Library size can't be negative.  "
	   << "You entered " << L << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (L < 10.) {
      cout << "Warning: Library size very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (N < 1.) {
      cout << "Error: Sequence length must be positive integer.  "
	   << "You entered " << N << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (N < 5.) {
      cout << "Warning: Sequence length very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (lambda0 < 0.) {
      cout << "Error: Mean number of mutations can't be negative.  "
	   << "You entered " << lambda0 << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (lambda1 > 0.1 * N) {
      cout << "Warning: Upper end of mutation rate range is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (lambda1 > 0.75 * N) {
      cout << "Error: Maximum mutation rate is 0.75 * sequence length = " 
	   << 0.75 * N << ".  " << "You entered " << lambda1 << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    for (i = 0; i <= nsteps; ++i) {
      step = float(i)/float(nsteps);
      lambda = lambda0 * pow((lambda1/lambda0),step);
      csum = seqsum(L,float(int(N)),lambda);
      cout << "<tr align=\"right\"><td>" << L << "</td><td>" << int(N) 
	   << "</td><td>" << lambda << "</td><td>" << csum << "</td></tr>\n";
      outfile << L << " " << int(N) << " " << lambda << " " << csum << "\n";
    }
  } else if (2 == mode) {
    // PEDEL.batch 2 lambda N L_0 L_1 nsteps
    lambda = param[0];
    N = param[1];
    L0 = param[2];
    L1 = param[3];
    if (L0 < 0.) {
      cout << "Error: Library size can't be negative.  "
	   << "You entered " << L0 << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (L0 < 10.) {
      cout << "Warning: Lower end of library size range very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (N < 1.) {
      cout << "Error: Sequence length must be positive integer.  "
	   << "You entered " << N << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (N < 5.) {
      cout << "Warning: Sequence length very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (lambda < 0.) {
      cout << "Error: Mean number of mutations can't be negative.  "
	   << "You entered " << lambda << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (lambda > 0.1 * N) {
      cout << "Warning: Mutation rate is high.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (lambda > 0.75 * N) {
      cout << "Error: Maximum mutation rate is 0.75 * sequence length = " 
	   << 0.75 * N << ".  " << "You entered " << lambda << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    for (i = 0; i <= nsteps; ++i) {
      step = float(i)/float(nsteps);
      L = L0 * pow((L1/L0),step);
      csum = seqsum(L,float(int(N)),lambda);
      cout << "<tr align=\"right\"><td>" << L << "</td><td>" << int(N) 
	   << "</td><td>" << lambda << "</td><td>" << csum << "</td></tr>\n";
      outfile << L << " " << int(N) << " " << lambda << " " << csum << "\n";
    }
  } else if (3 == mode) {
    // PEDEL.batch 3 L lambda N_0 N_1 nsteps
    L = param[0];
    lambda = param[1];
    N0 = param[2];
    N1 = param[3];
    if (L < 0.) {
      cout << "Error: Library size can't be negative.  "
	   << "You entered " << L << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (L < 10.) {
      cout << "Warning: Library size very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (N0 < 1.) {
      cout << "Error: Sequence length must be positive integer.  "
	   << "You entered " << N0 << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (N0 < 5.) {
      cout << "Warning: Lower end of sequence length range very small.  "
	   << "Statistics may be compromised.<br>\n";
    }
    if (lambda < 0.) {
      cout << "Error: Mean number of mutations can't be negative.  "
	   << "You entered " << lambda << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    if (lambda > 0.1 * N0) {
      cout << "Warning: Mutation rate is high relative to lower end of "
	   << "sequence length range.  Statistics may be compromised.<br>\n";
    }
    if (lambda > 0.75 * N0) {
      cout << "Error: Maximum mutation rate is 0.75 * lower end of "
	   << "sequence length range = " 
	   << 0.75 * N0 << ".  " << "You entered " << lambda << ".<br>\n";
      exit(EXIT_FAILURE);
    }
    for (i = 0; i <= nsteps; ++i) {
      step = float(i)/float(nsteps);
      N = N0 * pow((N1/N0),step);
      csum = seqsum(L,float(int(N)),lambda);
      cout << "<tr align=\"right\"><td>" << L << "</td><td>" << int(N) 
	   << "</td><td>" << lambda << "</td><td>" << csum << "</td></tr>\n";
      outfile << L << " " << int(N) << " " << lambda << " " << csum << "\n";
    }
  } else {
    cout << "Unsupported running mode: " << mode << ".<br>";
    exit(EXIT_FAILURE);
  }

  cout << "</table><br>\n";
  outfile.close();

}

double seqsum(double L, double N, double lambda)

{  

  // Subroutine to calculate expected number of distinct sequences given L, N, 
  //   lambda


  int i, test;
  double Cx, Lx, Px, Vx, Csum, Psum, seqsum;

  Csum = 1.;
  Psum = exp(-lambda);

  i = 1;
  Px = exp(-lambda) * lambda;
  Lx = L * Px;
  Vx = 3. * N;
  test = 0;
  while (Lx/Vx > 0.1) {
    Cx = Vx * (1. - exp(-Lx/Vx));
    Csum += Cx;
    Psum += Px;
    i += 1;
    if (i > int(N)) {
      test = 1;
      break;
    }
    Px *= lambda/float(i);
    Lx = L * Px;
    Vx *= 3. * (N-float(i)+1.)/float(i);
  }
  if (0 == test) {
    Csum += L * (1. - Psum);
  }

  // Sort of fudge here (only comes up where Poisson assumption is 
  //   violated anyway).
  if (int(N) < 50) {
    if (Csum > pow(4.,N)) {
      Csum = pow(4.,N);
    }
  }

  // Tidies up for very low values of L (where you shouldn't be using the 
  //   programme anyway).
  if (Csum > L) {
    Csum = L;
  }

  return(Csum);

}
