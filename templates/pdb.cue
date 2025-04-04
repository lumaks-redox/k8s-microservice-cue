// filepath: /Users/maksym/dev/redox-services/services/mockingbird/redox-service/templates/pdb.cue
package templates

import (
	policyv1 "k8s.io/api/policy/v1"
)

// PDB defines a Pod Disruption Budget resource
#PDB: policyv1.#PodDisruptionBudget & {
	#config:        #Config
	#deploymentName: string
	#pdbConfig:     #PDBConfig | {}

	apiVersion: "policy/v1"
	kind:       "PodDisruptionBudget"
	metadata: {
		name: "\(#config.metadata.name)-\(#deploymentName)-pdb"
		labels: #config.metadata.labels & (#pdbConfig.labels | {})
		if #config.metadata.annotations != _|_ || #pdbConfig.annotations != _|_ {
			annotations: (#config.metadata.annotations | {}) & (#pdbConfig.annotations | {})
		}
	}
	spec: {
		selector: {
			matchLabels: {
				#config.selector.labels
				"deployment": #deploymentName
			}
		}
		
		// Support either minAvailable or maxUnavailable, but prefer minAvailable
		// Use deployment-specific value if available, otherwise use default from config
		minAvailable: *#config.pdb.minAvailable | string | int
		if #pdbConfig.minAvailable != _|_ {
			minAvailable: #pdbConfig.minAvailable
		}
	}
}