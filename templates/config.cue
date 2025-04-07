package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// The kubeVersion is a required field, set at apply-time
	// via timoni.cue by querying the user's Kubernetes API.
	kubeVersion!: string
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}

	// The moduleVersion is set from the user-supplied module version.
	// This field is used for the `app.kubernetes.io/version` label.
	moduleVersion!: string

	// The Kubernetes metadata common to all resources.
	// The `metadata.name` and `metadata.namespace` fields are
	// set from the user-supplied instance name and namespace.
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// The labels allows adding `metadata.labels` to all resources.
	// The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels
	// are automatically generated and can't be overwritten.
	metadata: labels: timoniv1.#Labels

	// The annotations allows adding `metadata.annotations` to all resources.
	metadata: annotations?: timoniv1.#Annotations

	// The selector allows adding label selectors to Deployments and Services.
	// The `app.kubernetes.io/name` label selector is automatically generated
	// from the instance name and can't be overwritten.
	selector: timoniv1.#Selector & {#Name: metadata.name}

	// Default configuration shared across all deployments
	// Engineers can override these values in their deployments
	deploymentDefaults: #DeploymentConfig & {
		// Default image settings
		image: #ImageSchema

		// Default pod settings
		pod: {
			annotations?:     timoniv1.#Annotations
			affinity?:        corev1.#Affinity
			imagePullSecrets?: [...timoniv1.#ObjectReference]
		}

		// Default resource requirements
		resources: timoniv1.#ResourceRequirements & {
			requests: {
				memory: *"200Mi" | string
				cpu:    *"10m" | string
			}
		}

		// Default replicas
		replicas: *1 | int & >0

		// Default security context
		securityContext: corev1.#SecurityContext & {
			allowPrivilegeEscalation: *false | bool
			privileged:               *false | bool
			capabilities: {
				drop: *["ALL"] | [...]
				add:  *["CHOWN", "NET_BIND_SERVICE", "SETGID", "SETUID"] | [...]
			}
		}

		 // Default secrets configuration
        secrets: {
            "service-metadata": {
                cloudRef: "service/service-metadata"
                mountPath: "/mnt/service-metadata"
            }
        }
	}

	// Deployments configuration
	// Maps a deployment name to its configuration
	// Engineers only need to specify values they want to override
	deployments!: [string]: #DeploymentConfig

	// The service allows setting the Kubernetes Service annotations and port.
	// By default, the HTTP port is 80.
	service: {
		enabled: *true | false
		annotations?: timoniv1.#Annotations
		port: *80 | int & >0 & <=65535
		type: *"ClusterIP" | "NodePort" | "LoadBalancer"
	}

	// Promethues service monitor (optional)
	monitoring: {
		enabled:  *false | bool
		interval: *15 | int & >=5 & <=3600
	}

	// Vertical Pod Autoscaler configuration (optional)
	vpa: {
		enabled: *true | bool
		updateMode: *"Auto" | "Off" | "Initial" | "Recreate"
		// Map of deployment name to specific VPA configuration 
		// for overriding the defaults
		configs?: [string]: #VPAConfig
	}

	// Pod Disruption Budget configuration (optional)
	pdb: {
		enabled: *true | bool
		// Min available can be an absolute number or a percentage
		minAvailable: *"50%" | string | int
		// Map of deployment name to specific PDB configuration
		// for overriding the defaults
		configs?: [string]: #PDBConfig
	}

	// Service Account configuration (optional)
	serviceAccount: {
		enabled: *true | bool
		name?: string
		annotations?: timoniv1.#Annotations
		// Set automountServiceAccountToken to false to disable automounting API credentials
		automountServiceAccountToken: *true | bool
	}

	// Cloud provider configuration
	cloudProvider: *"aws" | "azure" | "gcp" | string

	// SecretProviderClass configuration (optional)
	secretProviderClasses: {
		// Map of SecretProviderClass names to secret names
		secrets?: [string]: string
	}

	// ConfigMap configuration (optional)
	configMaps: {
		enabled: *false | bool
		// Map of configmap name to data
		configs?: [string]: #ConfigMapData
	}

	// Environment variable groups that can be shared across deployments
	envGroups: [Name=string]: {
		// Name is automatically set from the key
		name: Name
		vars: [string]: string
		optional?: bool
	}
}

// Define a reusable schema for the image configuration
#ImageSchema: {
	repository: *"docker.io/nginx" | string
	tag:        *"1-alpine" | string
	digest:     *"" | string
	pullPolicy: *"IfNotPresent" | "Always" | "Never"
	reference: string

	if digest != "" && tag != "" {
		reference: "\(repository):\(tag)@\(digest)"
	}

	if digest != "" && tag == "" {
		reference: "\(repository)@\(digest)"
	}

	if digest == "" && tag != "" {
		reference: "\(repository):\(tag)"
	}

	if digest == "" && tag == "" {
		reference: "\(repository):latest"
	}
}

