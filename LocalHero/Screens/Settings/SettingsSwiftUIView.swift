//
//  SettingsSwiftUIView.swift
//  LocalHero
//
//  Created by Sean Williams on 20/04/2022.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct SettingsSwiftUIView: View {
    let viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.rowData, id: \.self) { row in
                SettingsRowView(row: row)
            }
        }
    }
    
    struct SettingsRowView: View {
        let row: SettingsRow
        let viewModel = SettingsViewModel()
        
        var body: some View {
            Button(action: row.type.action) {
                switch row.type {
                case .currentLogin:
                    VStack(alignment: .leading) {
                        SettingsTextStack(row: row)
                        HStack {
                            Spacer()
                            
                            if let image = viewModel.barcodeImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: 150.0, height: 150.0)
                                    .padding([.top, .bottom], 20)
                            }
                            
                            Spacer()
                        }
                    }
                default:
                    HStack {
                        SettingsTextStack(row: row)
                    }
                }
            }
        }
    }
}

struct SettingsTextStack: View {
    let row: SettingsRow
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(row.title)
            if let subtitle = row.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct SettingsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSwiftUIView()
    }
}


class SettingsViewModel: BarcodeService {
    let rowData = [SettingsRow(type: .currentLogin), SettingsRow(type: .changeEnvironment), SettingsRow(type: .logout)]
    
    var barcodeImage: UIImage? {
//        return generateBarcode(Current.userManager.currentToken ?? "")
        return generateQRCode(from: Current.userManager.currentToken ?? "")
    }
}

struct SettingsRow: Hashable {
    enum RowType {
        case currentLogin
        case changeEnvironment
        case logout
        
        var title: String {
            switch self {
            case .currentLogin:
                return "Current Login"
            case .changeEnvironment:
                return "Change Environment"
            case .logout:
                return "Logout"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .currentLogin:
                return Current.userManager.currentEmailAddress
            case .changeEnvironment:
                return APIConstants.baseURLString
            case .logout:
                return "Remove token from secure storage etc."
            }
        }
        
        func action() {
            switch self {
            case .changeEnvironment:
                print("Change env")
            case .logout:
                Current.navigate.close(animated: true) {
                    Current.navigate.back(toRoot: true, animated: true) {
                        Current.rootStateMachine.logout()
                    }
                }
            default:
                break
            }
        }
    }
    
    var type: RowType
    
    var title: String {
        return type.title
    }
    
    var subtitle: String? {
        return type.subtitle
    }
}

protocol BarcodeService {
    func generateBarcode(_ string: String) -> UIImage?
}

extension BarcodeService {
    func generateBarcode(_ string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
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
