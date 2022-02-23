//
//  World.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Foundation

let Current = World()

class World {
    lazy var rootStateMachine = RootStateMachine()
    lazy var apiClient = APIClient()
    lazy var userManager = UserManager()    
}
