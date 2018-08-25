#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;

/*
 Copyright (C) Andrew Firth and Wayne Patrick, March 2005
 
 Programme to output some of the epPCR statistics (batch mode)
 
 Asks for sequence length N, library size L, and mutation rate lambda.
 Takes x=0,2,3,...,20
 Calculates statistics for sequences with exactly x mutations (expected total
 number in L (Lx), total number of distinct sequences (Vx), and the expected
 number of distinct sequences in the library (Cx)).
 
 Also use PEDEL.cxx to sum over all x values, i.e. to calculate the total
 expected number of distinct sequences in the library L.
 */

int main(int argc, char* argv[])
{
    
    if (5 != argc) {
        cout << "Usage '" << argv[0] << " library_size sequence_length "
        << "mean_number_of_mutations_per_sequence outfile'.\n";
        exit(EXIT_FAILURE);
    }
    
    cout << setprecision(4);
    
    int i, maxx;
    double L, lambda, Px, Lx, Vx, Cx, xfac, nfac, cx0, N;
    
    L = atof(argv[1]);
    N = int(float(atof(argv[2])));
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
    
    ofstream outfile(argv[4]);
    if (!outfile) {
        cerr << "Failed to open file '" << argv[4] << "'.\n";
        exit(EXIT_FAILURE);
    }
    outfile << setprecision(4);
    
    if (L * exp(-lambda) < 1.) {
        cx0 = L * exp(-lambda);
    } else {
        cx0 = 1.;
    }
    cout << "<tr align=\"right\"><td>" << 0 << "</td><td>" << exp(-lambda)
    << "</td><td>" << L*exp(-lambda) << "</td><td>" << 1.
    << "</td><td>" << cx0 << "</td><td>" << cx0
    << "</td><td>" << L*exp(-lambda) - cx0 << "</td></tr>\n";
    outfile << 0 << " " << exp(-lambda) << " " << L*exp(-lambda) << " "
    << 1. << " " << cx0 << " " << cx0 << " "
    << L*exp(-lambda) - cx0 << "\n";
    xfac = 1.;
    nfac = 1.;
    maxx = 20;
    if (maxx > int(N)) {
        maxx = int(N);
    }
    for (i = 1; i <= maxx; ++i) {
        xfac *= float(i);
        nfac *= (N-float(i)+1.);
        Px = exp(-lambda) * pow(lambda,i) / xfac;
        Lx = L * Px;
        Vx = pow(3.,i) * nfac / xfac;
        if (Lx/Vx > 0.1) {
            Cx = Vx * (1.-exp(-Lx/Vx));
        } else {
            Cx = Lx;
        }
        cout << "<tr align=\"right\"><td>" << i << "</td><td>" << Px
        << "</td><td>" << Lx << "</td><td>" << Vx
        << "</td><td>" << Cx << "</td><td>" << Cx/Vx 
        << "</td><td>" << Lx - Cx << "</td></tr>\n";
        outfile << i << " " << Px << " " << Lx << " "
        << Vx << " " << Cx << " " << Cx/Vx << " " << Lx - Cx << "\n"; 
    }
    outfile.close();
    
}


