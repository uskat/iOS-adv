//
//  MapViewController.swift
//  Navigation
//
//  Created by Diego Abramoff on 22.09.23.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    private lazy var mapView = MKMapView()
    private lazy var locationManager = CLLocationManager()
    private var transportButton = UIBarButtonItem()
    private var globeButton = UIBarButtonItem()
    private var isCar: Bool = true
    private var isRealisticMap: Bool = false
    
//MARK: - ITEMs
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .systemRed
        $0.text = "1. Long tap on map to choose destination\n2. Choose transport type on in the top right corner\n3. Press route button in the top right corner\nType globe button to change mapView configuration"
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
//MARK: - INITs
    override func loadView() {
        super.loadView()
        locationManager.delegate = self
        setupMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        navigationController?.navigationBar.tintColor = .white
        self.mapView.delegate = self
        showBarButton()
        checkUserLocationPermissions()
        addSourcePoint()
        mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
    }
    
//MARK: - METHODs
    private func showBarButton() {
        let routeButton = UIBarButtonItem(
            image: UIImage(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up"),
            style: .plain,
            target: self,
            action: #selector(routeButtonAction))
        routeButton.tintColor = .white
        transportButton = UIBarButtonItem(
            image: UIImage(systemName: "car.rear.and.tire.marks"),
            style: .plain,
            target: self,
            action: #selector(transportButtonAction))
        transportButton.tintColor = .white
        globeButton = UIBarButtonItem(
            image: UIImage(systemName: "globe"),
            style: .plain,
            target: self,
            action: #selector(globeButtonAction))
        globeButton.tintColor = .white
        navigationItem.rightBarButtonItems = [routeButton, transportButton, globeButton]
    }
    
    private func checkUserLocationPermissions() {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            print("........Шеф, все пропало!")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            locationManager.desiredAccuracy = 1000
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.userLocation.title = "Your location"
        default:
            print(".........  default?")
        }
    }
    
    func addSourcePoint() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(gestureRecognizer: )))
        mapView.addGestureRecognizer(longTap)
    }
    
    @objc private func longTapAction(gestureRecognizer: UILongPressGestureRecognizer) {
        mapView.removeOverlays(mapView.overlays)

        let touchLocation = gestureRecognizer.location(in: mapView)
        let realLocation = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        mapView.removeAnnotations(mapView.annotations)
        let point = MKPointAnnotation()
        point.coordinate = realLocation
        point.title = "-> Go to"
        mapView.addAnnotation(point)
        gestureRecognizer.state = UIGestureRecognizer.State.ended
    }
    
    private func makeRoute(to destinationLocation: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.transportType = isCar ? .automobile : .walking
        
        guard let userLocation = mapView.userLocation.location?.coordinate else { return }
        let sourcePlacemark = MKPlacemark(coordinate: userLocation)
        request.source = MKMapItem(placemark: sourcePlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                if let error = error {
                    print ("Error: \(error)")
                }
                return
            }
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    @objc private func routeButtonAction() {
        guard mapView.annotations.count > 1 else { return }
        guard let destinationPoint = mapView.annotations.last else { return }
        makeRoute(to: destinationPoint.coordinate)
    }
    
    @objc private func transportButtonAction() {
        isCar.toggle()
        if isCar {
            transportButton.image = UIImage(systemName: "car.rear.and.tire.marks")
        } else {
            transportButton.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        }
    }
    
    @objc private func globeButtonAction() {
        isRealisticMap.toggle()
        if isRealisticMap {
            globeButton.image = UIImage(systemName: "globe.europe.africa")
            mapView.preferredConfiguration = MKImageryMapConfiguration(elevationStyle: .flat)
        } else {
            globeButton.image = UIImage(systemName: "globe")
            mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        }
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -6),
        ])
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationPoint = locations.first?.coordinate else { return }
        mapView.setCenter(locationPoint, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(" === error = \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        
        renderer.setColors([
            UIColor(red: 0.02, green: 0.91, blue: 0.05, alpha: 1.0),
            UIColor(red: 1.0, green: 0.48, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
        ], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 3.0
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = .blue
//        renderer.lineWidth = 5
        return renderer
    }
}

private extension MKMapView  {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 100) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
