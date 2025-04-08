package templates

import (
    secretstorev1 "secrets-store.csi.x-k8s.io/secretproviderclass/v1"
)

#SecretProviderClass: secretstorev1.#SecretProviderClass & {
    #config: #Config
    #secretName: string
    #secretValue: string

    metadata: {
        name: "\(#config.metadata.name)-\(#secretName)"
        namespace: #config.metadata.namespace
        labels: #config.metadata.labels
    }
    spec: {
        provider: #config.cloudProvider
        parameters: {
            if #config.cloudProvider == "aws" {
                objects: """
                    - objectName: "\(#secretValue)"
                      objectType: "secretsmanager"
                    """
            }
            if #config.cloudProvider == "gcp" {
                secrets: """
                    - resourceName: "\(#secretValue)"
                      path: \(#secretName)
                    """
            }
        }
    }
}