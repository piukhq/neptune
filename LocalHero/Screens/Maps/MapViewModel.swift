//
//  MapViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/04/2022.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var annotations: [MKAnnotation] {
        bakeries.compactMap { bakery in
            let bakeryAnnoation = MKPointAnnotation()
            bakeryAnnoation.title = bakery.properties.streetAddress
            bakeryAnnoation.coordinate = bakery.location
            return bakeryAnnoation
        }
    }
    
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
