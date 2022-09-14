import Foundation

public struct SourceObfuscator {

    private let obfuscationStepResolver: DataObfuscationStepResolver

    init(obfuscationStepResolver: DataObfuscationStepResolver) {
        self.obfuscationStepResolver = obfuscationStepResolver
    }

    public func obfuscate(_ source: inout SourceSpecification) throws {
        guard !source.secrets.isEmpty else {
            return
        }

        let obfuscateData = obfuscationFunc(given: source.algorithm)
        try source.secrets.namespaces.forEach { namespace in
            guard let secrets = source.secrets[namespace] else {
                fatalError("Unexpected source specification integrity violation")
            }

            source.secrets[namespace] = try secrets.map { secret in
                var secret = secret
                secret.data = try obfuscateData(secret.data)
                return secret
            }[...]
        }
    }
}

private extension SourceObfuscator {

    typealias Algorithm = SourceSpecification.Algorithm
    typealias ObfuscationFunc = (Data) throws -> Data

    @inline(__always)
    func obfuscationFunc(given algorithm: Algorithm) -> ObfuscationFunc {
        algorithm
            .map(\.technique)
            .map(obfuscationStepResolver.obfuscationStep(for:))
            .reduce({ $0 }, { partialFunc, step in
                return {
                    try step.obfuscate(partialFunc($0))
                }
            })
    }
}
