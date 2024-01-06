
if [ ! -f "studentCodes.env" ]; then
    wget https://skyloch.com/EKSClass/studentCodes.env > /dev/null 2>&1
fi
. ./studentCodes.env

# Setting hostname as variable to be passed to terraform, so cluster have unique names
export TF_VAR_hostname=$(hostname)

