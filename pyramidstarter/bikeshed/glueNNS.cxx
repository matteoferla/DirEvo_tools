#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include<cstring>
using namespace std;

/*
Copyright (C) Andrew Firth and Wayne Patrick, September 2007

Programme for calculating

  1) the expected amino acid completeness of a given library (not worrying 
     about whether the stop codon variant is present or not)

where the sequences in the library are chosen at random from a set of
32 equiprobable NNS variants (i.e. single NNS codon is being mutated;
32 possible equiprobable codon variants; 20+1 possible amino acid/stop
codon variants).

Usage:
  glueNNS library_size
*/

int main(int argc, char* argv[])
{

  if (2 != argc) {
    cerr << "Usage '" << argv[0] << " library_size'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  double p, L, T;

  L = atof(argv[1]);
  if (L <= 0) {L = 0;}      
  cout << "Number of NNS codon variants: 32<br>\n";
  cout << "Number of amino acid variants: 20<br>\n";
  cout << "Library size: " << L << "<br>\n";
  cout << "Expected amino acid completeness: " 
       << (12*(1.-exp(-L/32)) + 5*(1.-exp(-2*L/32)) + 3*(1.-exp(-3*L/32)))/20.
       << "<br>\n";

}
