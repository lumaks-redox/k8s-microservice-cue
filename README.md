# redox-service

A [timoni.sh](http://timoni.sh) module for deploying redox-service to Kubernetes clusters.

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
timoni build --namespace services example-service .
```

With values and overrides:

```
timoni build --namespace services example-service . --values values.cue --values values-override.cue
```

With values supplied dynamically at runtime from stdin

```
echo "values: replicas: 4" | timoni build --namespace services example-service . --values values.cue --values values-override.cue --values -
```


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
