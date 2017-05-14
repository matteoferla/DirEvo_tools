#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;

/*
Copyright (C) Andrew Firth and Wayne Patrick, March 2005

PEDEL: Programme for Estimating Diversity in Error-prone PCR Libraries

Programme to calculate the expected number of distinct sequences in an epPCR
library.

Asks for sequence length N, library size L, and mutation rate lambda.
Calculates expected number of distinct sequences in the library.

See also stats.cxx for intermediate statistics.
Use PEDEL.batch.cxx to run for a grid of lambda, N or L values.

Uses the Cx ~ Lx approximation when Lx/Vx < 0.1 but doesn't bother with the 
  Cx ~ Vx approximation for Lx/Vx > 3
*/

int main(int argc, char* argv[])
{

  if (4 != argc) {
    cout << "Usage '" << argv[0] << " library_size sequence_length "
	 << "mean_number_of_mutations_per_sequence'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  int i, test;
  double L, lambda, Cx, Lx, Px, Vx, Csum, Psum, N;

  L = atof(argv[1]);
  N = float(int(atof(argv[2])));
  lambda = atof(argv[3]);

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

  cout << "Library size = " << L << ".<br>\n";
  cout << "Sequence length = " << N << ".<br>\n";
  cout << "Mean mutations per sequence = " << lambda << ".<br>\n";
  cout << "Expected number of distinct sequences in library = " << Csum 
       << ".<br>\n";

}

