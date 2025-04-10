# redox-service

A [timoni.sh](http://timoni.sh) module for deploying redox-service to Kubernetes clusters. Timoni is a helm equivalent for cuelang. (P.S. doesn't support rollback command yet)

In our case, we can just use it to render Kubernetes manifests and for packaging and distribution of our code. 


## Install

Get timoni:

```
brew install stefanprodan/tap/timoni
```

## Run

This code was packaged and published as a demo OCI image to dockerhub at `oci://docker.io/lumaks/cue-service`.

You only need to define configuration values in yaml format and run the latest version. Most basic example:

```
timoni build --namespace services my-app oci://docker.io/lumaks/cue-service -f values/values.yaml
```

You can always define all values in a single file, but the next few examples will show how to combine several files for better organisation and to keep your values DRY. Let's template code for GCP:

```
timoni build --namespace services my-app oci://docker.io/lumaks/cue-service -f values/values.yaml -f values/targets/gcp/values.yaml
```

Now, let's template code for AWS and for `prod` environment:

```
timoni build --namespace services my-app oci://docker.io/lumaks/cue-service -f values/values.yaml -f values/targets/aws/values.yaml -f values/targets/aws/prod/values.yaml
```

# Development


## Import

Import values:

```
cue import -p main values/defaults.yaml
```

Import CRD schemas from root module folder:

```
timoni mod vendor crds -f https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.68.0/stripped-down-crds.yaml
```

## Build

To check templates with default values, run (`nginx` is example name and `test` is an aexample namespace):

P.S. this comand will error out if there are values overrides in multiple files and you don't specify values file.

```
timoni build --namespace services my-app .
```

With values and overrides:

```
timoni build --namespace services my-app . --values values.cue --values values-override.cue
```

With values supplied dynamically at runtime from stdin

```
echo "values: replicas: 4" | timoni build --namespace services my-app . --values values.cue --values values-override.cue --values -
```

## Publish

To publish module version to OCI registry:

```
timoni mod push . oci://docker.io/lumaks/cue-service -v 0.1.0
```

If you need to check with version have been published, run:

```
timoni mod list oci://docker.io/lumaks/cue-service
```

More exmaples [here](https://timoni.sh/cmd/timoni_mod_push/)


## Install

To create an instance using the default values:

```shell
timoni -n default apply redox-service oci://<container-registry-url>
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	resources: requests: {
		cpu:    "100m"
		memory: "128Mi"
	}
}
```

And apply the values with:

```shell
timoni -n default apply redox-service oci://<container-registry-url> \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete redox-service
```

## Configuration

| Key                      | Type                             | Default            | Description                                                                                                                                  |
|--------------------------|----------------------------------|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `image: tag:`            | `string`                         | `1-alpine`         | Container image tag                                                                                                                          |
| `image: digest:`         | `string`                         | `""`               | Container image digest, takes precedence over `tag` when specified                                                                           |
| `image: repository:`     | `string`                         | `docker.io/nginx`  | Container image repository                                                                                                                   |
| `image: pullPolicy:`     | `string`                         | `IfNotPresent`     | [Kubernetes image pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy)                                     |
| `metadata: labels:`      | `{[ string]: string}`            | `{}`               | Common labels for all resources                                                                                                              |
| `metadata: annotations:` | `{[ string]: string}`            | `{}`               | Common annotations for all resources                                                                                                         |
| `pod: annotations:`      | `{[ string]: string}`            | `{}`               | Annotations applied to pods                                                                                                                  |
| `pod: affinity:`         | `corev1.#Affinity`               | `nodeAffinity for Linux nodes` | [Kubernetes affinity and anti-affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| `pod: imagePullSecrets:` | `[...timoniv1.#ObjectReference]` | `[]`               | [Kubernetes image pull secrets](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)                 |
| `replicas:`              | `int`                            | `1`                | Kubernetes deployment replicas                                                                                                               |
| `resources:`             | `timoniv1.#ResourceRequirements` | `cpu: "10m", memory: "32Mi"` | [Kubernetes resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers)                     |
| `securityContext:`       | `corev1.#SecurityContext`        | `allowPrivilegeEscalation: false, privileged: false` | [Kubernetes container security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context)                           |
| `service: enabled:`      | `boolean`                        | `true`             | Enable or disable the Kubernetes Service                                                                                                     |
| `service: annotations:`  | `{[ string]: string}`            | `{}`               | Annotations applied to the Kubernetes Service                                                                                                |
| `service: port:`         | `int`                            | `80`               | Kubernetes Service HTTP port                                                                                                                 |
| `service: type:`         | `string`                         | `ClusterIP`        | Kubernetes Service type (ClusterIP, NodePort, or LoadBalancer)                                                                               |
| `monitoring: enabled:`   | `boolean`                        | `false`            | Enable or disable Prometheus ServiceMonitor                                                                                                  |
| `monitoring: interval:`  | `int`                            | `15`               | Scrape interval in seconds for Prometheus ServiceMonitor (valid range: 5-3600)                                                               |
| `vpa: enabled:`          | `boolean`                        | `true`             | Enable or disable Vertical Pod Autoscaler                                                                                                    |
| `vpa: updateMode:`       | `string`                         | `"Auto"`           | VPA update mode ("Off", "Initial", "Recreate", or "Auto")                                                                                    |
| `vpa: configs:`          | `{[string]: #VPAConfig}`         | `{}`               | Map of deployment name to specific VPA configuration                                                                                        |
| `pdb: enabled:`          | `boolean`                        | `true`             | Enable or disable Pod Disruption Budget                                                                                                     |
| `pdb: minAvailable:`     | `string\|int`                    | `"50%"`            | Minimum available pods, can be percentage or absolute number                                                                                 |
| `pdb: configs:`          | `{[string]: #PDBConfig}`         | `{}`               | Map of deployment name to specific PDB configuration                                                                                        |
| `serviceAccount: enabled:` | `boolean`                      | `true`             | Enable or disable Service Account creation                                                                                                   |
| `serviceAccount: name:`  | `string`                         | `""`               | Optional name for the Service Account                                                                                                       |
| `serviceAccount: annotations:` | `{[string]: string}`       | `{}`               | Annotations for the Service Account                                                                                                         |
| `serviceAccount: automountServiceAccountToken:` | `boolean` | `true`             | Whether to automount API credentials                                                                                                        |
| `cloudProvider:`         | `string`                         | `"aws"`            | Cloud provider ("aws", "azure", "gcp")                                                                                                      |
| `secretProviderClasses: secrets:` | `{[string]: string}`    | `{}`               | Map of SecretProviderClass names to secret names                                                                                           |
| `configMaps: enabled:`   | `boolean`                        | `false`            | Enable or disable ConfigMap creation                                                                                                        |
| `configMaps: configs:`   | `{[string]: #ConfigMapData}`     | `{}`               | Map of ConfigMap names to their data                                                                                                       |
| `envGroups:`             | `{[string]: #EnvGroup}`          | `{}`               | Named groups of environment variables that can be shared across deployments                                                                |
| `deploymentDefaults:`    | `#DeploymentConfig`              | See description    | Default configuration shared across all deployments                                                                                        |
| `deployments:`           | `{[string]: #DeploymentConfig}`  | Required           | Map of deployment names to their specific configurations                                                                                   |

Each deployment configuration (`#DeploymentConfig`) can include:

| Key                      | Type                             | Default            | Description                                                                                                                                  |
|--------------------------|----------------------------------|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `image:`                 | `#Image`                        | Inherited from defaults | Container image configuration                                                                                                                |
| `pod:`                   | `#PodConfig`                    | Inherited from defaults | Pod-specific configuration                                                                                                                  |
| `resources:`             | `#ResourceRequirements`         | Inherited from defaults | Container resource requirements                                                                                                             |
| `replicas:`              | `int`                           | Inherited from defaults | Number of pod replicas                                                                                                                      |
| `securityContext:`       | `#SecurityContext`              | Inherited from defaults | Container security context                                                                                                                  |
| `secrets:`               | `{[string]: {cloudRef: string, mountPath: string}}` | `{}` | Deployment-specific secrets configuration                                                                                                   |
| `envGroups:`             | `[...string]`                   | `[]`               | References to shared environment groups                                                                                                     |