// SecretProviderClass configuration schema
#SecretProviderConfig: {
	// Optional name override, defaults to "<metadata.name>-spc"
	name?: string
	
	// The provider name (required)
	provider: string
	
	// Provider-specific parameters (required)
	parameters: [string]: string
	
	// Secret objects to be created from the mounted secrets
	secretObjects?: [...{
		secretName: string
		type?: string | *"Opaque"
		data: [...{
			objectName: string
			key: string
		}]
	}]
	
	labels?: [string]:      string
	annotations?: [string]: string
}

// Deployment configuration schema
#DeploymentConfig: {
	// The image allows setting the container image repository,
	// tag, digest and pull policy.
	image?: #ImageSchema

	// The pod allows setting the Kubernetes Pod annotations, image pull secrets,
	// affinity and anti-affinity rules.
	pod?: {
		annotations?: timoniv1.#Annotations
		affinity?: corev1.#Affinity
		imagePullSecrets?: [...timoniv1.#ObjectReference]
	}

	// The resources allows setting the container resource requirements.
	resources?: timoniv1.#ResourceRequirements

	// The number of pods replicas.
	replicas?: int & >0

	// The securityContext allows setting the container security context.
	securityContext?: corev1.#SecurityContext

	// Secrets will be inferred based on cloudProvider and secret names
	secrets?: [string]: {
		cloudRef: string
		mountPath: string
	}

	// References to shared envGroups
	envGroups?: [...string]
}

// VPA configuration schema
#VPAConfig: {
    // VPA update mode: "Off", "Initial", "Recreate", or "Auto"
    updateMode?: "Off" | "Initial" | "Recreate" | "Auto"
    
    // Resource policy
    resourcePolicy?: {
        containerPolicies?: [...{
            containerName?: string
            mode?: "Auto" | "Off"
            minAllowed?: {
                cpu?:    string
                memory?: string
            }
            maxAllowed?: {
                cpu?:    string
                memory?: string
            }
            controlledResources?: [...string]
        }]
    }
    
    labels?: [string]:      string
    annotations?: [string]: string
}

// PDB configuration schema
#PDBConfig: {
    // Min available can be an absolute number or a percentage
    minAvailable?: string | int
    
    labels?: [string]:      string
    annotations?: [string]: string
}

// ConfigMap data schema
#ConfigMapData: {
    // Data for the configmap (key-value pairs)
    data: [string]: string
    
    // Make configmap optional in envFrom
    optional?: bool

    labels?: [string]:      string
    annotations?: [string]: string
}

#Instance: {
    config: #Config

    // Validate that referenced envGroups exist
    for name, deployConfig in config.deployments
        if deployConfig.envGroups != _|_
        for groupName in deployConfig.envGroups
            if config.envGroups == _|_ || config.envGroups[groupName] == _|_ {
                deployConfig: envGroups: groupName: "envGroup \(groupName) does not exist"
            }

    objects: {
        // Create a deployment for each entry in the deployments object
        for name, deployConfig in config.deployments {
            // Simply merge defaults with deployment-specific config
            // CUE's & operator handles the deep merge automatically
            "deploy-\(name)": #Deployment & {
                #config: config
                #deploymentName: name
                #deploymentConfig: config.deploymentDefaults & deployConfig
            }
        }
		
		// Add service only if enabled
		if config.service.enabled {
			service: #Service & {#config: config}
		}
		
		if config.monitoring.enabled {
			servicemonitor: #ServiceMonitor & {#config: config}
		}

		// Add VPA resources if enabled
		if config.vpa.enabled {
			for name, _ in config.deployments {
				"vpa-\(name)": #VPA & {
					#config: config
					#deploymentName: name
					#vpaConfig: config.vpa.configs[name] | {}
				}
			}
		}

		// Add PDB resources if enabled
		if config.pdb.enabled {
			for name, _ in config.deployments {
				"pdb-\(name)": #PDB & {
					#config: config
					#deploymentName: name
					#pdbConfig: config.pdb.configs[name] | {}
				}
			}
		}

		// Add ServiceAccount if enabled
		if config.serviceAccount.enabled {
			serviceaccount: #ServiceAccount & {#config: config}
		}

		// Create ConfigMaps for each environment group
		if config.envGroups != _|_ {
			for group in config.envGroups {
				"configmap-\(group.name)": #ConfigMap & {
					#config: config
					#configMapName: group.name  // Just use group name as deployment name will be prepended
					#configMapData: {
						data: group.vars
						optional: group.optional
					}
				}
			}
		}
		
		// Create SecretProviderClass for all secrets (default + deployment specific)
        for name, deployConfig in config.deployments {
            let mergedSecrets = {
                // Add default secrets
                if config.deploymentDefaults.secrets != _|_ {
                    {for k, v in config.deploymentDefaults.secrets {"\(k)": v}}
                }
                // Add/override with deployment specific secrets
                if deployConfig.secrets != _|_ {
                    {for k, v in deployConfig.secrets {"\(k)": v}}
                }
            }
            for secretName, secretConfig in mergedSecrets {
                "spc-\(secretName)": #SecretProviderClass & {
                    #config: config
                    #secretName: secretName 
                    #secretValue: secretConfig.cloudRef
                }
            }
        }
	}
}
