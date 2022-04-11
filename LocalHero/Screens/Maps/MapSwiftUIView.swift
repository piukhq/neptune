//
//  MapSwiftUIView.swift
//  LocalHero
//
//  Created by Sean Williams on 11/04/2022.
//

import MapKit
import SwiftUI

struct MapSwiftUIView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    let viewModel = MapViewModel()

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.bakeries) {
            MapMarker(coordinate: $0.location)
        }
    }
}

struct MapSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapSwiftUIView()
    }
}

class MapViewModel {
    var bakeries: [BakeryModel] {
        return gailsBakeriesData?.features ?? []
    }
    
    var gailsBakeriesData: GailsBread?
    
    init() {
        self.gailsBakeriesData = readJSON()
    }
    
    func readJSON() -> GailsBread? {
        if let path = Bundle.main.path(forResource: "bakeries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let bakeriesData = try JSONDecoder().decode(GailsBread.self, from: data)
                return bakeriesData
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
}
