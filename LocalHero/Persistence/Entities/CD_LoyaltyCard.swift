import Foundation

@objc(CD_LoyaltyCard)
open class CD_LoyaltyCard: _CD_LoyaltyCard, WalletCardProtocol {
    var type: WalletCardType {
        return .loyalty
    }
	// Custom logic goes here.
}
