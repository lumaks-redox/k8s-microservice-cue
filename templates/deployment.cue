package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:          #Config
	#deploymentName:  string
	#deploymentConfig: #DeploymentConfig
	
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		// Copy only labels from config metadata, not the name
		labels: #config.metadata.labels
		
		// Handle annotations only if they exist
		if #config.metadata.annotations != _|_ {
			annotations: #config.metadata.annotations
		}
		
		// Set the name explicitly with the deployment suffix
		name: "\(#config.metadata.name)-\(#deploymentName)"
	}
	spec: appsv1.#DeploymentSpec & {
		replicas: #deploymentConfig.replicas
		selector: matchLabels: {
			#config.selector.labels
			"deployment": #deploymentName
		}
		template: {
			metadata: {
				labels: {
					#config.selector.labels
					"deployment": #deploymentName
				}
				if #deploymentConfig.pod.annotations != _|_ {
					annotations: #deploymentConfig.pod.annotations
				}
			}
			spec: corev1.#PodSpec & {
				containers: [
					{
						name:            #deploymentName
						image:           #deploymentConfig.image.reference
						imagePullPolicy: #deploymentConfig.image.pullPolicy
						ports: [
							{
								name:          "http"
								containerPort: 80
								protocol:      "TCP"
							},
						]
						readinessProbe: {
							httpGet: {
								path: "/"
								port: "http"
							}
							initialDelaySeconds: 5
							periodSeconds:       10
						}
						livenessProbe: {
							tcpSocket: {
								port: "http"
							}
							initialDelaySeconds: 5
							periodSeconds:       5
						}
						if #deploymentConfig.resources != _|_ {
							resources: #deploymentConfig.resources
						}
						if #deploymentConfig.securityContext != _|_ {
							securityContext: #deploymentConfig.securityContext
						}
						if #deploymentConfig.secrets != _|_ {
							volumeMounts: [
								for secretName, secret in #deploymentConfig.secrets {
									{
										name: secretName
										mountPath: secret.mountPath
										readOnly: true
									}
								}
							]
						}
						if #deploymentConfig.envGroups != _|_ {
							envFrom: [
								for groupName in #deploymentConfig.envGroups {
									configMapRef: {
										name: "\(#config.metadata.name)-\(groupName)"
										if #config.envGroups[groupName].optional {
											optional: true
										}
									}
								}
							]
						}
					},
				]
				if #deploymentConfig.pod.affinity != _|_ {
					affinity: #deploymentConfig.pod.affinity
				}
				if #deploymentConfig.pod.imagePullSecrets != _|_ {
					imagePullSecrets: #deploymentConfig.pod.imagePullSecrets
				}
				// Dynamically generate volumes based on secrets if they exist
				if #deploymentConfig.secrets != _|_ {
					volumes: [
						for secretName, secretValue in #deploymentConfig.secrets {
							{
								name: secretName
								csi: {
									driver: "secrets-store.csi.k8s.io"
									readOnly: true
									volumeAttributes: {
										secretProviderClass: "spc-\(secretName)"
									}
								}
							}
						}
					]
				}
			}
		}
	}
}
