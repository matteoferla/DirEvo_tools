#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include<cstring>
using namespace std;
#define maxcodons 6

/*
Copyright (C) Andrew Firth and Wayne Patrick, September 2007
*/

int main(int argc, char* argv[])
{

  if (2 != argc) {
    cout << "Usage '" << argv[0] << " datafile'.\n";
    exit(EXIT_FAILURE);
  }
  cout << setprecision(4);

  double L, nvar, xtot;
  int ncodons, c[maxcodons][6], j0, j1, j2, j3, j4, j5, i, j;
  double total_aa[maxcodons], total_cod[maxcodons];
  double xtotal_aa, xtotal_cod, pcomplete;

  ifstream datafile(argv[1]);
  if (!datafile) {
    cout << "Aborting: can't find file '" << argv[1] << "'.\n";
    exit(EXIT_FAILURE);
  }
  datafile >> ncodons;
  datafile >> L;
  if (L <= 0) {L = 0.;}      
  for (i = 0; i < ncodons; ++i) {
    datafile >> total_cod[i];
    total_aa[i] = 0;
    for (j = 0; j < 6; ++j) {
      datafile >> c[i][j];
      total_aa[i] += float(c[i][j]);
    }
  }
  datafile.close();

  /*
  cout << L << " " << ncodons << "<br>\n";
  for (i = 0; i < ncodons; ++i) {
    cout << total_cod[i] << ":" << total_aa[i] << " ";
    for (j = 0; j < 6; ++j) {
      cout << c[i][j] << " ";
    }
    cout << "<br>\n";
  }
  */

  xtotal_aa = 1.;
  xtotal_cod = 1.;
  for (i = 0; i < ncodons; ++i) {
    xtotal_aa *= total_aa[i];
    xtotal_cod *= total_cod[i];
  }

  cout << "<br>Library size: " << L << "<br>\n";
  cout << "Number of variable codons: " << ncodons << "<br>\n";

  cout << "Number of possible codon variants (including stop codon variants): ";
  for (i = 0; i < ncodons - 1; ++i) {
    cout << total_cod[i] << " x ";
  }
  cout << total_cod[ncodons-1] << " = ";
  cout << xtotal_cod << "<br>\n";

  cout << "Number of possible amino acid variants: ";
  for (i = 0; i < ncodons - 1; ++i) {
    cout << total_aa[i] << " x ";
  }
  cout << total_aa[ncodons-1] << " = ";
  cout << xtotal_aa << "<br>\n";

  cout << "Variants containing one or more stop codon(s) may or may not be present but do not count towards the number of distinct amino acid variants.<br>\n";

  /*
  if (xtotal_aa < 10.) {
    cout << "Warning: Number of possible amino acid variants is small.  "
	 << "Poisson tatistics may be compromised.<br>\n";
  }
  */

  /*
  // This works for ncodons = 1:
  nvar = 0.;
  for (j = 0; j < 6; ++j) {
    nvar += float(c[0][j])*(1.-exp(-float(j+1)*L/tot[0]));
  }
  */

  // Easy way to do this for the case ncodons < 6 is to fill out the remaining 
  //   c[i][j] as if the remaining codons where XYZ = AAA (for example), i.e. 1
  //   codon variant, 1 amino acid variant so doesn't have any effect on the 
  //   statistics.
  for (i = ncodons; i < 6; ++ i) {
    c[i][0] = 1;
    for (j = 1; j < 6; ++j) {
      c[i][j] = 0;
    }
  }

  nvar = 0.;
  pcomplete = 1.;
  for (j0 = 0; j0 < 6; ++j0) {
    for (j1 = 0; j1 < 6; ++j1) {
      for (j2 = 0; j2 < 6; ++j2) {
	for (j3 = 0; j3 < 6; ++j3) {
	  for (j4 = 0; j4 < 6; ++j4) {
	    for (j5 = 0; j5 < 6; ++j5) {
	      if (c[0][j0]*c[1][j1]*c[2][j2]*c[3][j3]*c[4][j4]*c[5][j5] > 0) {
		nvar += float(c[0][j0]*c[1][j1]*c[2][j2]*c[3][j3]*c[4][j4]*c[5][j5])*(1.-pow(1.-float((j0+1)*(j1+1)*(j2+1)*(j3+1)*(j4+1)*(j5+1))/xtotal_cod,L));
		pcomplete *= pow(1.-pow(1.-float((j0+1)*(j1+1)*(j2+1)*(j3+1)*(j4+1)*(j5+1))/xtotal_cod,L),c[0][j0]*c[1][j1]*c[2][j2]*c[3][j3]*c[4][j4]*c[5][j5]);
	      }
	    }
	  }
	}
      }
    }
  }

  if (xtotal_aa > L) {
    pcomplete = 0.;
  }

  cout << "Expected number of distinct amino acid variants: " 
       << nvar << " <b>(not including variants with stop codons)</b><br>\n";
  cout << "Completeness: " << nvar/xtotal_aa << "<br>\n";
  cout << "Probability the library contains all possible amino acid variants: " 
       << pcomplete << "<br><br>\n";
  cout << "<hr>\n";

}
