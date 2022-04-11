//
//  MapViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/04/2022.
//

import Foundation

class MapViewModel: ObservableObject {
    var bakeries: [BakeryModel] {
        return getLocalJSONData()?.features ?? []
    }
    
    func getLocalJSONData() -> GailsBreadModel? {
        if let path = Bundle.main.path(forResource: "bakeries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let bakeriesData = try JSONDecoder().decode(GailsBreadModel.self, from: data)
                return bakeriesData
            } catch {
                print(error.localizedDescription)
                print(String(describing: error))
            }
        }
        
        return nil
    }
}
