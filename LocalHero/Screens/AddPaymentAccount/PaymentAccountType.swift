//
//  PaymentAccountType.swift
//  LocalHero
//
//  Created by Max Woodhams on 15/09/2019.
//  Copyright © 2019 Bink. All rights reserved.

import Foundation

enum PaymentAccountType: String, Codable {
        case visa = "Visa"
        case amex = "American Express"
        case mastercard = "Mastercard"
        case other = "Other"

        var redactedPrefix: String {
            return "••••   ••••   ••••   "
        }

        var logoName: String {
            switch self {
            case .amex:
                return "cardPaymentLogoAmEx"
            case .mastercard:
                return "cardPaymentLogoMastercard"
            case .visa:
                return "cardPaymentLogoVisa"
            case .other:
                return "other"
            }
        }

        var sublogoName: String {
            switch self {
            case .amex:
                return "cardPaymentSublogoAmEx"
            case .mastercard:
                return "cardPaymentSublogoMasterCard"
            case .visa:
                return "cardPaymentSublogoVisa"
            case .other:
                return "other"
            }
        }
        
        var paymentSchemeIdentifier: Int {
            switch self {
            case .other:
                return 3
            case .amex:
                return 2
            case .mastercard:
                return 1
            case .visa:
                return 0
            }
        }
        
        static let allValues: [PaymentAccountType] = [.amex, .mastercard, .visa]
        
        private var formatValues: FormatValues {
            let prefix: [PrefixContainable], length: Int, whitespaceIndexLocations: [Int]
            
            switch self {
                /* // IIN prefixes and length requriements retreived from https://en.wikipedia.org/wiki/Bank_card_number on Sep 15, 2019 */
            case .amex:
                prefix = ["34", "37"]
                length = 15
                whitespaceIndexLocations = [4, 11]
            case .mastercard:
                prefix = ["51"..."55", "2221"..."2720"]
                length = 16
                whitespaceIndexLocations = [4, 9, 14]
            case .visa:
                prefix = ["4"]
                length = 16
                whitespaceIndexLocations = [4, 9, 14]
            case .other:
                prefix = ["O"]
                length = 5
                whitespaceIndexLocations = []
            }

            return FormatValues(prefixes: prefix, length: length, whitespaceIndexLocations: whitespaceIndexLocations)
        }
        
        static func type(from fullPan: String?) -> PaymentAccountType? {
            guard let fullPan = fullPan, !fullPan.isEmpty,
                let card = PaymentAccountType.allValues.first(where: { $0.prefixValid(fullPan) }) else {
                return nil
            }

            return card
        }
        
        static func validate(fullPan: String?) -> Bool {
            guard let fullPan = fullPan?.replacingOccurrences(of: " ", with: ""), !fullPan.isEmpty,
                let _ = PaymentAccountType.allValues.first(where: { $0.fullyValidate(fullPan) }) else {
                    return false
            }
            
            return true
        }
        
        func fullyValidate(_ fullPan: String) -> Bool {
            return formatValues.isValid(fullPan)
        }
        
        func lengthRange() -> (length: Int, whitespaceIndexes: [Int]) {
            return (length: formatValues.length, whitespaceIndexes: formatValues.whitespaceIndexLocations)
        }
        
        private func prefixValid(_ fullPan: String) -> Bool {
            return formatValues.isPrefixValid(fullPan)
        }
    }

    fileprivate extension PaymentAccountType {
        struct FormatValues {
            let prefixes: [PrefixContainable]
            let length: Int
            let whitespaceIndexLocations: [Int]
            
            func isValid(_ fullPan: String) -> Bool {
                return isLengthValid(fullPan) && isPrefixValid(fullPan) && luhnCheck(fullPan)
            }
            
            func isPrefixValid(_ fullPan: String) -> Bool {
                guard !prefixes.isEmpty else { return true }
                return prefixes.contains { $0.hasCommonPrefix(with: fullPan) }
            }
            
            func isLengthValid(_ fullPan: String) -> Bool {
                return fullPan.count == length
            }
        }
        
        // from: https://gist.github.com/cwagdev/635ce973e8e86da0403a
        static func luhnCheck(_ fullPan: String) -> Bool {
            var sum = 0
            let reversedCharacters = fullPan.reversed().map { String($0) }
            for (idx, element) in reversedCharacters.enumerated() {
                guard let digit = Int(element) else { return false }
                switch ((idx % 2 == 1), digit) {
                case (true, 9): sum += 9
                case (true, 0...8): sum += (digit * 2) % 9
                default: sum += digit
                }
            }
            
            return sum % 10 == 0
        }
    }

    fileprivate protocol PrefixContainable {
        func hasCommonPrefix(with text: String) -> Bool
    }

    extension String: PrefixContainable {
        func hasCommonPrefix(with text: String) -> Bool {
            return hasPrefix(text) || text.hasPrefix(self)
        }
    }

    extension ClosedRange: PrefixContainable {
        func hasCommonPrefix(with text: String) -> Bool {
            // Cannot include Where clause in protocol conformance, so have to ensure Bound == String :(
            guard let lower = lowerBound as? String, let upper = upperBound as? String else { return false }
            
            let trimmedRange: ClosedRange<Substring> = {
                let length = text.count
                let trimmedStart = lower.prefix(length)
                let trimmedEnd = upper.prefix(length)
                return trimmedStart...trimmedEnd
            }()
            
            let trimmedText = text.prefix(trimmedRange.lowerBound.count)
            return trimmedRange ~= trimmedText
        }
    }
