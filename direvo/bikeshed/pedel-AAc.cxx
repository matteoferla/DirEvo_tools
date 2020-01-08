#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <cstring>
using namespace std;
#define maxlength 50000
#define maxx0 20
#define maxx0nt 100

// Read in initial sequence (length N; reading frame begins at nt 1, no
//   in-frame stop codons).
// Read nucleotide, codon and amino acid matrix.
// Scale nucleotide matrix so that the mean total number of muts per sequence
//   (no amino acid selection) equals nsubst.
// Output probability and cummulative probability matrix for introduced stop
//   codons and/or indels, and the histogram of daughter sequence lengths.
// Calculate amino acid approximation of PEDEL stats.

// Function declarations
double pcrprob(int pcrnmuts, double lambda, double ncycles, double eff);

int main(int argc, char * argv[]) {
  if (2 != argc) {
    cout << "Usage: '" << argv[0] << " setupfile'.<br>\n";
    exit(EXIT_FAILURE);
  }

  cout << setprecision(4);

  //---------------------------------------------------------------------------
  // Variable declarations.

  int i, j, k, k1, k2, k3, nlines, nseq, i1, i2, i3, j1, j2, j3, codon, codon2;
  int aa2aa[64], seq[maxlength], seqnuc[4], A[64], longseq, longseqnt, nucnorm;
  int maxx, maxxnt, codoncount[64], distr, x, y, Poiswarning, PCRwarning;
  double nsubst, ninsert, ndelete, library, max0, nuc[4][4];
  double stopprobc[1 + maxlength / 3];
  double stopprob[64], nullprob[64], synprob[64], nonsynprob[64];
  double probnostops[1 + maxlength / 3], firststop[1 + maxlength / 3];
  double pnoinsert, pnodelete, ncycles, eff;
  double sumstopprob, sumnullprob, sumsynprob, sumnonsynprob;
  double Afactor, logAfactor, CtotalCombPCR, CtotalPCR, CtotalPois;
  double xfac, yfac, nfac, Px, PleftoverPois, PleftoverPCR, CtotalCombPois;
  double p0, p_ik, L1, L2, aaprobs[64][20];
  double P0exact, P1exact, P2exact;
  double uniqptmuts, nnoaamuts, nsingleaamuts, ndoubleaamuts;
  double nnoaamutsPCR, nsingleaamutsPCR, ndoubleaamutsPCR;
  //  double P3exact, ntripleaamuts, ntripleaamutsPCR;
  double Vx1[maxx0 + 1], Vx2[maxx0 + 1], LxPois[maxx0 + 1], CxPois[maxx0 + 1];
  double LxPCR[maxx0 + 1], CxPCR[maxx0 + 1], CxCombPois[maxx0 + 1];
  double CxExactPois[maxx0 + 1], CxExactPCR[maxx0 + 1];
  double LxCxCombPois[maxx0 + 1], CxCombPCR[maxx0 + 1], LxCxCombPCR[maxx0 + 1];
  double NtPxPois[maxx0nt + 1], NtPxPCR[maxx0nt + 1];
  double AaPxPois[maxx0nt + 1], AaPxPCR[maxx0nt + 1];
  double NtPleftoverPois, NtPleftoverPCR, frac, stopfrac, nostops;
  double Binomialprobs[maxx0nt + 1][maxx0nt + 1];
  char aa[20], aa2codon[64], seqline[1000], name[1000], A_file[128];
  char seq_file[128], inputseq[maxlength], nuc_file[128], aa2codon_file[128];
  char newurl[128], seqstats_file[128], nucmatrix_file[128];
  char libtable_file[128];
  double p_ATTA, p_ACTG, p_AGTC, p_CGGC, p_CTGA, p_GTCA;
  //  double aaQ[64][20], minQ, sumQ, logQfactor, Qfactor;
  double Pc[maxx0 + 1], RxPois[maxx0 + 1], RxPCR[maxx0 + 1], maxProbs[maxx0 + 1], maxP;

  //---------------------------------------------------------------------------
  // Setup parameters.

  // Open setup file.
  ifstream setupfile(argv[1]);
  if (!setupfile) {
    cout << "Aborting: can't find setup file '" << argv[1] << "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  // Read setup parameters.
  setupfile.getline(seq_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(nuc_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(aa2codon_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(A_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(newurl, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(nucmatrix_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(libtable_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile.getline(seqstats_file, 128, ' ');
  setupfile.ignore(1000, '\n');
  setupfile >> nsubst;
  setupfile.ignore(1000, '\n');
  setupfile >> ninsert;
  setupfile.ignore(1000, '\n');
  setupfile >> ndelete;
  setupfile.ignore(1000, '\n');
  setupfile >> library;
  setupfile.ignore(1000, '\n');
  setupfile >> nucnorm;
  setupfile.ignore(1000, '\n');
  setupfile >> distr;
  setupfile.ignore(1000, '\n');
  setupfile >> ncycles;
  setupfile.ignore(1000, '\n');
  setupfile >> eff;
  setupfile.ignore(1000, '\n');
  setupfile.close();

  // KILL DISTR
  distr = 1;
  //---------------------------------------------------------------------------
  // Read codon to amino acid table.
  ifstream aa2codonfile(aa2codon_file);
  if (!aa2codonfile) {
    cout << "\nAborting: can't find aa2codon file '" << aa2codon_file << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  for (i = 0; i < 64; ++i) {
    aa2codonfile.get(aa2codon[i]);
    aa2codonfile.ignore(1000, '\n');
  }
  aa2codonfile.close();

  aa[0] = 'A';
  aa[1] = 'R';
  aa[2] = 'N';
  aa[3] = 'D';
  aa[4] = 'C';
  aa[5] = 'Q';
  aa[6] = 'E';
  aa[7] = 'G';
  aa[8] = 'H';
  aa[9] = 'I';
  aa[10] = 'L';
  aa[11] = 'K';
  aa[12] = 'M';
  aa[13] = 'F';
  aa[14] = 'P';
  aa[15] = 'S';
  aa[16] = 'T';
  aa[17] = 'W';
  aa[18] = 'Y';
  aa[19] = 'V';

  // Lookup table connecting aa2codon[64] and aa[20].
  for (i = 0; i < 64; ++i) {
    aa2aa[i] = 99; // for STOP codons
    for (j = 0; j < 20; ++j) {
      if (aa2codon[i] == aa[j]) {
        aa2aa[i] = j;
      }
    }
  }

  //---------------------------------------------------------------------------
  // Read A-factor file (for each codon, the number of non-synonymous, non-stop
  //  codon, amino acid substitutions accessible by a single nucleotide
  //  substitution).

  ifstream Afile(A_file);
  if (!Afile) {
    cout << "\nAborting: can't find A file '" << A_file << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  for (i = 0; i < 64; ++i) {
    Afile >> A[i];
    Afile.ignore(1000, '\n');
  }
  Afile.close();

  //---------------------------------------------------------------------------
  // Read initial sequence.

  seqnuc[0] = seqnuc[1] = seqnuc[2] = seqnuc[3] = 0;
  ifstream sequence1(seq_file);
  if (!sequence1) {
    cout << "Aborting: can't find seq file '" << seq_file << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  nlines = 0;
  while (sequence1.ignore(1000, '\n')) {
    ++nlines;
  }
  sequence1.clear();
  sequence1.seekg(0);
  sequence1.getline(name, 1000, '\n');
  for (i = 0; i < nlines - 1; ++i) {
    sequence1.getline(seqline, 1000, '\n');
    if (0 == i) {
      strcpy(inputseq, seqline);
    } else {
      strcat(inputseq, seqline);
    }
  }
  sequence1.close();
  for (i = 0;; ++i) {
    if (inputseq[i] == 'U' || inputseq[i] == 'u') {
      seq[i] = 0;
      seqnuc[0] += 1;
    } else if (inputseq[i] == 'T' || inputseq[i] == 't') {
      seq[i] = 0;
      seqnuc[0] += 1;
    } else if (inputseq[i] == 'C' || inputseq[i] == 'c') {
      seq[i] = 1;
      seqnuc[1] += 1;
    } else if (inputseq[i] == 'A' || inputseq[i] == 'a') {
      seq[i] = 2;
      seqnuc[2] += 1;
    } else if (inputseq[i] == 'G' || inputseq[i] == 'g') {
      seq[i] = 3;
      seqnuc[3] += 1;
    } else if (inputseq[i] == '\0') {
      nseq = i;
      break;
    } else {
      cout << "\nAborting: sequence " << seq_file << ", unknown nucleotide '" <<
        inputseq[i] << "' at position " << i << ".<br>\n";
      exit(EXIT_FAILURE);
    }
  }
  if (0 == nseq) {
    cout << "\nAborting: No sequence data entered.<br>\n";
    exit(EXIT_FAILURE);

  }
  cout << "There are " << seqnuc[0] << " T's, " << seqnuc[1] << " C's, " <<
    seqnuc[2] << " A's and " << seqnuc[3] <<
    " G's in the input sequence.<br>\n";

  if (nseq % 3 != 0) {
    cout << "Input sequence length must be a multiple of 3 nucleotides to " <<
      "define the amino acid read-frame.<br>\n";
    exit(EXIT_FAILURE);
  }

  //---------------------------------------------------------------------------
  // Miscellaneous

  if (nsubst <= 0.0) {
    cout << "\nRequire mean number of substitutions per variant " <<
      "> 0.  You entered '" << nsubst << "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  if (library <= 0.0) {
    cout << "\nRequire library size > 0.<br>\n";
    exit(EXIT_FAILURE);
  }

  if (ninsert < 0.0) {
    cout << "\nRequire mean number of insertions per variant " <<
      ">= 0.  Adjusting 'ninsert' to 0.<br>\n";
    ninsert = 0;
  }

  if (ndelete < 0.0) {
    cout << "\nRequire mean number of deletions per variant " <<
      ">= 0.  Adjusting 'ndelete' to 0.<br>\n";
    ndelete = 0;
  }

  if (nsubst > float(nseq)) {
    cout << "\nError: Require mean number of substitutions per variant " <<
      "<= sequence length.  You entered '" << nsubst <<
      "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  if (nsubst > 70) {
    cout << "\nError: Maximum allowed mean number of substitutions per variant" <<
      " = 70.  You entered '" << nsubst <<
      "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  if (nsubst > float(nseq) / 10.) {
    cout << "\nError: Mean number of substitutions per variant not allowed" <<
      " to be greater than 0.1 * sequence length (nt) = " <<
      float(nseq) / 10. << ".  You entered '" << nsubst << "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  if ((ninsert + ndelete) >= float(nseq)) {
    cout << "\nError: Require mean number of insertions + deleteions per " <<
      " variant < sequence length.  You entered '" <<
      ninsert << " + " << ndelete << "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  if (0 != nseq % 3) {
    cout << "Error: Length of input sequence is not a multiple of three nt, " <<
      "so amino acid reading-frame is not well-defined.<br>";
    exit(EXIT_FAILURE);
  }

  //---------------------------------------------------------------------------

  // Miscellaneous stats

  pnoinsert = exp(-ninsert);
  pnodelete = exp(-ndelete);
  L2 = library * pnoinsert * pnodelete;

  //---------------------------------------------------------------------------
  // Read 4 x 4 nucleotide mutation matrix (order is UCAG; diagonal terms
  //  ignored, scaling unimportant; row i -> column k.)
  ifstream nucfile(nuc_file);
  if (!nucfile) {
    cout << "\nAborting: can't find nuc file '" << nuc_file << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  for (i = 0; i < 4; ++i) {
    for (k = 0; k < 4; ++k) {
      nucfile >> nuc[i][k];
    }
    nucfile.ignore(1000, '\n');
  }
  nucfile.close();
  for (i = 0; i < 4; ++i) {
    nuc[i][i] = 0.;
  }
  for (i = 0; i < 4; ++i) {
    for (k = 0; k < 4; ++k) {
      if (nuc[i][k] < 0.) {
        cout << "Aborting: nucleotide matrix value at " << i + 1 << ", " << k + 1 <<
          " is negative.<br>\n";
        exit(EXIT_FAILURE);
      }
    }
  }

  // Note - do not normalize rows independently.  If G -> not-G mutations are
  //  twice as frequent as A -> not-A mutations in the experimental data, then
  //  you want to preserve this.
  // Note that if you calculate these values from a set of sequenced daughters,
  //  then be sure to divide the observed number of N1 -> N2 substitutions by
  //  the number of N1 nucleotides in the parent sequence [N1,N2 = A,C,G,T; N1
  //  != N2].  For example, if the parent sequence contains 100 A residues and
  //  50 G residues, and, after sequencing many daughters, you observe 20 A ->
  //  T substitions and 10 G -> T substitions, then in the nucleotide matrix
  //  A -> T and G -> T should both be set to 0.2 [20/100 = 10/50 = 0.2].
  // -> This is the nucnorm = 1 (normalized matrix) option.  For the nucnorm =
  //  0 (unnormalized matrix) option, pedel-AAc will normalize the matrix
  //  using the input sequence A,C,G,T frequencies.
  if (0 == nucnorm) {
    for (i = 0; i < 4; ++i) {
      for (k = 0; k < 4; ++k) {
        nuc[i][k] /= seqnuc[i];
      }
    }
  }

  // 'Symmetrize' the matrix, reducing the free parameters from 12 to 6.  As
  //   pointed out by Volles2005, the sum of, for example, p(A->C) and it's
  //   complement p(T->G), has a much bigger effect than the individual probs.
  //   This is because PCR happens on both strands and an A->C mut in the
  //   coding strand could just as easily have been caused by a T->G mut on the
  //   non-coding strand.  For their precedure, the individual probs are still
  //   (slightly) important because you can have an odd number of epPCR
  //   copyings of the strand.  However for my procedure, I only deal with a
  //   single strand(!!!) so you HAVE TO combine p(A->C) and p(T->G) into a
  //   single prob, and so on for the other 5 complementary pairs.
  p_ATTA = 0.5 * (nuc[2][0] + nuc[0][2]);
  p_ACTG = 0.5 * (nuc[2][1] + nuc[0][3]);
  p_AGTC = 0.5 * (nuc[2][3] + nuc[0][1]);
  p_CGGC = 0.5 * (nuc[1][3] + nuc[3][1]);
  p_CTGA = 0.5 * (nuc[1][0] + nuc[3][2]);
  p_GTCA = 0.5 * (nuc[3][0] + nuc[1][2]);
  nuc[2][0] = nuc[0][2] = p_ATTA;
  nuc[2][1] = nuc[0][3] = p_ACTG;
  nuc[2][3] = nuc[0][1] = p_AGTC;
  nuc[1][3] = nuc[3][1] = p_CGGC;
  nuc[1][0] = nuc[3][2] = p_CTGA;
  nuc[3][0] = nuc[1][2] = p_GTCA;

  // Scale so that mean number of mutations per daughter sequence = nsubst.
  max0 = 0.;
  for (i = 0; i < 4; ++i) {
    for (k = 0; k < 4; ++k) {
      max0 += seqnuc[i] * nuc[i][k];
    }
  }
  max0 /= nsubst;
  for (i = 0; i < 4; ++i) {
    for (k = 0; k < 4; ++k) {
      nuc[i][k] /= max0;
    }
  }

  // Now we can set the diagonals.
  nuc[0][0] = 1. - nuc[0][1] - nuc[0][2] - nuc[0][3];
  nuc[1][1] = 1. - nuc[1][0] - nuc[1][2] - nuc[1][3];
  nuc[2][2] = 1. - nuc[2][0] - nuc[2][1] - nuc[2][3];
  nuc[3][3] = 1. - nuc[3][0] - nuc[3][1] - nuc[3][2];
  // Check none are negative (this can happen if nsubst is very high and some
  //  nucleotides are more likely to mutate than others - we have already
  //  checked that nsubst <= nseq, but if for example C's are twice as likely
  //  to mutate as A's, then when all the C's are mutated, half of the A's must
  //  be unmutated, so in this case we can't have nsubst = nseq.
  for (i = 0; i < 4; ++i) {
    if (nuc[i][i] < 0) {
      cout << "Error: 'nsubst' is too high.<br>\n";
      exit(EXIT_FAILURE);
    }
  }

  // Write out normalized scaled nucleotide matrix.
  ofstream nucmatrix(nucmatrix_file);
  if (!nucmatrix) {
    cout << "Aborting: can't open output file '" << nucmatrix << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  nucmatrix << setprecision(3);
  nucmatrix << "<html><head>\n" <<
    "<title>PEDEL-AA - nucleotide matrix</title>\n" <<
    "</head><body>\n";
  nucmatrix << "<br><b>Normalized and scaled nucleotide matrix:</b><br><br>" <<
    "<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\">" <<
    "<tr><td colspan=\"2\" rowspan=\"2\"></td>" <<
    "<td colspan=\"4\" align=\"center\">TO</td>" <<
    "</tr><tr>" <<
    "<td align=\"center\"><b>T</b></td>" <<
    "<td align=\"center\"><b>C</b></td>" <<
    "<td align=\"center\"><b>A</b></td>" <<
    "<td align=\"center\"><b>G</b></td>" <<
    "</tr><tr>" <<
    "<td rowspan=\"4\" width=\"40\">F<br>R<br>O<br>M</td>" <<
    "<td width=\"20\"><b>T</b></td><td>" <<
    nuc[0][0] << "</td><td>" <<
    nuc[0][1] << "</td><td>" <<
    nuc[0][2] << "</td><td>" <<
    nuc[0][3] << "</td></tr>" <<
    "<tr><td><b>C</b></td><td>" <<
    nuc[1][0] << "</td><td>" <<
    nuc[1][1] << "</td><td>" <<
    nuc[1][2] << "</td><td>" <<
    nuc[1][3] << "</td></tr>" <<
    "<tr><td><b>A</b></td><td>" <<
    nuc[2][0] << "</td><td>" <<
    nuc[2][1] << "</td><td>" <<
    nuc[2][2] << "</td><td>" <<
    nuc[2][3] << "</td></tr>" <<
    "<tr><td><b>G</b></td><td>" <<
    nuc[3][0] << "</td><td>" <<
    nuc[3][1] << "</td><td>" <<
    nuc[3][2] << "</td><td>" <<
    nuc[3][3] << "</td></tr>" <<
    "</table>\n";
  nucmatrix << "</body></html>\n";
  nucmatrix.close();

  //---------------------------------------------------------------------------

  // Calculate stop codon insertion probabilities.
  for (codon = 0; codon < nseq / 3; codon += 1) {
    stopprobc[codon] = 0;
    i1 = seq[3 * codon];
    i2 = seq[3 * codon + 1];
    i3 = seq[3 * codon + 2];
    for (j = 0; j < 64; ++j) {
      if (99 == aa2aa[j]) { // A stop codon.
        j1 = int(j / 16);
        j2 = int((j - 16 * j1) / 4);
        j3 = j - 16 * j1 - 4 * j2;
        stopprobc[codon] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
      }
    }
  }

  // Cummulative probability (along the sequence) of no stop codon insertions.
  probnostops[0] = 1. - stopprobc[0];
  for (codon = 1; codon < nseq / 3; codon += 1) {
    probnostops[codon] = probnostops[codon - 1] * (1. - stopprobc[codon]);
  }

  // Probability that codon i is the first stop in the daughter sequence (and
  //  hence length distribution of daughter sequences).
  firststop[0] = stopprobc[0];
  for (codon = 1; codon < nseq / 3; codon += 1) {
    firststop[codon] = probnostops[codon - 1] * stopprobc[codon];
  }

  //---------------------------------------------------------------------------

  // Count number of each type of codon in the sequence.
  for (i = 0; i < 64; ++i) {
    codoncount[i] = 0;
  }
  for (codon = 0; codon < nseq / 3; codon += 1) {
    i1 = seq[3 * codon];
    i2 = seq[3 * codon + 1];
    i3 = seq[3 * codon + 2];
    i = 16 * i1 + 4 * i2 + i3;
    codoncount[i] += 1;
  }

  //---------------------------------------------------------------------------

  // Miscellaneous sequence statistics.

  for (i = 0; i < 64; i += 1) {
    i1 = int(i / 16);
    i2 = int((i - 16 * i1) / 4);
    i3 = i - 16 * i1 - 4 * i2;
    nullprob[i] = nuc[i1][i1] * nuc[i2][i2] * nuc[i3][i3];
    synprob[i] = 0;
    for (j = 0; j < 64; ++j) {
      if (j != i && aa2aa[j] == aa2aa[i]) {
        // A non-null synonymous mutation.
        j1 = int(j / 16);
        j2 = int((j - 16 * j1) / 4);
        j3 = j - 16 * j1 - 4 * j2;
        synprob[i] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
      }
    }
    nonsynprob[i] = 0;
    for (j = 0; j < 64; ++j) {
      if (99 != aa2aa[j] && aa2aa[j] != aa2aa[i]) {
        // A non-stop non-synonymous mutation.
        j1 = int(j / 16);
        j2 = int((j - 16 * j1) / 4);
        j3 = j - 16 * j1 - 4 * j2;
        nonsynprob[i] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
      }
    }
    stopprob[i] = 0;
    for (j = 0; j < 64; ++j) {
      if (99 == aa2aa[j]) { // A stop codon.
        j1 = int(j / 16);
        j2 = int((j - 16 * j1) / 4);
        j3 = j - 16 * j1 - 4 * j2;
        stopprob[i] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
      }
    }
  }

  sumstopprob = sumnullprob = sumsynprob = sumnonsynprob = 0;
  for (i = 0; i < 64; ++i) {
    sumstopprob += codoncount[i] * stopprob[i];
    sumnullprob += codoncount[i] * nullprob[i];
    sumsynprob += codoncount[i] * synprob[i];
    sumnonsynprob += codoncount[i] * nonsynprob[i];
  }

  //---------------------------------------------------------------------------

  // Calculate P(A_i -> A_j; j=1..20, non-stop) for each codon type
  for (i = 0; i < 64; i += 1) {
    i1 = int(i / 16);
    i2 = int((i - 16 * i1) / 4);
    i3 = i - 16 * i1 - 4 * i2;
    for (k = 0; k < 20; ++k) {
      aaprobs[i][k] = 0.;
    }
    for (j = 0; j < 64; ++j) {
      j1 = int(j / 16);
      j2 = int((j - 16 * j1) / 4);
      j3 = j - 16 * j1 - 4 * j2;
      if (99 != aa2aa[j]) { // A non-stop mutation
        aaprobs[i][aa2aa[j]] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
      }
    }
  }

  //---------------------------------------------------------------------------

  // Calculate P0 = Product_{N_codons} P(A_i -> A_i) (null or synonymous
  //   mutations; i.e. P(daughter has no aa muts)).
  p0 = 1.;
  for (i = 0; i < 64; i += 1) {
    if (99 != aa2aa[i]) {
      i1 = int(i / 16);
      i2 = int((i - 16 * i1) / 4);
      i3 = i - 16 * i1 - 4 * i2;
      p0 *= pow(aaprobs[i][aa2aa[i]], codoncount[i]);
    }
  }
  // Note should use the post-indel pre-PTC library size here, since the
  //   probabilities still inc sequences with premature stop codons.
  //   -> i.e. L2 = library * pnoinsert * pnodelete

  //Note always use
  //     'if (99 != aa2aa[i]) { // ignoring stopcodons'
  //  in
  //    'for (i = 0; i < 64; ++i) {
  //      ... aaprobs[i][aa2aa[i]] ...'
  //  because aaprobs[i][99] is undefined.

  //---------------------------------------------------------------------------

  // Afactor

  logAfactor = 0;
  for (i = 0; i < 64; i += 1) {
    logAfactor += codoncount[i] * log(A[i]);
  }
  logAfactor /= (nseq / 3);
  Afactor = exp(logAfactor);

  //---------------------------------------------------------------------------

  /*
  // Qfactor

  // Q is the geometric mean over all codons i in the input sequence of 'Q_i =
  //   P(all single-nucleotide-substitution non-synonymous amino acid
  //   substitutions)/P(least probable single-nucleotide-substitution non-
  //   synonymous amino acid substitution)'.

  // For each codon type, calculate the sum of probs of all possible
  //   single-nucleotide-substitution non-synonymous amino acid substitution;
  //   group by amino acid and find the min amino acid prob.
  logQfactor = 0;
  for (i = 0; i < 64; i += 1) {
    if (99 != aa2aa[i]) { // A non-stop codon
      i1 = int(i/16);
      i2 = int((i-16*i1)/4);
      i3 = i-16*i1-4*i2;
      for (k = 0; k < 20; ++k) {
	aaQ[i][k] = 0.;
      }
      for (j = 0; j < 64; ++j) {
	if (99 != aa2aa[j]) { // A non-stop mutation
	  j1 = int(j/16);
	  j2 = int((j-16*j1)/4);
	  j3 = j-16*j1-4*j2;
	  if (i != j) {  // A non-null codon mutation
	    if ((i1 == j1 && i2 == j2)
		|| (i1 == j1 && i3 == j3)
		|| (i2 == j2 && i3 == j3)) {
	      // A single-nucleotide-substitution codon
	      if (aa2aa[j] != aa2aa[i]) {// A non-stop non-synonymous mutation.
		aaQ[i][aa2aa[j]] += nuc[i1][j1] * nuc[i2][j2] * nuc[i3][j3];
	      }
	    }
	  }
	}
      }
      sumQ = 0;
      minQ = 9999999999.;
      for (k = 0; k < 20; ++k) {
	sumQ += aaQ[i][k];
	if (aaQ[i][k] < minQ && aaQ[i][k] > 0.) {
	  minQ = aaQ[i][k];
	}
      }
      logQfactor += codoncount[i] * log(sumQ/minQ);
    }
  }
  logQfactor /= (nseq/3);
  Qfactor = exp(logQfactor);
  cout << "Q = " << Qfactor << "<br>\n";
  */

  //---------------------------------------------------------------------------

  // Effective library size (daughters with no indels and no introduced stop
  //   codons).
  L1 = library * pnoinsert * pnodelete * probnostops[(nseq / 3) - 1];

  //---------------------------------------------------------------------------

  // Calculate nucleotide PCR and poisson distributions for
  //   x = 0,1,...,min(100,nseq).

  for (i = 0; i <= maxx0nt; ++i) {
    NtPxPois[i] = NtPxPCR[i] = 0.;
  }

  // x = 0 stats
  // Poisson
  NtPxPois[0] = exp(-nsubst);
  // PCR
  if (0 == distr) {
    NtPxPCR[0] = pcrprob(0, nsubst, ncycles, eff);
  }
  // x = 1,2,...,min(100,nseq).
  yfac = 1.;
  longseqnt = 1;
  maxxnt = maxx0nt;
  if (maxxnt >= nseq) {
    maxxnt = nseq;
    longseqnt = 0;
  }
  for (i = 1; i <= maxxnt; ++i) {
    yfac *= nsubst;
    yfac /= float(i);
    // Poisson
    NtPxPois[i] = exp(-nsubst) * yfac;
    // PCR
    if (0 == distr) {
      NtPxPCR[i] = pcrprob(i, nsubst, ncycles, eff);
    }
  }

  // Note that the nt Poisson/PCR calculations go up to x = 100.
  // Max allowed input nsubst = 70, for which NtPxPois[100] = 0.0001378,
  //   NtPxPCR[100] = 0.005719, NtPleftoverPois = 0.0002926 and NtPleftoverPCR
  //   = 0.0553.  Furthermore for x >= 100, < 0.006 of variants are stop-codon
  //   free.
  // For nsubst = 3.2, NtPxPois[100] = 1.43e-109, NtPxPCR[100] = 3.21e-81,
  //   NtPleftoverPois = 0 and NtPleftoverPCR = 2.121e-15.
  // Note also the factorial P1 in the pcrprob subroutine gets down to about
  //   10^-158 at x = 100, which is still calculable, but don't want to go
  //   much further or you may get a numeric underflow.

  //---------------------------------------------------------------------------

  // Reduce the Px for expected number of truncated variants (an increasing
  //   function of x).  Note the Px will no longer add up to one.

  // Mean number of stop codons per nt substitution (evaluated at the mean
  //   number of nt substitutions).
  stopfrac = sumstopprob / nsubst;

  // Note that we are assuming that stopfrac is constant, but in fact it varies
  //   with x as the probability of getting multiple substitutions in the same
  //   codon varies.  The stopfrac we use is precise at x = nsubst - i.e. the
  //   peak of the initial Px distribution.  Since the max allowed input nsubst
  //   <= nseq/10 (i.e. ncodons/3.333), the effect of multiple substitutions in
  //   the same codon at high x won't be too great.

  // After reducing the Px for the expected number of truncated variants, the
  //   Px will no longer add up to 1.  Instead they will add up to (more-or-
  //   less) probnostops[(nseq/3)-1] (= L1/L2 = 0.8503 for the Volles case).
  NtPleftoverPois = NtPleftoverPCR = probnostops[(nseq / 3) - 1];

  // Reduce Px values to exclude variants with stop codons.
  nostops = 1.;
  for (i = 0; i <= maxxnt; ++i) {
    NtPxPois[i] *= nostops;
    NtPleftoverPois -= NtPxPois[i];
    if (0 == distr) {
      NtPxPCR[i] *= nostops;
      NtPleftoverPCR -= NtPxPCR[i];
    }
    nostops *= (1. - stopfrac);
  }
  // -> Checked (for Volles case) that Sum NtPx{PCR,Pois} = 1 before '*=
  //    nostops', and Sum NtPx{PCR,Pois} = {0.85053,0.851308} after '*=
  //    nostops'.  Cf. expected probnostops[(nseq/3)-1] =  0.8503.
  if (NtPleftoverPois < 0.) {
    NtPleftoverPois = 0.;
  }
  if (0 == distr) {
    if (NtPleftoverPCR < 0.) {
      NtPleftoverPCR = 0.;
    }
  }

  // For nseq >= 100, discard NtPleftover.  For nseq < 100, add NtPleftover to
  //   NtPx[nseq].
  // In principle, the Pleftover values can be important if maxxnt is limited
  //   by the sequence length (though now we are limiting nsubst < nseq/10)
  //   this may never be very important (and from a couple of tests with nseq =
  //   30 and nseq = 6 and nsubst = nseq/10, I find that Pleftover may be
  //   usually -ve - due to the probnostops[(nseq/3)-1] starting value not
  //   precisely agreeing with the Sum_0^nseq NtPx values).
  if (0 == longseqnt) {
    NtPxPois[maxxnt] += NtPleftoverPois;
    if (0 == distr) {
      NtPxPCR[maxxnt] += NtPleftoverPCR;
    }
  }
  // Note that new Pleftover values will be recalculate for the amino acid Px
  //   matrices (with the maxx = 20 limit) for use in the Lx ~ Cx infinite sum.

  //---------------------------------------------------------------------------

  // Convert (# nt muts) Pois/PCR probability distributions to (# nonsyn aa
  //   muts) probability distributions.

  // Mean number of nonsyn aa substitutions per nt substitution (evaluated at
  //   the mean number of nt substitutions).
  frac = sumnonsynprob / nsubst;
  // Since variants containing stop codons have already been removed, what we
  //   actually want is                (Recall P(B|A) = P(A & B)/P(A).)
  //   P(nt mut gives a nonsyn aa mut|nt mut doesn't give a stop codon)
  //   = P(nt mut gives a nonsyn aa mut)/P(nt mut doesn't give a stop codon)
  frac /= (1. - stopfrac);

  // Note that we are assuming that frac is constant, but in fact it varies
  //   with x as the probability of getting multiple substitutions in the same
  //   codon varies.  The frac we use is precise at x = nsubst - i.e. the peak
  //   of the initial Px distribution.  Since the max allowed input nsubst
  //   <= nseq/10 (i.e. ncodons/3.333), the effect of multiple substitutions in
  //   the same codon at high x won't be too great.

  // Now for each x = 0,1,...,min(nseq,100) we need to calculate the
  //   probability distribution P(y|x) of getting y nonsyn aa substitutions
  //   (normalized so that Sum_y P(y|x) sums to NtPx[x])  Clearly y = 0,...,x.
  //   Within this range, we assume that  P(y|x) is given by the binomial
  //   distribution with mean frac, i.e.
  //                P(y|x) =  frac^y (1-frac)^(x-y) C(x,y)
  //   where C(x,y) = x!/[y!(x-y)!].  Then sum up all the P(y) distributions to
  //   give the aa distribution over y = 0,1,...,min(nseq,100).

  // Although binomial distribution can be approximated by normal if x is large
  //   (and some other conditions), it is convenient - and OK in terms of CPU -
  //   not to bother.
  for (x = 0; x <= maxxnt; ++x) {
    for (y = 0; y <= maxxnt; ++y) {
      Binomialprobs[x][y] = 0;
    }
  }
  for (x = 0; x <= maxxnt; ++x) {
    Binomialprobs[x][0] = pow((1. - frac), x);
    for (y = 1; y <= x; ++y) {
      Binomialprobs[x][y] = Binomialprobs[x][y - 1] * (frac / (1. - frac)) *
        (float(x - y + 1) / float(y));
    }
  }

  //Now, sum them up.
  for (y = 0; y <= maxxnt; ++y) {
    AaPxPois[y] = AaPxPCR[y] = 0;
  }
  for (x = 0; x <= maxxnt; ++x) {
    for (y = 0; y <= x; ++y) {
      AaPxPois[y] += Binomialprobs[x][y] * NtPxPois[x];
      if (0 == distr) {
        AaPxPCR[y] += Binomialprobs[x][y] * NtPxPCR[x];
      }
    }
  }

  /*
  for (i = 0; i <= maxxnt; ++i) {
    cout << i << " " << NtPxPois[i] << " " << NtPxPCR[i]
	 << " " << AaPxPois[i] << " " << AaPxPCR[i] << "<br>\n";
  }
  */
  // Since NtPx -> AaPx is just a redistribution of probabilities, their sums
  //   should be unchanged. -> Checked for the Volles case - each of the four
  //   matrices sum up to 0.851+-0.0005.

  //---------------------------------------------------------------------------

  // Calculate 'exact' Poisson P0, P1 and P2 sums.  We need these to
  //   renormalize the p_ik below (in order to use them with the PCR and
  //   Poisson L0, L1 and L2 to calculate PCR and Poisson 'exact' C0, C1 and
  //   C2).  We can also use them to calculate Poisson 'exact' L0, L1 and L2
  //   as a check that the method of summing binomial distributions is OK (see
  //   below).

  P0exact = p0;
  P1exact = P2exact = 0;
  for (i = 0; i < 64; ++i) {
    if (99 != aa2aa[i]) {
      for (k = 0; k < 20; ++k) {
        if (k != aa2aa[i]) { // A non-synonymous non-stop mutation
          p_ik = p0 * aaprobs[i][k] / aaprobs[i][aa2aa[i]];
          P1exact += codoncount[i] * p_ik;
        }
      }
    }
  }
  for (i1 = 0; i1 < 64; ++i1) {
    if (99 != aa2aa[i1]) {
      for (i2 = 0; i2 < 64; ++i2) {
        if (99 != aa2aa[i2]) {
          for (k1 = 0; k1 < 20; ++k1) {
            if (k1 != aa2aa[i1]) { // A non-synonymous non-stop mutation
              for (k2 = 0; k2 < 20; ++k2) {
                if (k2 != aa2aa[i2]) { // A non-synonymous non-stop mutation
                  p_ik = p0 * aaprobs[i1][k1] / aaprobs[i1][aa2aa[i1]] *
                    aaprobs[i2][k2] / aaprobs[i2][aa2aa[i2]];
                  if (i1 != i2) {
                    P2exact += codoncount[i1] * codoncount[i2] * p_ik;
                  } else {
                    // To avoid both substitutions occurring in the same aa
                    P2exact += codoncount[i1] * (codoncount[i2] - 1) * p_ik;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  P2exact /= 2.; // I.e. divide by 2!, since each pair is counted twice.

  // For x = 0,1,2, Lxexact = Pxexact * L2.  For the Volles case I get:
  //          'exact'       'binomial sum'    error
  //  L0     3.727e+05        3.824e+05	       2.6%
  //  L1     8.076e+05        8.106e+05        0.4%
  //  L2     8.667e+05        8.592e+05        0.9%

  //---------------------------------------------------------------------------

  // Exact calculation of C0.
  nnoaamuts = 1. - exp(-p0 * L2 * AaPxPois[0] / P0exact);
  if (0 == distr) {
    nnoaamutsPCR = 1. - exp(-p0 * L2 * AaPxPCR[0] / P0exact);
  } else {
    nnoaamutsPCR = 0.;
  }

  //---------------------------------------------------------------------------

  // Note in the 'exact' calculations the correct formula is
  //   P(v_i in library) = 1 - (1 - p_i)^L  [or 1 - exp(L * log(1-p_i))]
  // but I actually use
  //   P(v_i in library) ~ 1 - exp(-L * p_i)
  // Provided p_i < 0.1, the results agree to within 5%.  In fact for the
  //   nsingleaamuts, ndoubleaamuts, and uniqptmuts calculations we should
  //   have p_i << 0.1 in all but the most bizarre situations.  For the default
  //   Volles case I tested nsingleaamuts and uniqptmuts both ways and the
  //   results are identical.  I prefer to stick with '1 - exp(-L * p_i)'
  //   because it gives slightly nicer results when sub-library sizes L1 or L2
  //   are less than unity (with '1 - exp(-L * p_i)', Cx may be slightly less
  //   than Lx, where as with  '1 - exp(-L * p_i)' it tends to be slightly
  //   greater than LX; the latter is nicer because, for example for L0, even
  //   if the mean L0 < 1, in some realizations of the library L0 may actually
  //   be > 1, but C0 can never be > 1, so the mean C0 may be slightly less
  //   than the mean L0.

  // The only time p_i might be > 0.1, is for the WT sequence (i.e. p0).
  //   But for realistic libraries, the difference for C0 really doesn't matter
  //   to anyone.

  //---------------------------------------------------------------------------

  // Calc prob of all daughters that differ from parent by exactly one aa (inc
  //   those that need > 1 nt mut), and hence calc the expected number of such
  //   variants in the library i.e. C1.
  // I reckon this (nsingleaamuts) is Volles2005 '# of unique single point
  //   mutants'.
  // The initial p_ik calculated below are the probability of the variant in
  //   the full (indel-free but not stop codon free) library L2.  The expected
  //   number of occurrences of the variant in the library is P_ik * L2.
  //   By renormalizing the p_ik by P1exact = Sum (p_ik|single non-stop aa
  //   mutant) we get the probability of the variant in the (stop codon free)
  //   sub-library L1.  Then to differentiate PCR from Poisson stats, we use
  //   L1Pois or L1PCR as appropriate.
  nsingleaamuts = nsingleaamutsPCR = 0;
  for (i = 0; i < 64; ++i) {
    if (99 != aa2aa[i]) {
      for (k = 0; k < 20; ++k) {
        if (k != aa2aa[i]) { // A non-synonymous non-stop mutation
          p_ik = p0 * aaprobs[i][k] / aaprobs[i][aa2aa[i]];
          p_ik /= P1exact;
          nsingleaamuts += codoncount[i] * (1 - exp(-p_ik * L2 * AaPxPois[1]));
          // Actual formula is
          //   nsingleaamuts += codoncount[i]
          //     * (1 - pow(1.-p_ik,L2*AaPxPois[1]));
          // or
          //   nsingleaamuts += codoncount[i]
          //     * (1 - exp(L2*AaPxPois[1]*log(1.-p_ik)));
          // See note above.
          if (0 == distr) {
            nsingleaamutsPCR += codoncount[i] *
              (1 - exp(-p_ik * L2 * AaPxPCR[1]));
          }
        }
      }
    }
  }

  //---------------------------------------------------------------------------

  // Exact calculation for C2
  ndoubleaamuts = ndoubleaamutsPCR = 0;
  for (i1 = 0; i1 < 64; ++i1) {
    if (99 != aa2aa[i1]) {
      for (i2 = 0; i2 < 64; ++i2) {
        if (99 != aa2aa[i2]) {
          for (k1 = 0; k1 < 20; ++k1) {
            if (k1 != aa2aa[i1]) { // A non-synonymous non-stop mutation
              for (k2 = 0; k2 < 20; ++k2) {
                if (k2 != aa2aa[i2]) { // A non-synonymous non-stop mutation
                  p_ik = p0 * aaprobs[i1][k1] / aaprobs[i1][aa2aa[i1]] *
                    aaprobs[i2][k2] / aaprobs[i2][aa2aa[i2]];
                  p_ik /= P2exact;
                  if (i1 != i2) {
                    ndoubleaamuts += codoncount[i1] * codoncount[i2] *
                      (1 - exp(-p_ik * L2 * AaPxPois[2]));
                  } else {
                    // To avoid both substitutions occurring in the same aa
                    ndoubleaamuts += codoncount[i1] * (codoncount[i2] - 1) *
                      (1 - exp(-p_ik * L2 * AaPxPois[2]));
                  }
                  if (0 == distr) {
                    if (i1 != i2) {
                      ndoubleaamutsPCR += codoncount[i1] * codoncount[i2] *
                        (1 - exp(-p_ik * L2 * AaPxPCR[2]));
                    } else {
                      ndoubleaamutsPCR += codoncount[i1] * (codoncount[i2] - 1) *
                        (1 - exp(-p_ik * L2 * AaPxPCR[2]));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ndoubleaamuts /= 2.; // I.e. divide by 2!, since each pair is counted twice.
  if (0 == distr) {
    ndoubleaamutsPCR /= 2.;
  }

  //---------------------------------------------------------------------------

  // Exact calculation for C3 (takes too long; NB scales as 64x64x64, indept
  //   of actual sequence length).
  /*
  P3exact = 0;
  for (i1 = 0; i1 < 64; ++i1) {
  if (99 != aa2aa[i1]) {
    for (i2 = 0; i2 < 64; ++i2) {
    if (99 != aa2aa[i2]) {
      for (i3 = 0; i3 < 64; ++i3) {
      if (99 != aa2aa[i3]) {
	for (k1 = 0; k1 < 20; ++k1) {
	  if (k1 != aa2aa[i1]) {  // A non-synonymous non-stop mutation
	    for (k2 = 0; k2 < 20; ++k2) {
	      if (k2 != aa2aa[i2]) {  // A non-synonymous non-stop mutation
		for (k3 = 0; k3 < 20; ++k3) {
		  if (k3 != aa2aa[i3]) {  // A non-synonymous non-stop mutation
		    p_ik = p0 * aaprobs[i1][k1] / aaprobs[i1][aa2aa[i1]]
		      * aaprobs[i2][k2] / aaprobs[i2][aa2aa[i2]]
		      * aaprobs[i3][k3] / aaprobs[i3][aa2aa[i3]];
		    if (i1 != i2 && i1 != i3 && i2 != i3) {
		      P3exact += codoncount[i1] * codoncount[i2]
			* codoncount[i3] * p_ik;
		    } else if (i1 != i2) {
		      P3exact += codoncount[i1] * codoncount[i2]
			* (codoncount[i3] - 1) * p_ik;
		    } else if (i1 != i3) {
		      P3exact += codoncount[i1] * (codoncount[i2] - 1)
			* codoncount[i3] * p_ik;
		    } else if (i2 != i3) {
		      P3exact += (codoncount[i1] - 1) * codoncount[i2]
			* codoncount[i3] * p_ik;
		    } else if (i1 == i2 && i1 == i3) {
		      P3exact += codoncount[i1] * (codoncount[i2] - 1)
			* (codoncount[i3] - 2) * p_ik;
		    } else {
		      cout << "Can't get here.<br>\n";
		      exit(EXIT_FAILURE);
		    }
		  }
		}
	      }
	    }
	  }
	}
	cout << i1 << " " << i2 << " " << i3 << "<br>\n";
      }
      }
    }
    }
  }
  }
  P3exact /= 6.; // I.e. divide by 3!, since each triple is counted 3! x
  cout << "P3exact = " << P3exact << "<br>\n";

  ntripleaamuts = ntripleaamutsPCR = 0;
  for (i1 = 0; i1 < 64; ++i1) {
  if (99 != aa2aa[i1]) {
    for (i2 = 0; i2 < 64; ++i2) {
    if (99 != aa2aa[i2]) {
      for (i3 = 0; i3 < 64; ++i3) {
      if (99 != aa2aa[i3]) {
	for (k1 = 0; k1 < 20; ++k1) {
	  if (k1 != aa2aa[i1]) {  // A non-synonymous non-stop mutation
	    for (k2 = 0; k2 < 20; ++k2) {
	      if (k2 != aa2aa[i2]) {  // A non-synonymous non-stop mutation
		for (k3 = 0; k3 < 20; ++k3) {
		  if (k3 != aa2aa[i3]) {  // A non-synonymous non-stop mutation
		    p_ik = p0 * aaprobs[i1][k1] / aaprobs[i1][aa2aa[i1]]
		      * aaprobs[i2][k2] / aaprobs[i2][aa2aa[i2]]
		      * aaprobs[i3][k3] / aaprobs[i3][aa2aa[i3]];
		    p_ik /= P3exact;
		    if (i1 != i2 && i1 != i3 && i2 != i3) {
		      ntripleaamuts += codoncount[i1] * codoncount[i2]
			* codoncount[i3]
			* (1 - exp(- p_ik * L2 * AaPxPois[3]));
		    } else if (i1 != i2) {
		      ntripleaamuts += codoncount[i1] * codoncount[i2]
			* (codoncount[i3] - 1)
			* (1 - exp(- p_ik * L2 * AaPxPois[3]));
		    } else if (i1 != i3) {
		      ntripleaamuts += codoncount[i1] * (codoncount[i2] - 1)
			* codoncount[i3]
			* (1 - exp(- p_ik * L2 * AaPxPois[3]));
		    } else if (i2 != i3) {
		      ntripleaamuts += (codoncount[i1] - 1) * codoncount[i2]
			* codoncount[i3]
			* (1 - exp(- p_ik * L2 * AaPxPois[3]));
		    } else if (i1 == i2 && i1 == i3) {
		      ntripleaamuts += codoncount[i1] * (codoncount[i2] - 1)
			* (codoncount[i3] - 2)
			* (1 - exp(- p_ik * L2 * AaPxPois[3]));
		    } else {
		      cout << "Can't get here.<br>\n";
		      exit(EXIT_FAILURE);
		    }
		    if (0 == distr) {
		      if (i1 != i2 && i1 != i3 && i2 != i3) {
			ntripleaamutsPCR += codoncount[i1]
			  * codoncount[i2] * codoncount[i3]
			  * (1 - exp(- p_ik * L2 * AaPxPCR[3]));
		      } else if (i1 != i2) {
			ntripleaamutsPCR += codoncount[i1]
			  * codoncount[i2] * (codoncount[i3] - 1)
			  * (1 - exp(- p_ik * L2 * AaPxPCR[3]));
		      } else if (i1 != i3) {
			ntripleaamutsPCR += codoncount[i1]
			  * (codoncount[i2] - 1) * codoncount[i3]
			  * (1 - exp(- p_ik * L2 * AaPxPCR[3]));
		      } else if (i2 != i3) {
			ntripleaamutsPCR += (codoncount[i1] - 1)
			  * codoncount[i2] * codoncount[i3]
			  * (1 - exp(- p_ik * L2 * AaPxPCR[3]));
		      } else if (i1 == i2 && i1 == i3) {
			ntripleaamutsPCR += codoncount[i1]
			  * (codoncount[i2] - 1) * (codoncount[i3] - 2)
			  * (1 - exp(- p_ik * L2 * AaPxPCR[3]));
		      } else {
			cout << "Can't get here.<br>\n";
			exit(EXIT_FAILURE);
		      }
		    }
		  }
		}
	      }
	    }
	  }
	}
	cout << i1 << " " << i2 << " " << i3 << "<br>\n";
      }
      }
    }
    }
  }
  }
  ntripleaamuts /= 6.; // I.e. divide by 3!, since each triple is counted 3! x
  if (0 == distr) {
    ntripleaamutsPCR /= 6.;
  }
  cout << "ntripleaamuts: " << ntripleaamuts << " " << ntripleaamutsPCR
       << "<br>\n";
  */

  //---------------------------------------------------------------------------

  // Also calculate expected number of distinct amino acid substitutions in the
  //   library regardless of  what the rest of the daughter sequence is like.
  // Just calc prob P of each of the Ncodons x 19 aa point mutations,
  //   regardless of the rest of the seq, and use 1-exp(-P*L) stats.
  // Here the distribution of the library amongst the sub-libraries (i.e.
  //   Poisson v PCR distributions) is not really relevant, so don't worry
  //   about trying to calculate a separate PCR statistic.
  uniqptmuts = 0.;
  for (i = 0; i < 64; i += 1) {
    if (99 != aa2aa[i]) {
      i1 = int(i / 16);
      i2 = int((i - 16 * i1) / 4);
      i3 = i - 16 * i1 - 4 * i2;
      for (k = 0; k < 20; ++k) {
        if (k != aa2aa[i]) { // A non-synonymous non-stop mutation
          p_ik = aaprobs[i][k];
          //	  uniqptmuts += codoncount[i] * (1. - exp(- p_ik * L2));
          uniqptmuts += codoncount[i] * (1. - exp(-p_ik * L1));
          // Use L1 because we are only interested in those uniqptmuts that
          //   occur in non-truncated sequences.
          //  uniqptmuts += codoncount[i] * (1. - pow(1-p_ik,L1));
        }
      }
    }
  }
  // I reckon this is Volles2005 '# of unique point mutations'.

  //---------------------------------------------------------------------------

  // Calculate pedel-type stats.  (Cf stats.batch.cxx.)

  // Library size for aa library stats.  The AaPx values have been reduced to
  //   exclude the estimated number of variants with stop codons, as a function
  //   of x.  Thus we use L2 = library * pnoinsert * pnodelete as the library
  //   size here.  Recall that Sum AaPx = probnostops[(nseq/3)-1] = L1/L2,
  //   so Sum Lx will be L2 * Sum AaPx = L2 * L1/L2 = L1, the reported
  //   'effective library size'.

  for (i = 0; i < maxx0 + 1; ++i) {
    Vx1[i] = Vx2[i] = 0;
    LxPois[i] = LxPCR[i] = CxPois[i] = CxPCR[i] = 0.;
    CxExactPois[i] = CxExactPCR[i] = 0.;
    CxCombPois[i] = CxCombPCR[i] = LxCxCombPois[i] = LxCxCombPCR[i] = 0.;
  }
  CtotalCombPois = CtotalCombPCR = CtotalPois = CtotalPCR = 0.;
  CxExactPois[0] = CxCombPois[0] = nnoaamuts;
  CxExactPois[1] = CxCombPois[1] = nsingleaamuts;
  CxExactPois[2] = CxCombPois[2] = ndoubleaamuts;
  CxExactPCR[0] = CxCombPCR[0] = nnoaamutsPCR;
  CxExactPCR[1] = CxCombPCR[1] = nsingleaamutsPCR;
  CxExactPCR[2] = CxCombPCR[2] = ndoubleaamutsPCR;

  // x = 0 stats
  Vx1[0] = Vx2[0] = 1.;
  // Poisson
  LxPois[0] = L2 * AaPxPois[0];
  if (LxPois[0] < 1.) {
    CxPois[0] = LxPois[0];
  } else {
    CxPois[0] = 1.;
  }
  CtotalPois += CxPois[0];
  CtotalCombPois += CxCombPois[0];
  LxCxCombPois[0] = LxPois[0] - CxCombPois[0];
  if (LxCxCombPois[0] < 0.) {
    LxCxCombPois[0] = 0.;
  }
  // PCR
  if (0 == distr) {
    LxPCR[0] = L2 * AaPxPCR[0];
    if (LxPCR[0] < 1.) {
      CxPCR[0] = LxPCR[0];
    } else {
      CxPCR[0] = 1.;
    }
    CtotalPCR += CxPCR[0];
    CtotalCombPCR += CxCombPCR[0];
    LxCxCombPCR[0] = LxPCR[0] - CxCombPCR[0];
    if (LxCxCombPCR[0] < 0.) {
      LxCxCombPCR[0] = 0.;
    }
  }

  // x = 1,2,...,min(nseq/3,20).
  xfac = 1.;
  nfac = 1.;
  longseq = 1;
  maxx = maxx0;
  if (maxx >= nseq / 3) {
    maxx = nseq / 3;
    longseq = 0;
  }
  for (i = 1; i <= maxx; ++i) {
    xfac *= float(i);
    nfac *= float((nseq / 3) - i + 1);
    Vx1[i] = pow(Afactor, i) * nfac / xfac;
    Vx2[i] = pow(19., i) * nfac / xfac;
    // Poisson
    LxPois[i] = L2 * AaPxPois[i];
    if (LxPois[i] / Vx1[i] > 0.1) {
      CxPois[i] = Vx1[i] * (1. - exp(-LxPois[i] / Vx1[i]));
    } else {
      CxPois[i] = LxPois[i];
    }
    CtotalPois += CxPois[i];
    if (i > 2) {
      CxCombPois[i] = CxPois[i];
      if (LxPois[i] / Vx1[i] > 0.1) {
        CxExactPois[i] = -1.; // Flag to output warning to the table
      }
    }
    CtotalCombPois += CxCombPois[i];
    LxCxCombPois[i] = LxPois[i] - CxCombPois[i];
    if (LxCxCombPois[i] < 0.) {
      LxCxCombPois[i] = 0.;
    }
    // PCR
    if (0 == distr) {
      LxPCR[i] = L2 * AaPxPCR[i];
      if (LxPCR[i] / Vx1[i] > 0.1) {
        CxPCR[i] = Vx1[i] * (1. - exp(-LxPCR[i] / Vx1[i]));
      } else {
        CxPCR[i] = LxPCR[i];
      }
      CtotalPCR += CxPCR[i];
      if (i > 2) {
        CxCombPCR[i] = CxPCR[i];
        if (LxPCR[i] / Vx1[i] > 0.1) {
          CxExactPCR[i] = -1.; // Flag to output warning to the table
        }
      }
      CtotalCombPCR += CxCombPCR[i];
      LxCxCombPCR[i] = LxPCR[i] - CxCombPCR[i];
      if (LxCxCombPCR[i] < 0.) {
        LxCxCombPCR[i] = 0.;
      }
    }
  }

  // x > maxx:
  // If maxx < maxx0 (i.e. maxx = nseq/3 < maxx0), then Pleftover is already
  //   incorporated into NtPx[nseq] and hence into AaPx[].
  // If maxx = maxx0 then either 3*maxx0 < nseq <= maxx0nt (in which case
  //   Pleftover is already incorporated into NtPx[nseq]) or else nseq >
  //   maxx0nt (in which case Pleftover has been discarded).
  // Whichever, the AaPx values won't add to 1.  Instead Sum Lx = L2 * Sum AaPx
  //   = L2 * L1/L2 = L1, the reported 'effective library size'.
  //-> So iff maxx = maxx0 then set Pleftover = Sum_maxx0+1^maxxnt AaPx, again
  //  ignoring any (miniscule) component for x > maxx0nt.
  //-> Also only do Pleftover if Lx[maxx0]/Vx1[maxx0] <= 0.1 so you're in the
  //  Cx ~ Lx regime.  Else you print out a warning.
  PleftoverPois = PleftoverPCR = 0;
  if (1 == longseq) {
    // Poisson
    if (LxPois[maxx] / Vx1[maxx] <= 0.1) {
      for (i = 21; i <= maxxnt; ++i) {
        PleftoverPois += AaPxPois[i];
      }
      if (PleftoverPois < 0.) {
        PleftoverPois = 0.;
      }
      CtotalCombPois += L2 * PleftoverPois;
      CtotalPois += L2 * PleftoverPois;
    }
    // PCR
    if (0 == distr) {
      if (LxPCR[maxx] / Vx1[maxx] <= 0.1) {
        for (i = 21; i <= maxxnt; ++i) {
          PleftoverPCR += AaPxPCR[i];
        }
        if (PleftoverPCR < 0.) {
          PleftoverPCR = 0.;
        }
        CtotalCombPCR += L2 * PleftoverPCR;
        CtotalPCR += L2 * PleftoverPCR;
      }
    }
  }

  //---------------------------------------------------------------------------

  // More rigorous version of the 'Lx < 0.1 Vx' criterion for the Cx ~ Lx
  //   approximation: viz that the mean probability of the most probable
  //   variant in Vx should be < 0.1.

  // It doesn't matter what the probability of the rarest variants is.  What
  //   matters for the 'Lx < 0.1 Vx' condition is that the mean frequency of
  //   the most common variant in Vx is <= 0.1.

  // Add a new stat to sub-library table - Rx{Pois,PCR} = mean frequency of
  //   the most common variant in Vx.
  // First need to find the maxx most probable non-synonymous amino acid
  //   substitutions in the input sequence, with the proviso that no more than
  //   one can be at any one codon position.  Order these by probability.  Then
  //   can calculate the probabilities P(v^x_c) of the most common variants
  //   v^x_c with x = 0,1,2,...,maxx amino acid substitutions.
  // For x > 2, you don't have Pxexact, so you can't remormalize the P(v^x_c)
  //   relative to the sub-library Lx.  Instead, since these probs are based on
  //   the original nuc matrix, the final probabilities will be relative to the
  //   full (including truncations but indel-free) library L2.  This should be
  //   OK for Poisson but it is certainly not OK for PCR.  Previously confirmed
  //   the former for the Volles case - showing that for x = 0, 1 and 2, the
  //   'binomial sum' LxPois agreed with Pxexact * L2 - at least to within
  //   2.6%.  Thus we can approximate Pxexact by Pxexact ~ LxPois/L2.  Using
  //   this to normalized P(v^x_c) we get
  //     RxPois = P(v^x_c) / Pxexact * LxPois
  //            = P(v^x_c) / LxPois * L2 * LxPois
  //            = P(v^x_c) * L2   (as stated above for the Poisson case), and
  //     RxPCR  = P(v^x_c) / Pxexact * LxPCR
  //            = P(v^x_c) / LxPois * L2 * LxPCR
  //            = P(v^x_c) * L2 * LxPCR / LxPois.

  // Calculate RxPois and RxPCR
  for (i = 0; i < maxx0 + 1; ++i) {
    RxPois[i] = RxPCR[i] = maxProbs[i] = 0.;
  }

  // Find the maxx most probable non-synonymous amino acid substitutions,
  //   with the proviso that no more than one can be at any one codon position.

  // Step through sequence.
  for (codon = 0; codon < nseq / 3; codon += 1) { // Assumed no stop codons
    i1 = seq[3 * codon];
    i2 = seq[3 * codon + 1];
    i3 = seq[3 * codon + 2];
    i = 16 * i1 + 4 * i2 + i3;
    // Of the 19 possible non-synonymous non-stop amino acid substitutions at
    //   this site, find the most probable.
    maxP = 0;
    for (k = 0; k < 20; ++k) {
      if (k != aa2aa[i]) { // A non-synonymous non-stop mutation
        // The number we actually want is P(codon_i -> aa_j)/P(codon_i ->
        //   aa_i).  Then we just need to multiply the final product of the
        //   x highest codon probabilities by p0 to get P(v^x_c).
        p_ik = aaprobs[i][k] / aaprobs[i][aa2aa[i]];
        if (p_ik > maxP) {
          maxP = p_ik;
        }
      }
    }
    // If maxP is greater than any one of the probs in maxProbs[0,...,maxx]
    //   then insert maxP into maxProbs[] and drop the last value off
    //   maxProbs[] (keep maxProbs[] in descending order to facilitate this).
    for (k = 0; k < maxx; ++k) {
      if (maxP > maxProbs[k]) {
        for (j = maxx - 1; j > k; --j) {
          maxProbs[j] = maxProbs[j - 1];
        }
        maxProbs[k] = maxP;
        break;
      }
    }
  }
  // p0 * maxProbs[0] is P(v^x_c) for the most probable non-synonymous amino
  //  acid mutation, and so on.

  Pc[0] = p0;
  for (i = 1; i <= maxx; ++i) {
    Pc[i] = Pc[i - 1] * maxProbs[i - 1];
  }

  for (i = 0; i <= maxx; ++i) {
    RxPois[i] = Pc[i] * L2;
    RxPCR[i] = Pc[i] * L2 * LxPCR[i] / LxPois[i];
  }

  // To avoid going into details of the approximations, reset Rx[0] to equal
  //   Lx[0].  (e.g. in Volles case they already agree to within 2.6%).
  RxPois[0] = LxPois[0];
  RxPCR[0] = LxPCR[0];

  //---------------------------------------------------------------------------

  // Write out table
  ofstream libtable(libtable_file);
  if (!libtable) {
    cout << "Aborting: can't open output file '" << libtable << "'.<br>\n";
    exit(EXIT_FAILURE);
  }
  libtable << setprecision(4);

  libtable << "<html><head>\n" <<
    "<title>PEDEL-AA - sub-library statistics</title>\n" <<
    "</head><body>\n";

  libtable << "<br><b>Sub-library statistics:</b><br>\n";

  libtable << "<ul>" <<
    "<li><i>x</i> = number of non-synonymous amino acid" <<
    " substitutions per variant." <<
    "<li><i>Vx</i>_1 = approximate number of possible sequences with" <<
    " exactly <i>x</i> amino acid substitutions, each accessible by" <<
    " just one nucleotide substitution per codon." <<
    "<li><i>Vx</i>_2 = total number of possible sequences with" <<
    " exactly <i>x</i> amino acid substitutions (i.e. allowing 1, 2" <<
    " or 3 nucleotide substitutions per codon)." <<
    "<li><i>Rx</i> = mean frequency of the most common variant in" <<
    " the sub-library." <<
    "<li><i>Lx</i> = expected number of sequences in the" <<
    " sub-library." <<
    "<li><i>Cx</i> = approximate expected number of distinct amino" <<
    " acid sequences in the sub-library." <<
    "<li><i>Lx - Cx</i> = number of redundant sequences in the " <<
    "sub-library." <<
    "</ul>";

  if (L1 < 10.) {
    libtable << "Warning: Library size very small. " <<
      "Statistics may be compromised.<br>\n";
  }
  if (nseq / 3 < 10) {
    libtable << "Warning: Sequence length very small.  " <<
      "Statistics may be compromised.<br>\n";
  }
  if (nsubst > 0.1 * float(nseq)) {
    libtable << "Warning: Mutation rate is high.  " <<
      "Statistics may be compromised.<br>\n";
  }
  libtable << "<br>\n";

  libtable << "<table class=\"table table-striped\">\n";
  libtable << "<tr><th align=\"center\">x</th>\n" <<
    "<th align=\"center\">Vx_1</th>\n" <<
    "<th align=\"center\">Vx_2</th>\n" <<
    "<th align=\"center\">Rx</th>\n" <<
    "<th align=\"center\">Lx</th>\n" <<
    "<th align=\"center\">Cx</th>\n" <<
    "<th align=\"center\">Notes</th>\n" <<
    "<th align=\"center\">Lx - Cx</th></tr>\n";

  Poiswarning = PCRwarning = 0;

  for (i = 0; i <= maxx; ++i) {
    libtable << "<tr align=\"right\"><td>" << i <<
      "</td><td>" << Vx1[i] << "</td><td>" << Vx2[i] <<
      "</td><td>";
    if (i > 2) {
      if (-1 == CxExactPois[i]) {
        libtable << RxPois[i] << "</td><td>" <<
          LxPois[i] << "</td><td>" << CxCombPois[i] << "</td><td>" <<
          "<a href=/aef/STATS/FORM/pedel-AA_warning.html>warning</a>" <<
          "</td><td>" << LxCxCombPois[i] << "</td></tr>\n";
        Poiswarning = 1;
      } else {
        if (RxPois[i] < 0.1) {
          libtable << RxPois[i] << "</td><td>" <<
            LxPois[i] << "</td><td>" << CxCombPois[i] << "</td><td>" <<
            "<a href=/aef/STATS/FORM/pedel-AA_CxLx.html>Cx ~ Lx</a>" <<
            "</td><td>" << LxCxCombPois[i] << "</td></tr>\n";
        } else {
          libtable << RxPois[i] << "</td><td>" <<
            LxPois[i] << "</td><td>" << CxCombPois[i] << "</td><td>" <<
            "<a href=/aef/STATS/FORM/pedel-AA_warningRx.html>" <<
            "Rx warning</a></td><td>" << LxCxCombPois[i] <<
            "</td></tr>\n";
        }
      }
    } else {
      libtable << RxPois[i] << "</td><td>" <<
        LxPois[i] << "</td><td>" << CxCombPois[i] << "</td><td>" <<
        "<a href=/aef/STATS/FORM/pedel-AA_exact.html>Exact</a>" <<
        "</td><td>" << LxCxCombPois[i] << "</td></tr>\n";
    }
  }

  if (1 == longseq) {
    if (LxPois[maxx] / Vx1[maxx] <= 0.1 ||
      (0 == distr && LxPCR[maxx] / Vx1[maxx] <= 0.1)) {
      libtable << "<tr align=\"right\"><td>>" << maxx << "</td><td>" <<
        "-" << "</td><td>" << "-</td>";
      if (LxPois[maxx] / Vx1[maxx] <= 0.1) {
        libtable << "<td>-</td><td>" << L2 * PleftoverPois <<
          "</td><td>" << L2 * PleftoverPois << "</td><td>" <<
          "<a href=/aef/STATS/FORM/pedel-AA_CxLx.html>Cx ~ Lx</a>" <<
          "</td><td>" << "0</td>";
      } else {
        libtable << "<td>-</td><td>-</td><td>-</td><td>-</td><td>-</td>";
      }
      libtable << "</tr>\n";
    }
  }

  libtable << "<tr align=\"right\"><td><b>Totals</b></td><td></td><td></td>" <<
    "<td></td><td></td><td><b>" << CtotalCombPois <<
    "</b></td><td></td><td></td>";
  libtable << "</tr>\n";
  libtable << "</table><br>\n";
  libtable << "</body></html>\n";

  libtable.close();

  //---------------------------------------------------------------------------

  // Write out results

  // Summary table
  cout << "<br><b>Summary of library characteristics:</b>\n";
  cout << "<table cellspacing=\"0\" cellpadding=\"3\" border=\"1\">\n";
  cout << "<tr><th align=\"left\">Property</th>\n" <<
    "<th align=\"center\">Estimate</th></tr>\n";
  cout << "<tr><td>Total library size</td><td>" << library << "</td></tr>\n";
  cout << "<tr><td>Number of variants with no indels or stop codons</td><td>" <<
    L1 << "</td></tr>\n";
  cout << "<tr><td>Mean number of amino acid substitutions per variant</td>" <<
    "<td>" << sumnonsynprob << "</td></tr>\n";
  if (0 == distr) {
    cout << "<tr><td>Unmutated (wild-type) sequences (% of library; " <<
      "PCR est.)</td><td>" <<
      100. * LxPCR[0] / library << "%</td></tr>\n";
  } else {
    cout << "<tr><td>Unmutated (wild-type) sequences (% of library; " <<
      "Poisson est.)</td><td>" <<
      100. * LxPois[0] / library << "%</td></tr>\n";
  }
  if ((0 == longseq || LxPois[maxx] / Vx1[maxx] <= 0.1) && 0 == Poiswarning) {
    cout << "<tr><td>Number of distinct full-length proteins in the library" <<
      " (Poisson est.)</td><td>" << CtotalCombPois << "</td></tr>\n";
  } else {
    cout << "<tr><td>Number of distinct full-length proteins in the library" <<
      " (Poisson est.)</td><td>(see below)</td></tr>\n";
  }
  if (0 == distr) {
    if ((0 == longseq || LxPCR[maxx] / Vx1[maxx] <= 0.1) && 0 == PCRwarning) {
      cout << "<tr><td>Number of distinct full-length proteins in the library" <<
        " (PCR est.)</td><td>" << CtotalCombPCR << "</td></tr>\n";
    } else {
      cout << "<tr><td>Number of distinct full-length proteins in the library" <<
        " (PCR est.)</td><td>(see below)</td></tr>\n";
    }
  }
  cout << "</table><br>\n";

  // Indels
  cout << "<br><b>Indels:</b><br>\n";
  cout << "Library size: " << library << "<br>\n";
  cout << "Fraction of the library with one or more insertions: " <<
    (1 - pnoinsert) << "<br>\n";
  cout << "Fraction of the library with one or more deletions: " <<
    (1 - pnodelete) << "<br>\n";
  cout << "Number of sequence variants with no indels: " << L2 << "<br>\n";

  // Sequences with no indels
  cout << "<br><b>For sequences with no indels:</b><br>\n";
  cout << "Mean number of stop codons per variant: " <<
    sumstopprob << "<br>\n";
  cout << "Mean number of unchanged codons per variant: " <<
    sumnullprob << "<br>\n";
  cout << "Mean number of synonymous amino acid " <<
    "substitutions per variant: " << sumsynprob << "<br>\n";
  cout << "Mean number of nonsynonymous (non-stop codon) amino acid " <<
    "substitutions per variant: " << sumnonsynprob << "<br>\n";
  cout << "Fraction of indel-free variants with no introduced stop codons: " <<
    probnostops[(nseq / 3) - 1] << "<br>\n";
  cout << "Number of variants with no indels and no introduced " <<
    "stop codons: " << L1 << "<br>\n";

  // No indels or stop codons
  cout << "<br><b>Approximate statistics for sequences " <<
    "with no indels and no introduced stop codons:</b><br>\n";
  cout << "Effective library size, L = " << L1 << "<br>\n";
  cout << "Mean number of non-synonymous amino acid substitutions accessible " <<
    "by a single nucleotide substitution, A = " << Afactor << "<br>\n";
  cout << "Expected number of distinct variants in the library that differ " <<
    "from the parent by a single amino acid (Poisson) = " <<
    nsingleaamuts << "<br>\n";
  if (0 == distr) {
    cout << "Expected number of distinct variants in the library that differ " <<
      "from the parent by a single amino acid (PCR) = " <<
      nsingleaamutsPCR << "<br>\n";
  }
  cout << "Expected total number of distinct amino acid substitutions present " <<
    "in at least one sequence in the library = " << uniqptmuts <<
    "<br>\n";

  // BTW - For the given limits, it looks like it may be impossible not to be
  //   in the Lx ~ Cx regime by x = 20.

  // Total distinct variants
  // Poisson
  if (1 == longseq) {
    if (LxPois[maxx] / Vx1[maxx] <= 0.1) {
      cout << "Estimated total number of distinct amino acid variants in the " <<
        "library (Poisson), <b>C = " << CtotalCombPois << "</b>.\n";
      if (Poiswarning) {
        cout << " (Warning: some <a href=" << newurl <<
          "/pedel-AA-table.html>sub-library statistics</a>" <<
          " for this library are inaccurate.)";
      }
      cout << "<br>\n";
    } else {
      cout << "Warning: Poisson estimation of total number of distinct amino " <<
        "acid variants in the library, C = Sum_{0,1,2,...} Cx, omitted " <<
        "because failed to reach the Cx ~ Lx regime by x = " << maxx <<
        ".  C may be dominated by contributions from x > " << maxx <<
        ".  See link to table, below.<br>\n";
    }
  } else {
    cout << "Estimated total number of distinct amino acid variants in the " <<
      "library (Poisson), <b>C = " << CtotalCombPois << "</b>.\n";
    if (Poiswarning) {
      cout << " (Warning: some <a href=" << newurl <<
        "/pedel-AA-table.html>sub-library statistics</a>" <<
        " for this library are inaccurate.)";
    }
    cout << "<br>\n";
  }
  // PCR
  if (0 == distr) {
    if (1 == longseq) {
      if (LxPCR[maxx] / Vx1[maxx] <= 0.1) {
        cout << "Estimated total number of distinct amino acid variants in the " <<
          "library (PCR), <b>C = " << CtotalCombPCR << "</b>.\n";
        if (PCRwarning) {
          cout << " (Warning: some <a href=" << newurl <<
            "/pedel-AA-table.html>sub-library statistics</a>" <<
            " for this library are inaccurate.)";
        }
        cout << "<br>\n";
      } else {
        cout << "Warning: PCR estimation of total number of distinct amino " <<
          "acid variants in the library, C = Sum_{0,1,2,...} Cx, omitted " <<
          "because failed to reach the Cx ~ Lx regime by x = " << maxx <<
          ".  C may be dominated by contributions from x > " << maxx <<
          ".  See link to table, below.<br>\n";
      }
    } else {
      cout << "Estimated total number of distinct amino acid variants in the " <<
        "library (PCR), <b>C = " << CtotalCombPCR << "</b>.\n";
      if (PCRwarning) {
        cout << " (Warning: some <a href=" << newurl <<
          "/pedel-AA-table.html>sub-library statistics</a>" <<
          " for this library are inaccurate.)";
      }
      cout << "<br>\n";
    }
  } else {
    cout << "PCR distribution statistics not requested.<br>\n";
  }

  // Links
  cout << "<br><b>Links to further information about this library:</b><br>\n";
  cout << "Normalized and scaled <a href=" << newurl <<
    "/pedel-AA-matrix.html>nucleotide matrix</a>.<br>\n";
  cout << "<a href=" << newurl <<
    "/pedel-AA-table.html>Table</a> of sub-library compositions.<br>\n";
  cout << "<a href=" << newurl <<
    "/pedel-AA-plots.html>Graphical</a> overview of truncated" <<
    " variant statistics.<br>\n";

  //---------------------------------------------------------------------------

  //Output seqstats.txt (one row per codon along the sequence)

  ofstream seqstats(seqstats_file);
  if (!seqstats) {
    cout << "Aborting: can't open output file '" << seqstats << "'.<br>\n";
    exit(EXIT_FAILURE);
  }

  // Write out statistics.
  for (codon = 0; codon < nseq / 3; codon += 1) {
    seqstats << codon + 1 << " " <<
      stopprobc[codon] << " " <<
      probnostops[codon] << " " <<
      firststop[codon] << "\n";
  }
  // Notes
  //   probnostops[codon] + Sum_{k=0,...,codon} firststop[k] = 1.

  seqstats.close();

  //---------------------------------------------------------------------------

}

//-----------------------------------------------------------------------------

double pcrprob(int pcrnmuts, double lambda, double ncycles, double eff)

{

  // Subroutine to calculate the probability for exactly x mutations, using
  //   the PCR probability distribution.

  int i, k;
  double Px, xx, comb, k0, n0, n1, n2, P1, P2;

  xx = lambda * (1. + eff) / (ncycles * eff);
  Px = 0;
  comb = 1;
  n0 = float(pcrnmuts);
  n1 = float(ncycles);
  n2 = 1.;
  P1 = 1;
  for (i = 1; i <= pcrnmuts; ++i) {
    P1 /= float(i);
  }
  P2 = 1.;
  for (k = 0; k <= ncycles; ++k) {
    k0 = float(k);
    Px += comb * P2 * pow(k0 * xx, n0) * exp(-k0 * xx) * P1;
    comb *= n1;
    comb /= n2;
    n1 -= 1.;
    n2 += 1.;
    P2 *= eff;
  }

  Px *= pow((1. + eff), -1. * ncycles);

  return (Px);

}

//-----------------------------------------------------------------------------