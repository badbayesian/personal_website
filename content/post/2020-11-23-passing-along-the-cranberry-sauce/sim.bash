#!/bin/bash
rm report.txt
echo runtime model round thread >> report.txt

threads=(1 2 4 8)
rounds=(100 1000 10000 100000)
models=("python" "go")
size=20


for model in "${models[@]}"; do
	for thread in "${threads[@]}"; do
		for round in "${rounds[@]}"; do
			start=`date +%s.%N`
			if [[ "$model" == "python" ]]; then
				python sim_numba.py -size=$size -rounds=$round -threads=$thread
			else
				go run sim.go --size=$size --rounds=$round --threads=$thread
			fi
		end=`date +%s.%N`
		runtime=$( echo "$end - $start" | bc -l )
		echo $runtime $model $round $thread >> report.txt
	done
done
done
