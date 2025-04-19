# Validation Instructions

Follow these steps to validate the application setup:

---

## 1. Validate that the App is Running

1. Ensure the Kubernetes cluster is up and running:
   ```bash
   kubectl cluster-info
   ```

2. Check if the application Pod(s) are running:
   ```bash
   kubectl get pods
   ```

   Confirm that the `STATUS` of the application's Pod(s) is `Running`.

3. Verify application logs (replace `<pod-name>` with the desired Pod name):
   ```bash
   kubectl logs <pod-name>
   ```

   Ensure there are no errors in the logs.

4. Test the application's endpoint (if applicable):
    - If the app exposes an HTTP API, make a test request using `curl` or a browser:
      ```bash
      curl http://<application-service-url>
      ```

---

## 2. Validate that ConfigMap Data is Mounted as Files in the Correct Order

1. Retrieve the Pod's name where the application is running:
   ```bash
   kubectl get pods
   ```

2. Use `kubectl exec` to inspect the mounted ConfigMap directory (replace `<pod-name>` with the Pod name and
   `<mount-path>` with the ConfigMap mount location):
   ```bash
   kubectl exec -it <pod-name> -- ls -l <mount-path>
   ```

3. Confirm the following:
    - Files from the ConfigMap are present.
    - Files are mounted in the correct order as per configuration.

4. Optionally, inspect the contents of individual files:
   ```bash
   kubectl exec -it <pod-name> -- cat <mount-path>/<file-name>
   ```

---

## 3. Validate that Secret Data is Mounted as a File

1. Find the location where the Secret is mounted by inspecting the application's Pod manifest or `kubectl describe pod`:
   ```bash
   kubectl describe pod <pod-name>
   ```

   Look for `volumeMounts` related to the Secret.

2. List the files in the mounted Secret directory:
   ```bash
   kubectl exec -it <pod-name> -- ls -l <secret-mount-path>
   ```

   Ensure there is a file corresponding to the Secret.

3. Verify the contents of the file (optional, if you have access permissions):
   ```bash
   kubectl exec -it <pod-name> -- cat <secret-mount-path>/<file-name>
   ```

   Note: Secret data might be encoded. Handle it carefully and avoid exposing sensitive information.