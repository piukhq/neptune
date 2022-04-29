// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Failed to add payment account
  internal static let addPaymentAccountFailedToAddAlertMessage = L10n.tr("Localizable", "addPaymentAccount_failedToAddAlertMessage")
  /// Payment Account Added
  internal static let addPaymentAccountSuccessAlertMessage = L10n.tr("Localizable", "addPaymentAccount_successAlertMessage")
  /// Add Payment Account
  internal static let addPaymentAccountButtonTitle = L10n.tr("Localizable", "addPaymentAccountButton_title")
  /// Error
  internal static let alertError = L10n.tr("Localizable", "alert_error")
  /// Invalid Token
  internal static let alertInvalidToken = L10n.tr("Localizable", "alert_invalid_token")
  /// OK
  internal static let alertOk = L10n.tr("Localizable", "alert_ok")
  /// Unsupported Barcode
  internal static let alertUnsupportedBarcodeTitle = L10n.tr("Localizable", "alert_unsupported_barcode_title")
  /// Neptune
  internal static let appTitle = L10n.tr("Localizable", "app_title")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// Something went wrong
  internal static let errorSomethingWentWrong = L10n.tr("Localizable", "error_somethingWentWrong")
  /// Login
  internal static let loginButtonTitle = L10n.tr("Localizable", "login_button_title")
  /// Address:
  internal static let mapAnnotationCalloutAddressTitle = L10n.tr("Localizable", "map_annotationCallout_addressTitle")
  /// Closed
  internal static let mapAnnotationCalloutClosed = L10n.tr("Localizable", "map_annotationCallout_closed")
  /// Opening Hours:
  internal static let mapAnnotationCalloutOpeningHoursTitle = L10n.tr("Localizable", "map_annotationCallout_openingHoursTitle")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Are you sure you want to logout?
  internal static let settingsLogoutAlertMessage = L10n.tr("Localizable", "settings_logoutAlert_message")
  /// Logout
  internal static let settingsLogoutAlertTitle = L10n.tr("Localizable", "settings_logoutAlert_title")
  /// Dev
  internal static let settingsChooseEnvironmentActionSheetDev = L10n.tr("Localizable", "settingsChooseEnvironmentActionSheet_dev")
  /// Staging
  internal static let settingsChooseEnvironmentActionSheetStaging = L10n.tr("Localizable", "settingsChooseEnvironmentActionSheet_staging")
  /// Choose Environment
  internal static let settingsChooseEnvironmentActionSheetTitle = L10n.tr("Localizable", "settingsChooseEnvironmentActionSheet_title")
  /// Remove token from secure storage etc.
  internal static let settingsRowSubtitleLogout = L10n.tr("Localizable", "settingsRowSubtitle_logout")
  /// Change Environment
  internal static let settingsRowTitleChangeEnvironment = L10n.tr("Localizable", "settingsRowTitle_changeEnvironment")
  /// Current Login
  internal static let settingsRowTitleCurrentLogin = L10n.tr("Localizable", "settingsRowTitle_currentLogin")
  /// Logout
  internal static let settingsRowTitleLogout = L10n.tr("Localizable", "settingsRowTitle_logout")
  /// Loyalty Cards
  internal static let walletSectionHeaderLoyalty = L10n.tr("Localizable", "wallet_sectionHeader_loyalty")
  /// Payment Cards
  internal static let walletSectionHeaderPayment = L10n.tr("Localizable", "wallet_sectionHeader_payment")
  /// Add Payment Card
  internal static let walletSettingsActionSheetAddPaymentCard = L10n.tr("Localizable", "wallet_settingsActionSheet_addPaymentCard")
  /// Map
  internal static let walletSettingsActionSheetMap = L10n.tr("Localizable", "wallet_settingsActionSheet_map")
  /// Settings
  internal static let walletSettingsActionSheetSettings = L10n.tr("Localizable", "wallet_settingsActionSheet_settings")
  /// NEPTUNE GOD MODE
  internal static let walletSettingsActionSheetTitle = L10n.tr("Localizable", "wallet_settingsActionSheet_title")
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
