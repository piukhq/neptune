//
//  MapViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/04/2022.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    let locationManager = CLLocationManager()

    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var annotations: [MKAnnotation] {
        bakeries.compactMap { bakery in
            let bakeryAnnoation = MKPointAnnotation()
            bakeryAnnoation.coordinate = bakery.location
            return bakeryAnnoation
        }
    }
    
    var bakeries: [BakeryModel] {
        return getLocalJSONData()?.features ?? []
    }
    
    func bakeryForAnnotation(_ annotation: MKAnnotation?) -> BakeryModel? {
        return bakeries.first(where: { $0.location.latitude == annotation?.coordinate.latitude && $0.location.longitude == annotation?.coordinate.longitude })
    }
    
    func streetAddressForBakery(_ bakery: BakeryModel) -> String? {
        return (bakery.properties.streetAddress ?? "") + "\n" + (bakery.properties.postalCode ?? "")
    }
    
    func formatOpeningHoursText(for bakery: BakeryModel) -> String {
        let hours = bakery.properties.openHours?.components(separatedBy: "],")
        let unwantedCharacters = "{\"[]}"
        var formattedHoursArray: [String] = []
        
        hours?.forEach { openingHour in
            var formattedHours = openingHour
            unwantedCharacters.forEach { char in
                formattedHours = formattedHours.replacingOccurrences(of: String(char), with: "")
            }
            formattedHours = formattedHours.replacingOccurrences(of: ",", with: " -")
            formattedHours = String(formattedHours.dropFirst())
            formattedHoursArray.append(formattedHours)
        }
        
        var formattedHoursString = ""
        
        for var openingHour in formattedHoursArray {
            if bakery.properties.postalCode == "VN02783" {
                if openingHour.last == " " {
                    openingHour.append(contentsOf: L10n.mapAnnotationCalloutClosed)
                }
            }
            
            formattedHoursString.append(contentsOf: "\(openingHour)\n")
        }

        formattedHoursString.removeLast(1)
        
        return formattedHoursString
    }
    
    private func getLocalJSONData() -> GailsBreadModel? {
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
