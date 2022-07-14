import CryptoKit

public extension Obfuscation.Encryption {

    /// A symmetric algorithm that indicates how to encrypt or decrypt data.
    enum SymmetricEncryptionAlgorithm: String {
        /// The Advanced Encryption Standard (AES) algorithm in Galois/Counter Mode (GCM)
        /// with 128-bit key.
        case aes128GCM

        /// The Advanced Encryption Standard (AES) algorithm in Galois/Counter Mode (GCM)
        /// with 192-bit key.
        case aes192GCM

        /// The Advanced Encryption Standard (AES) algorithm in Galois/Counter Mode (GCM)
        /// with 256-bit key.
        case aes256GCM

        /// The ChaCha20-Poly1305 algorithm.
        case chaChaPoly
    }
}

public extension Obfuscation.Encryption.SymmetricEncryptionAlgorithm {

    /// The size of the symmetric cryptographic key associated with the algorithm.
    var keySize: SymmetricKeySize {
        switch self {
        case .aes128GCM:
            return .bits128
        case .aes192GCM:
            return .bits192
        case .aes256GCM:
            return .bits256
        case .chaChaPoly:
            return .bits256
        }
    }
}
