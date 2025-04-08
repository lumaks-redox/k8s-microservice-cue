// filepath: /Users/maksym/dev/redox-services/services/mockingbird/redox-service/templates/serviceaccount.cue
package templates

import (
	corev1 "k8s.io/api/core/v1"
)

// ServiceAccount defines a Kubernetes ServiceAccount resource
#ServiceAccount: corev1.#ServiceAccount & {
	#config: #Config

	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name: #config.serviceAccount.name | #config.metadata.name
		labels: #config.metadata.labels
		if #config.metadata.annotations != _|_ || #config.serviceAccount.annotations != _|_ {
			annotations: (#config.metadata.annotations | {}) & (#config.serviceAccount.annotations | {})
		}
		// Add namespace from config
		namespace: #config.metadata.namespace
	}
	automountServiceAccountToken: #config.serviceAccount.automountServiceAccountToken
}