// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni mod vendor crd -f https://doc.crds.dev/raw/github.com/crossplane/crossplane@v1.19.1

package v1alpha1

import "strings"

// A NopResource is an example API type.
#NopResource: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "nop.crossplane.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "NopResource"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// A NopResourceSpec defines the desired state of a NopResource.
	spec!: #NopResourceSpec
}

// A NopResourceSpec defines the desired state of a NopResource.
#NopResourceSpec: {
	// DeletionPolicy specifies what will happen to the underlying
	// external when this managed resource is deleted - either
	// "Delete" or "Orphan" the external resource.
	deletionPolicy?: "Orphan" | "Delete"

	// NopResourceParameters are the configurable fields of a
	// NopResource.
	forProvider!: {
		// ConditionAfter can be used to set status conditions after a
		// specified time. By default a NopResource will only have a
		// status condition of Type: Synced. It will never have a status
		// condition of Type: Ready unless one is configured here.
		conditionAfter?: [...{
			// ConditionReason to set - e.g. Available.
			conditionReason?: string

			// ConditionStatus to set - e.g. True.
			conditionStatus!: string

			// ConditionType to set - e.g. Ready.
			conditionType!: string

			// Time is the duration after which the condition should be set.
			time!: string
		}]

		// ConnectionDetails that this NopResource should emit on each
		// reconcile.
		connectionDetails?: [...{
			// Name of the connection detail.
			name!: string

			// Value of the connection detail.
			value!: string
		}]

		// Fields is an arbitrary object you can patch to and from. It has
		// no schema, is not validated, and is not used by the
		// NopResource controller.
		fields?: {
			...
		}
	}

	// ProviderConfigReference specifies how the provider that will be
	// used to create, observe, update, and delete this managed
	// resource should be configured.
	providerConfigRef?: {
		// Name of the referenced object.
		name!: string

		// Policies for referencing.
		policy?: {
			// Resolution specifies whether resolution of this reference is
			// required. The default is 'Required', which means the reconcile
			// will fail if the reference cannot be resolved. 'Optional'
			// means this reference will be a no-op if it cannot be resolved.
			resolution?: "Required" | "Optional"

			// Resolve specifies when this reference should be resolved. The
			// default is 'IfNotPresent', which will attempt to resolve the
			// reference only when the corresponding field is not present.
			// Use 'Always' to resolve the reference on every reconcile.
			resolve?: "Always" | "IfNotPresent"
		}
	}

	// ProviderReference specifies the provider that will be used to
	// create, observe, update, and delete this managed resource.
	// Deprecated: Please use ProviderConfigReference, i.e.
	// `providerConfigRef`
	providerRef?: {
		// Name of the referenced object.
		name!: string

		// Policies for referencing.
		policy?: {
			// Resolution specifies whether resolution of this reference is
			// required. The default is 'Required', which means the reconcile
			// will fail if the reference cannot be resolved. 'Optional'
			// means this reference will be a no-op if it cannot be resolved.
			resolution?: "Required" | "Optional"

			// Resolve specifies when this reference should be resolved. The
			// default is 'IfNotPresent', which will attempt to resolve the
			// reference only when the corresponding field is not present.
			// Use 'Always' to resolve the reference on every reconcile.
			resolve?: "Always" | "IfNotPresent"
		}
	}

	// PublishConnectionDetailsTo specifies the connection secret
	// config which contains a name, metadata and a reference to
	// secret store config to which any connection details for this
	// managed resource should be written. Connection details
	// frequently include the endpoint, username, and password
	// required to connect to the managed resource.
	publishConnectionDetailsTo?: {
		// SecretStoreConfigRef specifies which secret store config should
		// be used for this ConnectionSecret.
		configRef?: {
			// Name of the referenced object.
			name!: string

			// Policies for referencing.
			policy?: {
				// Resolution specifies whether resolution of this reference is
				// required. The default is 'Required', which means the reconcile
				// will fail if the reference cannot be resolved. 'Optional'
				// means this reference will be a no-op if it cannot be resolved.
				resolution?: "Required" | "Optional"

				// Resolve specifies when this reference should be resolved. The
				// default is 'IfNotPresent', which will attempt to resolve the
				// reference only when the corresponding field is not present.
				// Use 'Always' to resolve the reference on every reconcile.
				resolve?: "Always" | "IfNotPresent"
			}
		}

		// Metadata is the metadata for connection secret.
		metadata?: {
			// Annotations are the annotations to be added to connection
			// secret. - For Kubernetes secrets, this will be used as
			// "metadata.annotations". - It is up to Secret Store
			// implementation for others store types.
			annotations?: close({
				[string]: string
			})

			// Labels are the labels/tags to be added to connection secret. -
			// For Kubernetes secrets, this will be used as
			// "metadata.labels". - It is up to Secret Store implementation
			// for others store types.
			labels?: close({
				[string]: string
			})

			// Type is the SecretType for the connection secret. - Only valid
			// for Kubernetes Secret Stores.
			type?: string
		}

		// Name is the name of the connection secret.
		name!: string
	}

	// WriteConnectionSecretToReference specifies the namespace and
	// name of a Secret to which any connection details for this
	// managed resource should be written. Connection details
	// frequently include the endpoint, username, and password
	// required to connect to the managed resource. This field is
	// planned to be replaced in a future release in favor of
	// PublishConnectionDetailsTo. Currently, both could be set
	// independently and connection details would be published to
	// both without affecting each other.
	writeConnectionSecretToRef?: {
		// Name of the secret.
		name!: string

		// Namespace of the secret.
		namespace!: string
	}
}
