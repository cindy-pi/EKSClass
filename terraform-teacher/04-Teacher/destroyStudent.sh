#!/bin/bash

cp ../02-Deploy-EKS/.kube .
export KUBECONFIG=./.kube

export studentNumber=$1

if ! kubectl get service eksclass-service-$studentNumber > /dev/null 2>&1; then
    echo "eksclass-service-$studentNumber is already Deleted"
    exit
fi
# Initialize the cname variable
cname=""

# Loop until the cname is retrieved
while [ -z "$cname" ]; do
    echo "Waiting for cname..."
    cname=$(kubectl get service eksclass-service-$studentNumber -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)

    # Check if the cname is still empty
    if [ -z "$cname" ]; then
        # Wait for a short period before trying again
        sleep 5
    else
        echo "CName found: $cname"
    fi
done


cat <<EOF > delete-student${studentNumber}-cname.json
{
  "Comment": "Create CNAME record for student${studentNumber}.wyckedsolutions.com",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "student${studentNumber}.wyckedsolutions.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${cname}"
          }
        ]
      }
    }
  ]
}
EOF

route53Exists=""
cname_values=$(aws route53 list-resource-record-sets --hosted-zone-id $ZONEID --query "ResourceRecordSets[?Type == 'CNAME'].ResourceRecords[].Value" --output text)

for value in $cname_values; do
    if [ "$value" = "$cname" ]; then
        echo "CNAME record match found: $value"
        route53Exists="True"
        break
    fi
done

if [ -n "$route53Exists" ]; then

  change_id=$(aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file://delete-student${studentNumber}-cname.json --query 'ChangeInfo.Id' --output text)

  # Initial status is set to PENDING
  status="PENDING"

  # Loop until the status is no longer PENDING
  while [ "$status" == "PENDING" ]; do
      echo "Waiting for the change to complete..."
  
      # Check the status of the change
      status=$(aws route53 get-change --id $change_id --query 'ChangeInfo.Status' --output text)
  
      # Wait for a short period before checking again
      sleep 10
  done
  sleep 10
  echo "Delete completed for student$studentNumber.wyckedsolutions.com with status: $status"
fi


cat << EOF | kubectl delete -f -
apiVersion: v1
kind: Pod
metadata:
  name: eksclass-pod-${studentNumber}
  labels:
    app: eksclass-${studentNumber}  # Add this label
spec:
  containers:
  - name: eksclass-container-${studentNumber}
    image: cindyspirion/test:test1
    ports:
    - containerPort: 7681

---

apiVersion: v1
kind: Service
metadata:
  name: eksclass-service-${studentNumber}
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 7681
      protocol: TCP
  selector:
    app: eksclass-${studentNumber}

EOF

echo "eksclass-service-${studentNumber} Deleted"


