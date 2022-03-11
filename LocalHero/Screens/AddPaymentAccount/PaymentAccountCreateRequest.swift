//
//  PaymentAccountCreateRequest.swift
//  LocalHero
//
//  Created by Sean Williams on 11/03/2022.
//

import Foundation

struct PaymentAccountCreateRequest: Codable {
    struct Card: Codable {
        enum CodingKeys: String, CodingKey {
            case token
            case firstSixDigits = "first_six_digits"
            case lastFourDigits = "last_four_digits"
            case nameOnCard = "name_on_card"
            case month = "expiry_month"
            case year = "expiry_year"
            case fingerprint
            case cardNickname = "card_nickname"
        }
        
        let token: String
        let firstSixDigits: String
        let lastFourDigits: String
        let nameOnCard: String
        let month: String
        let year: String
        let fingerprint: String
        let cardNickname: String?
    }
    
    struct Account: Codable {
        struct Consents: Codable {
            let latitude: Double
            let longitude: Double
            let timestamp: Int
            let type: Int
        }

        // These are default consents by design from architecture
        var consents: [Consents]?
    }
    
    let card: Card
    let account: Account
    
    /// This should only be used for creating test payment cards as it naturally bypasses the Spreedly path
//    init?(model: PaymentAccountCreateModel) {
//        guard let pan = model.fullPan?.replacingOccurrences(of: " ", with: ""),
//            let year = model.year,
//            let month = model.month
//            else { return nil }
//
//        // Get first six and last four
//
//        var firstSix: String?
//        var lastFour: String?
//        if let firstSixEndIndex = pan.index(pan.startIndex, offsetBy: 6, limitedBy: pan.endIndex),
//            let lastFourStartIndex = pan.index(pan.endIndex, offsetBy: -4, limitedBy: pan.startIndex) {
//            firstSix = String(pan[pan.startIndex..<firstSixEndIndex])
//            lastFour = String(pan[lastFourStartIndex..<pan.endIndex])
//        }
//
//        card = Card(
//            token: PaymentCardCreateRequest.fakeToken(),
//            firstSixDigits: SecureUtility.encryptedSensitiveFieldValue(firstSix) ?? "",
//            lastFourDigits: SecureUtility.encryptedSensitiveFieldValue(lastFour) ?? "",
//            nameOnCard: model.nameOnCard ?? "",
//            month: SecureUtility.encryptedSensitiveFieldValue("\(month)") ?? "",
//            year: SecureUtility.encryptedSensitiveFieldValue("\(year)") ?? "",
//            fingerprint: PaymentCardCreateRequest.fakeFingerprint(pan: pan, expiryYear: String(year), expiryMonth: String(month))
//        )
//
//        let timestamp = Date().timeIntervalSince1970
//        account = Account(consents: [Account.Consents(latitude: 0.0, longitude: 0.0, timestamp: Int(timestamp), type: 0)])
//    }

    /// This should only be used for creating genuine payment cards using Spreedly path in a production environment
    init?(spreedlyResponse: SpreedlyResponse, paymentAccount: PaymentAccountCreateModel) {
        let paymentMethodResponse = spreedlyResponse.transaction?.paymentMethod

        guard let firstSix = SecureUtility.encryptedSensitiveFieldValue(paymentMethodResponse?.firstSix) else {
            return nil
        }
        guard let lastFour = SecureUtility.encryptedSensitiveFieldValue(paymentMethodResponse?.lastFour) else {
            return nil
        }
        guard let month = SecureUtility.encryptedSensitiveFieldValue("\(paymentMethodResponse?.month ?? 0)") else {
            return nil
        }
        guard let year = SecureUtility.encryptedSensitiveFieldValue("\(paymentMethodResponse?.year ?? 0)") else {
            return nil
        }

        card = Card(
            token: paymentMethodResponse?.token ?? "",
            firstSixDigits: firstSix,
            lastFourDigits: lastFour,
            nameOnCard: paymentMethodResponse?.fullName ?? "",
            month: month,
            year: year,
            fingerprint: paymentMethodResponse?.fingerprint ?? "",
            cardNickname: paymentAccount.cardNickname
        )

        let timestamp = Date().timeIntervalSince1970
        account = Account(consents: [Account.Consents(latitude: 0.0, longitude: 0.0, timestamp: Int(timestamp), type: 0)])
    }
    
//    private static func fakeFingerprint(pan: String, expiryYear: String, expiryMonth: String) -> String {
//        // Based a hash of the pan, it's the key identifier of the card
//        let stringToHash = "\(pan)|\(expiryMonth)|\(expiryYear)"
//        return "TEST " + stringToHash.sha256
//    }
    
    private static func fakeToken() -> String {
        // A random string per request
        return String.randomString(length: 100)
    }
}
