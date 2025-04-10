// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni mod vendor crd -f https://raw.githubusercontent.com/kubernetes/autoscaler/refs/heads/master/vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml

package v1

import "strings"

// VerticalPodAutoscalerCheckpoint is the checkpoint of the
// internal state of VPA that
// is used for recovery after recommender's restart.
#VerticalPodAutoscalerCheckpoint: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "autoscaling.k8s.io/v1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "VerticalPodAutoscalerCheckpoint"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// Specification of the checkpoint.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status.
	spec!: #VerticalPodAutoscalerCheckpointSpec
}

// Specification of the checkpoint.
// More info:
// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status.
#VerticalPodAutoscalerCheckpointSpec: {
	// Name of the checkpointed container.
	containerName?: string

	// Name of the VPA object that stored
	// VerticalPodAutoscalerCheckpoint object.
	vpaObjectName?: string
}
