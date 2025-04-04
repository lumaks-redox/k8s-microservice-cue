// filepath: /Users/maksym/dev/redox-services/services/mockingbird/redox-service/templates/vpa.cue
package templates

import (
	autoscalingv1 "autoscaling.k8s.io/verticalpodautoscaler/v1"
)

// VPA defines a Vertical Pod Autoscaler resource
#VPA: autoscalingv1.#VerticalPodAutoscaler & {
	#config:        #Config
	#deploymentName: string
	#vpaConfig:     #VPAConfig | {}

	apiVersion: "autoscaling.k8s.io/v1"
	kind:       "VerticalPodAutoscaler"
	
	metadata: {
		name: "\(#config.metadata.name)-\(#deploymentName)-vpa"
		namespace: #config.metadata.namespace
		labels: #config.metadata.labels & (#vpaConfig.labels | {})
		if #config.metadata.annotations != _|_ || #vpaConfig.annotations != _|_ {
			annotations: (#config.metadata.annotations | {}) & (#vpaConfig.annotations | {})
		}
	}
	spec: {
		targetRef: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
			name:       "\(#config.metadata.name)-\(#deploymentName)"
		}
		updatePolicy: {
			// Use deployment-specific mode if available, otherwise use default from config
			updateMode: *#config.vpa.updateMode | string
			if #vpaConfig.updateMode != _|_ {
				updateMode: #vpaConfig.updateMode
			}
		}
		if #vpaConfig.resourcePolicy != _|_ {
			resourcePolicy: #vpaConfig.resourcePolicy
		}
	}
}