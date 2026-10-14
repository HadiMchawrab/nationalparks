
#!/bin/bash
set -e

app_name=$1
image=$2
namespace=$3

echo "Application: $app_name"
echo "Image:       $image"
echo "Namespace:   $namespace"

if oc get deployment "$app_name" -n "$namespace" >/dev/null 2>&1; then
    echo "Updating existing deployment..."
    oc set image "deployment/$app_name" "$app_name=$image" -n "$namespace"
    oc rollout status "deployment/$app_name" -n "$namespace" --timeout=180s
else
    echo "Creating deployment..."
    oc new-app "$image" --name "$app_name" -n "$namespace"
    oc rollout status "deployment/$app_name" -n "$namespace" --timeout=180s
fi
