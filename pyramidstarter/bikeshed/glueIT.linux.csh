#!/bin/csh

set library = $1 
set id = $2

set ncodons = `sed 's/-/@/g' $id | grep -v "@" | wc -l | awk '{print $1}'`

echo $ncodons $library > $id.dat

#Note change '-'s to '@'s because '-'s aren't recognized by e.g. `if ($mN1 != 
#  "-" && ... ) then`.
@ count = 1
foreach codon (`sed 's/-/@/g' $id`)
  set mN1 = `echo $codon | sed 's/./& /g' | awk '{print $1}'`
  set mN2 = `echo $codon | sed 's/./& /g' | awk '{print $2}'`
  set mN3 = `echo $codon | sed 's/./& /g' | awk '{print $3}'`
  if ($mN1 != "@" && $mN2 != "@" && $mN3 != "@") then
    set sN1 = `awk -F: '{if ($1=="'"$mN1"'") print $2}' \
      pyramidstarter/bikeshed/ambignt.txt`
    set sN2 = `awk -F: '{if ($1=="'"$mN2"'") print $2}' \
      pyramidstarter/bikeshed/ambignt.txt`
    set sN3 = `awk -F: '{if ($1=="'"$mN3"'") print $2}' \
      pyramidstarter/bikeshed/ambignt.txt`
    echo "<b>Codon ${count}</b> ($codon): X = ${sN1}, Y = ${sN2}, Z = ${sN3}.<br>"

    set dat1 = \
      `awk '{print $1,$2}' pyramidstarter/bikeshed/aa2codon.dat | sed 'y/U/T/' | \
      sed 's/\([ACGT]\)\([ACGT]\)\([ACGT]\)/1\12\23\3/' | \
      sed 's/1['$sN1']/'$mN1'/g' | \
      sed 's/2['$sN2']/'$mN2'/g' | \
      sed 's/3['$sN3']/'$mN3'/g' | \
      grep ${mN1}${mN2}${mN3} | awk '{print $1}' | sort | uniq -c | \
      grep -v "*" | \
      awk '{print $1}' | sort -n | uniq -c | \
      awk -v OFS=":" '{print $1,$2}' | awk -v ORS="@" '{print $0}' | \
      sed 's/@$//'`

    @ c1 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="1") print $1}'`
    @ c2 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="2") print $1}'`
    @ c3 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="3") print $1}'`
    @ c4 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="4") print $1}'`
    @ c5 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="5") print $1}'`
    @ c6 = `echo $dat1 | sed 's/@/\n/g' | awk -F: '{if ($2=="6") print $1}'`

    #This count includes the stop codons - needed for the denominator in the 
    #  exp terms in glue1AAc.
    set ncodons = \
      `awk '{print $1,$2}' pyramidstarter/bikeshed/aa2codon.dat | sed 'y/U/T/' | \
      sed 's/\([ACGT]\)\([ACGT]\)\([ACGT]\)/1\12\23\3/' | \
      sed 's/1['$sN1']/'$mN1'/g' | \
      sed 's/2['$sN2']/'$mN2'/g' | \
      sed 's/3['$sN3']/'$mN3'/g' | \
      grep ${mN1}${mN2}${mN3} | wc -l | awk '{print $1}'`

    echo "$ncodons $c1 $c2 $c3 $c4 $c5 $c6" \
      >> $id.dat

  else
    echo "<b>Codon ${count}</b> (`echo $codon | sed 's/@/-/g'`): not used.<br>"
  endif
  @ count += 1
end

pyramidstarter/bikeshed/glueITc.linux $id.dat
