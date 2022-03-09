//
//  HeroButtonStack.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import SwiftUI

struct HeroButtonStack: View {
    var buttons: [HeroButton]
    var body: some View {
        VStack{
            ForEach(buttons) {
                $0
            }
            
        }

    }
}

struct HeroButtonStack_Previews: PreviewProvider {
    static var previews: some View {
        HeroButtonStack(buttons: [HeroButton(title: "Delete") {}, HeroButton(title: "Add Card") {}])
    }
}
