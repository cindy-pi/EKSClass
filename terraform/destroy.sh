
cd 03-Deploy-nginx
time ./destroy.sh
cd ..

cd 02-Deploy-EKS
time ./destroy.sh
cd ..

cd 01-Hello-World
time ./destroy.sh
cd ..

#cd 02-Deploy-EKS
#time ./destroy.sh
#cd ..

#cd 03-Deploy-nginx
#time ./destroy.sh
#cd ..

