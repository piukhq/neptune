//
//  HeroButton.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import SwiftUI

class ButtonViewModel: ObservableObject {
    @Published var disabled: Bool?
    @Published var isLoading = false
    
    var title: String
    var action: () -> Void

    init(disabled: Bool? = true, title: String, action: @escaping () -> Void) {
        self.disabled = disabled
        self.title = title
        self.action = action
    }
}

struct HeroButton: View, Identifiable {
    @ObservedObject var viewModel: ButtonViewModel
    var id: String { viewModel.title }


    var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.title)
                .font(Font.headline)
        }
        .disabled(viewModel.disabled ?? false)
    }
}

struct HeroButton_Previews: PreviewProvider {
    
    static var previews: some View {
        HeroButton(viewModel: ButtonViewModel(title: "Add", action: {}))
    }
}
