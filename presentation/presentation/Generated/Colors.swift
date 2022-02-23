// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cfcfcf"></span>
  /// Alpha: 100% <br/> (0xcfcfcfff)
  internal static let alto = ColorName(rgbaValue: 0xcfcfcfff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#edf8f6"></span>
  /// Alpha: 100% <br/> (0xedf8f6ff)
  internal static let blackSqueeze = ColorName(rgbaValue: 0xedf8f6ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#707070"></span>
  /// Alpha: 100% <br/> (0x707070ff)
  internal static let doveGray = ColorName(rgbaValue: 0x707070ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#929292"></span>
  /// Alpha: 100% <br/> (0x929292ff)
  internal static let dustyGray = ColorName(rgbaValue: 0x929292ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#099a71"></span>
  /// Alpha: 100% <br/> (0x099a71ff)
  internal static let gossamer = ColorName(rgbaValue: 0x099a71ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ea5b6a"></span>
  /// Alpha: 100% <br/> (0xea5b6aff)
  internal static let mandy = ColorName(rgbaValue: 0xea5b6aff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1cad92"></span>
  /// Alpha: 100% <br/> (0x1cad92ff)
  internal static let mountainMeadow = ColorName(rgbaValue: 0x1cad92ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#adadad"></span>
  /// Alpha: 100% <br/> (0xadadadff)
  internal static let silverChalice = ColorName(rgbaValue: 0xadadadff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#363638"></span>
  /// Alpha: 100% <br/> (0x363638ff)
  internal static let tuna = ColorName(rgbaValue: 0x363638ff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let components = RGBAComponents(rgbaValue: rgbaValue).normalized
    self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
  }
}

private struct RGBAComponents {
  let rgbaValue: UInt32

  private var shifts: [UInt32] {
    [
      rgbaValue >> 24, // red
      rgbaValue >> 16, // green
      rgbaValue >> 8,  // blue
      rgbaValue        // alpha
    ]
  }

  private var components: [CGFloat] {
    shifts.map {
      CGFloat($0 & 0xff)
    }
  }

  var normalized: [CGFloat] {
    components.map { $0 / 255.0 }
  }
}

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
