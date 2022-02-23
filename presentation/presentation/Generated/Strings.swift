// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  /// Update bundle if you need to change app language
  static var bundle: Bundle?

  /// Active
  static var active: String {
    return L10n.tr("Localizable", "active")
  }
  /// Blocked
  static var blocked: String {
    return L10n.tr("Localizable", "blocked")
  }
  /// Done
  static var done: String {
    return L10n.tr("Localizable", "done")
  }
  /// Error
  static var error: String {
    return L10n.tr("Localizable", "error")
  }
  /// Expired
  static var expired: String {
    return L10n.tr("Localizable", "expired")
  }
  /// Ok
  static var ok: String {
    return L10n.tr("Localizable", "ok")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: bundle ?? Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
