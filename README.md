# gcp-airbyte-setup

## Setting up Airbyte on GKE cluster
1. Install kubectl, if not installed already follow the instructions here [https://kubernetes.io/docs/tasks/tools/]
2. Configure kubectl:
   1. Configure `gcloud` with `gcloud auth login`
   2. Use the following command to configure kubectl:
      `gcloud container clusters get-credentials arbyt-int --region us-central1 --project utilization-forecast-test`
   3. To view the context available:
      `kubectl config get-contexts`
   4. To access the GKE cluster with kubectl, use the below command and replace `$GKE_CONTEXT` with the respective context from the list in step 3:
      `kubectl config use-context $GKE_CONTEXT`
3. Deploying Airbyte in the GKE cluster:
   1. Install Helm, for macOS:
      `brew install helm`
   2. Add remote helm repo to access helm-charts
      `helm repo add airbyte https://airbytehq.github.io/helm-charts`
   3. To index Airbyte repo:
      `helm repo update`
   4. Default Airbyte deployment if no customization is needed, replace `%release_name%` with a custom release name:
      `helm install %release_name% airbyte/airbyte`
   5. Accessing Airbyte application on localhost:
   ```commandline
      export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=webapp" -o jsonpath="{.items[0].metadata.name}")
      export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
      echo "Visit http://127.0.0.1:8080 to use your application"
      kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
   ```
   Airbyte should be accessible at `http://127.0.0.1:8080` after executing the last command.
   
   6. To check the pod status, run `kubectl get pods | grep airbyte`.
