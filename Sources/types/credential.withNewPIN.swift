//	Created by Leopold Lemmermann on 21.11.22.

extension Credential {
  /// Attach a new ``Credential/PIN`` to the this credential.
  /// - Parameter newPIN: The new pin.
  /// - Returns: A ``Credential/WithNewPIN`` instance.
  func attachNewPIN(_ newPIN: Credential.PIN) -> Credential.WithNewPIN {
    Credential.WithNewPIN(credential: self, newPIN: newPIN)
  }

  /// A ``Credential`` with an attached new pin.
  struct WithNewPIN: Identifiable, Codable, Hashable {
    /// The base ``Credential``.
    public let credential: Credential
    /// The attached new pin.
    public let newPIN: Credential.PIN

    /// `Identiable` requirement.
    public var id: Credential.ID { credential.id }
  }
}
