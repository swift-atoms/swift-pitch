extension Pitch.Scale {
    public enum Error: Swift.Error, Hashable, Sendable {
        /// A scale of no classes.
        case empty
    }
}
