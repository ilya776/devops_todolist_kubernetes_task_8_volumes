# Instructions to Validate the Application Setup

This document provides detailed steps to ensure that the application is correctly set up and that the `ConfigMap` and
`Secret` resources in the cluster are properly mounted.

---

## 1. Validate the Application is Running

To validate the application is running as expected and the pod is healthy:

1. **Check Pod Status**
   Run the following command to list the pods in the namespace and verify their status:
   ```bash
   kubectl get pods -n <namespace>
   ```
   Replace `<namespace>` with the appropriate namespace. Look for the pods associated with your application and ensure
   they are in the `Running` state.

   Example Output:
   ```
   NAME                      READY   STATUS    RESTARTS   AGE
   my-app-1234567890-abcd    1/1     Running   0          5m
   ```

2. **Check Logs**
   Review the logs to ensure the application is not encountering any runtime errors:
   ```bash
   kubectl logs <pod-name> -n <namespace>
   ```
   Replace `<pod-name>` with the name of the pod and `<namespace>` with the appropriate namespace.

3. **Check Service Endpoint**
   If the app exposes a service, test its accessibility:
   - Use `kubectl get svc` to confirm the service details.
   - Access the service endpoint using `curl` or a browser:
     ```bash
     curl http://<service-ip>:<port>
     ```

If the application is not running or accessible, debug by reviewing the deployments, pods, and events:

```bash
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace>
```

---

## 2. Validate ConfigMap Data is Mounted as Files in the Correct Order

To confirm the proper configuration and mounting of the `ConfigMap` as files:

1. **Verify Mounted Path**
   Locate the pod where the `ConfigMap` is applied:
   ```bash
   kubectl get pods -n <namespace>
   ```

2. **Inspect Mounted Files**
   Check the directory where the `ConfigMap` is mounted:
   ```bash
   kubectl exec -it <pod-name> -n <namespace> -- ls -l /mount/path/for/configmap
   ```
   Replace `/mount/path/for/configmap` with the actual mount path specified in your Kubernetes resource definition.

   Verify that:
   - The files from the `ConfigMap` appear in the directory.
   - The file names and order match the expected configuration.

3. **Read File Contents (Optional)**
   Validate the actual content of the mounted files using:
   ```bash
   kubectl exec -it <pod-name> -n <namespace> -- cat /mount/path/for/configmap/<file-name>
   ```
   For example:
   ```bash
   kubectl exec -it my-app-1234567890-abcd -n default -- cat /etc/configmap/my-config.conf
   ```

4. **Check the Kubernetes Manifest**
   Double-check that the `ConfigMap` is correctly referenced in the pod manifest or deployment YAML. The `volumeMounts`
   and `volumes` sections should look similar to:
   ```yaml
   volumeMounts:
     - name: config-volume
       mountPath: /etc/configmap

   volumes:
     - name: config-volume
       configMap:
         name: my-configmap
   ```

---

## 3. Validate Secret Data is Mounted as Files

Verify that secrets are mounted as files in the container and contain the expected data.

1. **Locate the Pod**
   Identify the name of the pod:
   ```bash
   kubectl get pods -n <namespace>
   ```

2. **Inspect Mounted Secret Directory**
   Check the directory where the secrets are mounted:
   ```bash
   kubectl exec -it <pod-name> -n <namespace> -- ls -l /mount/path/for/secret
   ```
   Replace `/mount/path/for/secret` with the directory path specified in the `volumes` section of your manifest.

3. **Verify Secret File Content**
   Read the content of the secret file:
   ```bash
   kubectl exec -it <pod-name> -n <namespace> -- cat /mount/path/for/secret/<file-name>
   ```
   Example:
   ```bash
   kubectl exec -it my-app-1234567890-abcd -n default -- cat /etc/secret/my-secret-key.txt
   ```

4. **Review Kubernetes Manifest**
   Ensure the secret is referenced properly in the deployment YAML. Example:
   ```yaml
   volumeMounts:
     - name: secret-volume
       mountPath: /etc/secret

   volumes:
     - name: secret-volume
       secret:
         secretName: my-secret
   ```

   The secret files should map to the keys stored in your `Secret`.

---

## Troubleshooting Notes

- If files are missing or incorrect, verify the names and contents of the `ConfigMap` or `Secret` using:
  ```bash
  kubectl get configmap my-configmap -o yaml -n <namespace>
  kubectl get secret my-secret -o yaml --namespace <namespace>
  ```
  Note: Base64 decode the data in the secret before validation.

- Check the pod events for mounting errors:
  ```bash
  kubectl describe pod <pod-name> -n <namespace>
  ```

By following these steps, you can ensure that the application, `ConfigMap`, and `Secrets` are properly set up in your
Kubernetes environment.