!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <max_number>"
    exit 1
fi

max_number=$1

for i in $(seq -w 1 $max_number)
do
  nohup ./destroyStudent.sh "$i" > destroyStudent-$i.log &
done

wait

grep eksclass-service destroy*.log

echo "Students 01 to $i, are destroyed."

rm *.json
rm *.log

