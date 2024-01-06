cp ../02-Deploy-EKS/.kube .
export KUBECONFIG=./.kube

export studentNumber=$1

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: eksclass-pod-${studentNumber}
  labels:
    app: eksclass-${studentNumber}  # Add this label
spec:
  hostname: eksclass-${studentNumber}
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

# Initialize the hostname variable
hostname=""

# Loop until the hostname is retrieved
while [ -z "$hostname" ]; do
    echo "Waiting for hostname..."
    hostname=$(kubectl get service eksclass-service-$studentNumber -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)

    # Check if the hostname is still empty
    if [ -z "$hostname" ]; then
        # Wait for a short period before trying again
        sleep 5
    else
        echo "Hostname found: $hostname"
    fi
done


cat <<EOF > add-cname.json
{
  "Comment": "Create CNAME record for student${studentNumber}.wyckedsolutions.com",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "student${studentNumber}.wyckedsolutions.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${hostname}"
          }
        ]
      }
    }
  ]
}
EOF


change_id=$(aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file://add-cname.json --query 'ChangeInfo.Id' --output text)

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

echo "Change completed for student$studentNumber.wyckedsolutions.com with status: $status"

