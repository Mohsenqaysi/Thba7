//
//  MapVC.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 8/3/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

struct NearestPlace {
    let name: String?
    let address: String?
    let likelihood: Double?
    let coordinate: CLLocationCoordinate2D?
}

class MapVC: UIViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 18.0
    
    /* List of places */
    // An array to hold the list of likely places.
    var nearestPlaceArray: [NearestPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        createMap()
    }
    
    func createMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        //        if let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude {
        //            print("Current location: \(lat) and \(long)")
        //            creaMarker(mapView: mapView, lat: lat , long: long)
        //        }
        mapView.isHidden = true
    }
    
    func creaMarker(mapView: GMSMapView, lat: CLLocationDegrees, long: CLLocationDegrees) {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat , longitude: long)
        marker.isDraggable = true
        if let name = nearestPlaceArray.first?.name , let address = nearestPlaceArray.first?.address {
            marker.title = name
            marker.snippet = address
        }
        marker.map = mapView
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        // Populate the array with the list of likely places.
        likelyPlaces()
    }
    
    // Populate the array with the list of likely places.
    func likelyPlaces() {
        // Clean up from previous sessions.
        
        nearestPlaceArray.removeAll()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let likely = placeLikelihoodList.likelihoods.first?.likelihood
                    self.nearestPlaceArray.append(NearestPlace(name: place.name, address: place.formattedAddress, likelihood: likely , coordinate: place.coordinate))
                    
                    print("---------------------------------")
                    print("Current Place name \(place.name)")
                    print("Current Coordinate \(place.coordinate)")
                    print("Current Place address \(String(describing: place.formattedAddress!))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)")
                    print("---------------------------------")
                }
            }
            if let lat = self.locationManager.location?.coordinate.latitude, let long = self.locationManager.location?.coordinate.longitude {
                print("Current location: \(lat) and \(long)")
                self.creaMarker(mapView: self.mapView, lat: lat , long: long)
            }
        })
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
