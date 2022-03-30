import Foundation

@objc(CD_PaymentAccount)
open class CD_PaymentAccount: _CD_PaymentAccount {
	// Custom logic goes here.
    
    var formattedImages: Set<CD_Image>? {
        return images as? Set<CD_Image>
    }
}
