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
    
    @ObservedObject var viewModel = MapViewModel()

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.bakeries) {
            MapMarker(coordinate: $0.location)
        }
        .navigationTitle("Neptune")
    }
}

struct MapSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapSwiftUIView()
    }
}
