#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include<cstring>
using namespace std;

/*
 Copyright (C) Andrew Firth and Wayne Patrick, March 2005
 
 Programme for calculating any of the following
 
 1) the expected completeness of a given library
 
 2) the required library size for a given expected completeness
 
 3) the required library size for a given probability of being 100%
 complete
 
 where the sequences in the library are chosen at random from a set of
 equiprobable variants.
 
 Usage (3 running modes):
 glue 1 nvariants library_size
 glue 2 nvariants completeness
 glue 3 nvariants prob_100%_complete
 */

int main(int argc, char* argv[])
{
    
    if (4 != argc) {
        cerr << "Usage '" << argv[0] << " 1 nvariants library_size',\n"
        << "   or '" << argv[0] << " 2 nvariants completeness',\n"
        << "   or '" << argv[0] << " 3 nvariants prob_100%_complete'.\n";
        exit(EXIT_FAILURE);
    }
    
    cout << setprecision(4);
    
    int mode;
    double p, p100, var, L, T;
    
    mode = atoi(argv[1]);
    var = atof(argv[2]);
    if (var < 1) {var = 1;}
    if (var < 10) {
        cout << "Warning: Number of variants very small.  "
        << "Poisson statistics may be compromised.<br>\n";
    }
    
    if (1 == mode) {
        L = atof(argv[3]);
        if (L <= 0) {L = 0;}
        cout << "Number of possible variants: " << var << "<br>\n";
        cout << "Library size: " << L << "<br>\n";
        cout << "Expected completeness: " << 1.-exp(-L/var) << "<br>\n";
        
    } else if (2 == mode) {
        p = atof(argv[3]);
        if (p < 0) {p = 0;}
        if (p >= 0.999999) {p = 0.999999;}
        cout << "Number of possible variants: " << var << "<br>\n";
        cout << "Expected completeness: " << p << "<br>\n";
        cout << "Required library size: " << -var*log(1.-p) << "<br>\n";
        
    } else if (3 == mode) {
        p100 = atof(argv[3]);
        if (p100 < 0) {p100 = 0;}
        if (p100 >= 0.9999) {p100 = 0.9999;}
        if(-log(p100)/var >= 0.1) {
            cout << "Warning: Probability too small to continue.<br>\n";
            exit(EXIT_FAILURE);
        }
        cout << "Number of possible variants: " << var << "<br>\n";
        cout << "Probability that the library is 100% complete: " << p100
        << "<br>\n";
        cout << "Required library size: " << -var*log(-log(p100)/var) << "<br>\n";
        
    } else {
        cout << "Unsupported running mode: " << mode << ".<br>\n";
        exit(EXIT_FAILURE);
    }
    
}
