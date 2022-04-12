//
//  MapViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 12/04/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setRegion(viewModel.region, animated: true)
        view.addSubview(mapView)
        return mapView
    }()
    
    private let viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        mapView.delegate = self
        addAnnotationsToMap()
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addAnnotationsToMap() {
        mapView.addAnnotations(viewModel.annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
