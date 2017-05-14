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

Now generalized so user specifies (through the web interface) the type
of codons - e.g. NNN, NNS, NNK etc.

*/

int main(int argc, char* argv[])
{

  if (9 != argc) {
    cout << "Usage '" << argv[0] << " library_size c1 c2 c3 c4 c5 c6 ncodons'.\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  double p, L, T, tot, nvar;
  int c[6], total_aa, total_cod;

  L = atof(argv[1]);
  c[0] = atoi(argv[2]);
  c[1] = atoi(argv[3]);
  c[2] = atoi(argv[4]);
  c[3] = atoi(argv[5]);
  c[4] = atoi(argv[6]);
  c[5] = atoi(argv[7]);
  total_cod = atoi(argv[8]);

  if (L <= 0) {L = 0;}      
  total_aa = c[0] + c[1] + c[2] + c[3] + c[4] + c[5];
  tot = float(total_cod);
  nvar = c[0]*(1.-exp(-1.*L/tot)) + c[1]*(1.-exp(-2.*L/tot)) + 
         c[2]*(1.-exp(-3.*L/tot)) + c[3]*(1.-exp(-4.*L/tot)) + 
    c[4]*(1.-exp(-5.*L/tot)) + c[5]*(1.-exp(-6.*L/tot));


  cout << "Library size: " << L << "<br>\n";
  //    cout << "c1=" << c[0] << "; c2=" << c[1] << "; c3=" << c[2] << "; c4=" 
  //         << c[3] << "; c5=" << c[4] << "; c6=" << c[5] << ".<br>\n"; 
  cout << "Number of possible codon variants (including stop codon variants): "
       << total_cod << "<br>\n";
  cout << "Number of possible amino acid variants: " << total_aa << "<br>\n";
  cout << "Stop codon variant may or may not be present but does not count towards the number of distinct amino acid variants.<br>\n";
  if (total_aa < 10) {
    cout << "Warning: Number of possible amino acid variants is small.  "
	 << "Poisson statistics may be compromised.<br>\n";
  }

  cout << "Expected number of distinct amino acid variants: " 
       << nvar << "<br>\n";
  cout << "Completeness: " << nvar/float(total_aa) << "<br><br>\n";

}
