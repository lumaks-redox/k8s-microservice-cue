// filepath: /Users/maksym/dev/redox-services/services/mockingbird/redox-service/templates/configmap.cue
package templates

import (
	corev1 "k8s.io/api/core/v1"
)

// ConfigMap defines a Kubernetes ConfigMap resource
#ConfigMap: corev1.#ConfigMap & {
	#config:        #Config
	#configMapName: string
	#configMapData: #ConfigMapData

	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name: "\(#config.metadata.name)-\(#configMapName)"
		labels: #config.metadata.labels & (#configMapData.labels | {})
		if #config.metadata.annotations != _|_ || #configMapData.annotations != _|_ {
			annotations: (#config.metadata.annotations | {}) & (#configMapData.annotations | {})
		}
	}
	data: #configMapData.data
}