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
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        return mapView
    }()
    
    private let viewModel = MapViewModel()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        mapView.delegate = self
        addAnnotationsToMap()
        
        locationManager.requestWhenInUseAuthorization()
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
        
        configureDetailView(annotationView: annotationView)
        return annotationView
    }
    
    func configureDetailView(annotationView: MKAnnotationView?) {
        guard let bakery = viewModel.bakeryForAnnotation(annotationView?.annotation) else { return }
        
        let calloutView = UIStackView()
        calloutView.translatesAutoresizingMaskIntoConstraints = false
        calloutView.axis = .vertical
        
        
        let addressTitleLabel = UILabel()
        addressTitleLabel.text = "Address:"
        addressTitleLabel.font = .systemFont(ofSize: 10)
        
        let addressLabel = UILabel()
        addressLabel.text = viewModel.streetAddressForBakery(bakery)
        addressLabel.numberOfLines = 0
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        
        let openingHoursTitleLabel = UILabel()
        openingHoursTitleLabel.text = "Opening Hours:"
        openingHoursTitleLabel.font = .systemFont(ofSize: 10)
        
        let openingHoursLabel = UILabel()
        openingHoursLabel.text = bakery.properties.openHours
        
        calloutView.addArrangedSubview(addressTitleLabel)
        calloutView.addArrangedSubview(addressLabel)
        calloutView.addArrangedSubview(spacer)
        calloutView.addArrangedSubview(openingHoursTitleLabel)
        
        
        annotationView?.detailCalloutAccessoryView = calloutView
    }
}
