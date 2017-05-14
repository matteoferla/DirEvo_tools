#!/bin/csh

@ argc = `echo $argv | awk '{print NF}'`
if ($argc != 6) then
  echo "Usage: 'pedel_mc_run nsims L N lambda seed approx'"
  echo ""
  echo "  nsims = requested number of simulated libraries"
  echo "  L = library size (max 100000)"
  echo "  N = sequence length (max 1000)"
  echo "  lambda = mean number of mutations per sequence"
  echo "  seed = random seed (positive integer)"
  echo "  approx = 1 -> truncate poisson tail to speed up simulation"
  echo "  approx = 0 -> do more accurate simulation"
  echo ""
  echo "E.g. 'pedel_mc_run 50 1000 100 4 343 0'"
  exit
endif

limit stacksize unlimited

if (! -r ./pedel_mc) then
  echo "Can't find software './pedel_mc'."
  exit 1
endif

set niter = $1
set L = $2
set N = $3
set lambda = $4
set iseed = $5
set approx = $6

rm -f mc.dat2 mc.dat3; touch mc.dat2 mc.dat3
@ j = 0
while ($j < $niter)
  @ j += 1
  @ iseed += 1
  if ("1" == $j) then
    ./pedel_mc $L $N $lambda $iseed $approx 1 || exit 1
    cp mc.dat library.dat
  else
    ./pedel_mc $L $N $lambda $iseed $approx 0 || exit 1
  endif
  echo `awk '{print $2}' mc.dat | sort | uniq -c | wc -l | \
    awk '{print $1}'` >> mc.dat2
  @ k = 0
  while ($k <= 20)
    echo -n `awk '{if ($1=="'"$k"'") print $2}' mc.dat | sort | uniq -c | \
      wc -l | awk '{print $1}'` " " >> mc.dat3
    @ k += 1
  end
  echo >> mc.dat3
end

echo "Number of iterations (libraries) = $niter."
set mean = `awk '{num+=1}{sum+=$1}END{print sum/num}' mc.dat2`
echo "Mean number of distinct sequences per library = $mean."
if ($j > 1) then
  set sigma = `awk '{num+=1}{sum+=$1}{ssq+=$1*$1}END{print sqrt((num/(num-1))*((ssq/num)-(sum/num)*(sum/num)))}' mc.dat2`
  echo "Standard deviation = $sigma."
endif

echo ""
@ k = 1
while ($k <= 21)
  set mean = `awk '{num+=1}{sum+=$"'"$k"'"}END{print sum/num}' mc.dat3`
  if ($j > 1) then 
    set sigma = `awk '{num+=1}{sum+=$"'"$k"'"}{ssq+=$"'"$k"'"*$"'"$k"'"}END{print sqrt((num/(num-1))*((ssq/num)-(sum/num)*(sum/num)))}' mc.dat3`
  else
    set sigma = "---"
  endif
  @ k1 = $k - 1
  echo "Mean number (stddev) of distinct sequences with exactly $k1 mutations = " $mean " ("$sigma")."
  @ k += 1
end

rm -f mc.dat mc.dat3
mv mc.dat2 ndistinct.dat
