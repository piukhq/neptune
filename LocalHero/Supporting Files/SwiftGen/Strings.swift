// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Error
  internal static let alertError = L10n.tr("Localizable", "alert_error")
  /// Invalid Token
  internal static let alertInvalidToken = L10n.tr("Localizable", "alert_invalid_token")
  /// OK
  internal static let alertOk = L10n.tr("Localizable", "alert_ok")
  /// Unsupported Barcode
  internal static let alertUnsupportedBarcodeTitle = L10n.tr("Localizable", "alert_unsupported_barcode_title")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Login
  internal static let loginButtonTitle = L10n.tr("Localizable", "login_button_title")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Remove token from secure storage etc.
  internal static let settingsRowSubtitleLogout = L10n.tr("Localizable", "settingsRowSubtitle_logout")
  /// Change Environment
  internal static let settingsRowTitleChangeEnvironment = L10n.tr("Localizable", "settingsRowTitle_changeEnvironment")
  /// Current Login
  internal static let settingsRowTitleCurrentLogin = L10n.tr("Localizable", "settingsRowTitle_currentLogin")
  /// Logout
  internal static let settingsRowTitleLogout = L10n.tr("Localizable", "settingsRowTitle_logout")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
