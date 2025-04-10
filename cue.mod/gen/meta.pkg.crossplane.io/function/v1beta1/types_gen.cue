// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni mod vendor crd -f https://doc.crds.dev/raw/github.com/crossplane/crossplane@v1.19.1

package v1beta1

import "strings"

// A Function is the description of a Crossplane Function package.
#Function: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "meta.pkg.crossplane.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Function"
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

	// FunctionSpec specifies the configuration of a Function.
	spec!: #FunctionSpec
}

// FunctionSpec specifies the configuration of a Function.
#FunctionSpec: {
	crossplane?: {
		// Semantic version constraints of Crossplane that package is
		// compatible with.
		version!: string
	}

	// Dependencies on other packages.
	dependsOn?: [...{
		// APIVersion of the dependency.
		apiVersion?: string

		// Configuration is the name of a Configuration package image.
		// Deprecated: Specify an apiVersion, kind, and package instead.
		configuration?: string

		// Function is the name of a Function package image.
		// Deprecated: Specify an apiVersion, kind, and package instead.
		function?: string

		// Kind of the dependency.
		kind?: string

		// Package OCI reference of the dependency. Only used when
		// apiVersion and
		// kind are set.
		package?: string

		// Provider is the name of a Provider package image.
		// Deprecated: Specify an apiVersion and kind instead.
		provider?: string

		// Version is the semantic version constraints of the dependency
		// image.
		version!: string
	}]

	// Image is the packaged Function image.
	image?: string
}
