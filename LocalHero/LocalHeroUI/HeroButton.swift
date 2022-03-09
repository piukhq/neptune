//
//  HeroButton.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import SwiftUI

struct HeroButton: View, Identifiable {
    var title: String
    var buttonTapped: () -> Void
    var id: String { title }
    
    var body: some View {
        Button(action: buttonTapped) {
            Text(title)
                .font(Font.headline)
        }
    }
}

struct HeroButton_Previews: PreviewProvider {
    
    static var previews: some View {
        HeroButton(title: "Hey") {
            
        }
    }
}
