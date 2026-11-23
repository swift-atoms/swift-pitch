public import Frequency
public import Numeric

extension Pitch {
    /// Twelve-tone equal temperament from one reference pitch at one frequency: every semitone is the twelfth
    /// root of two above the one under it.
    public struct Tuning: Hashable, Sendable {
        /// The pitch whose frequency is given.
        public let reference: Pitch
        /// The reference pitch's frequency.
        public let frequency: Frequency.Value<Double>

        /// Fails with `.frequency` for a frequency that is not positive and finite.
        @inlinable
        public init(_ reference: Pitch, at frequency: Frequency.Value<Double>) throws(Error) {
            guard frequency.underlying > 0, frequency.underlying.isFinite else { throw .frequency }
            self.reference = reference
            self.frequency = frequency
        }
    }
}

extension Pitch.Tuning {
    /// A in octave 4 at 440 cycles a second, the concert pitch of ISO 16.
    public static let standard: Self = {
        do throws(Error) {
            return try Self(Pitch(.a, octave: 4), at: Frequency.hertz(440))
        } catch {
            preconditionFailure("440 is a frequency")
        }
    }()
}

extension Pitch {
    /// The pitch's frequency in `tuning`: the reference frequency times two to the power of the semitones from the
    /// reference over twelve.
    @inlinable
    public func frequency(in tuning: Tuning = .standard) -> Frequency.Value<Double> {
        tuning.frequency * Double.math.pow(2, Double(semitones(from: tuning.reference)) / 12)
    }
}
