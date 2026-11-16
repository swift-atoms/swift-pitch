extension Pitch.Tuning {
    public enum Error: Swift.Error, Hashable, Sendable {
        /// A reference frequency that is not positive and finite.
        case frequency
    }
}
