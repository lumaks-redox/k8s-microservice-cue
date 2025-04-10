// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni mod vendor crd -f https://doc.crds.dev/raw/github.com/crossplane/crossplane@v1.19.1

package v1

import "strings"

// A ProviderRevision represents a revision of a Provider.
// Crossplane
// creates new revisions when there are changes to a Provider.
//
// Crossplane creates and manages ProviderRevisions. Don't
// directly edit
// ProviderRevisions.
#ProviderRevision: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "pkg.crossplane.io/v1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "ProviderRevision"
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

	// ProviderRevisionSpec specifies configuration for a
	// ProviderRevision.
	spec!: #ProviderRevisionSpec
}

// ProviderRevisionSpec specifies configuration for a
// ProviderRevision.
#ProviderRevisionSpec: {
	// Map of string keys and values that can be used to organize and
	// categorize
	// (scope and select) objects. May match selectors of replication
	// controllers
	// and services.
	// More info:
	// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
	commonLabels?: close({
		[string]: string
	})
	controllerConfigRef?: {
		// Name of the ControllerConfig.
		name!: string
	}

	// DesiredState of the PackageRevision. Can be either Active or
	// Inactive.
	desiredState!: string

	// IgnoreCrossplaneConstraints indicates to the package manager
	// whether to
	// honor Crossplane version constrains specified by the package.
	// Default is false.
	ignoreCrossplaneConstraints?: bool

	// Package image used by install Pod to extract package contents.
	image!: string

	// PackagePullPolicy defines the pull policy for the package. It
	// is also
	// applied to any images pulled for the package, such as a
	// provider's
	// controller image.
	// Default is IfNotPresent.
	packagePullPolicy?: string

	// PackagePullSecrets are named secrets in the same namespace that
	// can be
	// used to fetch packages from private registries. They are also
	// applied to
	// any images pulled for the package, such as a provider's
	// controller image.
	packagePullSecrets?: [...{
		// Name of the referent.
		// This field is effectively required, but due to backwards
		// compatibility is
		// allowed to be empty. Instances of this type with an empty value
		// here are
		// almost certainly wrong.
		// More info:
		// https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
		name?: string
	}]

	// Revision number. Indicates when the revision will be garbage
	// collected
	// based on the parent's RevisionHistoryLimit.
	revision!: int64

	// RuntimeConfigRef references a RuntimeConfig resource that will
	// be used
	// to configure the package runtime.
	runtimeConfigRef?: {
		// API version of the referent.
		apiVersion?: string

		// Kind of the referent.
		kind?: string

		// Name of the RuntimeConfig.
		name!: string
	}

	// SkipDependencyResolution indicates to the package manager
	// whether to skip
	// resolving dependencies for a package. Setting this value to
	// true may have
	// unintended consequences.
	// Default is false.
	skipDependencyResolution?: bool

	// TLSClientSecretName is the name of the TLS Secret that stores
	// client
	// certificates of the Provider.
	tlsClientSecretName?: string

	// TLSServerSecretName is the name of the TLS Secret that stores
	// server
	// certificates of the Provider.
	tlsServerSecretName?: string
}
