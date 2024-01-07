#!/bin/bash

cp ../02-Deploy-EKS/.kube .

# Assuming max_number is set
max_number=100

# Batch size
batch_size=10

# Loop through each batch
for (( batch_start=1; batch_start<=max_number; batch_start+=batch_size ))
do
    batch_end=$((batch_start+batch_size-1))

    # Loop through each student in the batch
    for i in $(seq -w $batch_start $batch_end)
    do
        if [ $i -le $max_number ]; then
            nohup ./destroyStudent.sh "$i" > destroyStudent-$i.log &
        fi
    done

    # Wait for the current batch to complete
    wait
    grep "Destroy completed" deployStudent*.log | sort -u
    echo "Batch $batch_start to $batch_end completed"
done



