//
//  SettingsSwiftUIView.swift
//  LocalHero
//
//  Created by Sean Williams on 20/04/2022.
//

import SwiftUI

class SettingsViewModel: BarcodeService, ObservableObject {
    @Published var showingActionSheet = false
    
    let rowData = [SettingsRow(type: .currentLogin), SettingsRow(type: .changeEnvironment), SettingsRow(type: .logout)]
    
    var barcodeImage: UIImage? {
        return generateQRCode(from: Current.userManager.currentToken ?? "")
    }
    
    func action(for row: SettingsRow) {
        configureActionSheet(for: row)
        
        switch row.type {
        case .changeEnvironment:
            showingActionSheet = true
        case .logout:
            NotificationCenter.default.post(name: .shouldLogout, object: nil)
        default:
            break
        }
    }
    
    // MARK: - Action sheet
    
    var actionSheetTitle = ""
    var actionSheetButtons: [ActionSheet.Button] = []
    
    func configureActionSheet(for row: SettingsRow) {
        switch row.type {
        case .changeEnvironment:
            actionSheetTitle = "Choose Environment"
            actionSheetButtons = [
                .default(Text("Dev"), action: {
                    APIConstants.changeEnvironment(.dev)
                }),
                .default(Text("Staging"), action: {
                    APIConstants.changeEnvironment(.staging)
                }),
                .cancel()
            ]
        default:
            actionSheetTitle = ""
            actionSheetButtons = []
        }
    }
}

struct SettingsSwiftUIView: View {
    var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.rowData, id: \.self) { row in
                SettingsRowView(row: row)
            }
        }
        .listStyle(.plain)
    }
    
    struct SettingsRowView: View {
        enum Constants {
            static let qrCodeSize: CGFloat = 160
            static let imagePadding: CGFloat = 10
        }
        
        @ObservedObject var viewModel = SettingsViewModel()

        let row: SettingsRow

        var body: some View {
            Button {
                viewModel.action(for: row)
            } label: {
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
                                    .frame(width: Constants.qrCodeSize, height: Constants.qrCodeSize)
                                    .padding([.top, .bottom], Constants.imagePadding)
                            }
                            
                            Spacer()
                        }
                    }
                default:
                    HStack {
                        SettingsTextStack(row: row)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .frame(width: 7, height: 12, alignment: .center)
                            .foregroundColor(.gray)
                    }
                }
            }
            .actionSheet(isPresented: $viewModel.showingActionSheet) {
                ActionSheet(
                    title: Text(viewModel.actionSheetTitle),
                    buttons: viewModel.actionSheetButtons
                )
            }
        }
    }
}


struct SettingsTextStack: View {
    let row: SettingsRow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(row.title)
                .font(.system(size: 16))
            if let subtitle = row.subtitle {
                Text(subtitle)
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
            }
        }
        .padding([.top, .bottom], 5)
    }
}

struct SettingsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSwiftUIView()
    }
}
