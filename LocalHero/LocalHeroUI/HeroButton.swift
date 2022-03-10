//
//  HeroButton.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import SwiftUI

struct HeroButton: View, Identifiable {
    @ObservedObject var dataSource: FormDataSource
    var title: String
    var id: String { title }
    var buttonTapped: () -> Void
    
    var body: some View {
        Button(action: buttonTapped) {
            Text(title)
                .font(Font.headline)
        }
        .disabled(!dataSource.formIsValid)
    }
}

struct HeroButton_Previews: PreviewProvider {
    
    static var previews: some View {
        HeroButton(dataSource: FormDataSource(), title: "Add Payment Card", buttonTapped: {})
    }
}
