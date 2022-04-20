//
//  SettingsSwiftUIView.swift
//  LocalHero
//
//  Created by Sean Williams on 20/04/2022.
//

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
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(row.title)
                    if let subtitle = row.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                    
                    if row.type == .currentLogin {
                        HStack {
                            Spacer()
                            Image(systemName: "pencil.tip")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct SettingsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSwiftUIView()
    }
}


class SettingsViewModel {
    let rowData = [SettingsRow(type: .currentLogin), SettingsRow(type: .changeEnvironment), SettingsRow(type: .logout)]
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
    }
    

    var type: RowType
    
    var title: String {
        return type.title
    }
    
    var subtitle: String? {
        return type.subtitle
    }
}
