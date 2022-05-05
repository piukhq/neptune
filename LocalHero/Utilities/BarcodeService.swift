//
//  BarcodeService.swift
//  LocalHero
//
//  Created by Sean Williams on 20/04/2022.
//

import CoreImage.CIFilterBuiltins
import UIKit

protocol BarcodeService {}

extension BarcodeService {
    func generateQRCode(from string: String) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let context = CIContext()
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
