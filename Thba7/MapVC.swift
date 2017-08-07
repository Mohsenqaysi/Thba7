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
    let getMyCurrentLocationButton: UIButton = {
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 200)
        let bnt = UIButton(type: UIButtonType.system)
        bnt.setTitle("هذا مكاني", for: UIControlState.normal)
        bnt.titleLabel!.font =  UIFont.boldSystemFont(ofSize: 20)
        bnt.setTitleColor(UIColor.white, for: UIControlState.normal)
        bnt.backgroundColor = .red
        bnt.addTarget(self, action: #selector(handelCurrentLocation), for: .touchUpInside)
        bnt.viewCardThemeWithCornerRadius(radius: 0)
        return bnt
    }()
    
    func handelCurrentLocation() {
        print("going back to HomeCV...")
        currentLocation = self.locationManager.location
        self.performSegue(withIdentifier: "unwindTohomeCV", sender: self)
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var marker = GMSMarker()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 18.0
    
    /* List of places */
    // An array to hold the list of likely places.
    var nearestPlaceArray: [NearestPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Status bar
        // init
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        createMap()
        
//        self.mapView.settings.consumesGesturesInView = false
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognition))
//        view.addGestureRecognizer(panGestureRecognizer)
    }
    
//    func panRecognition(recognizer: UIPanGestureRecognizer) {
//        if marker.isDraggable {
//            let markerPosition = mapView.projection.point(for: marker.position)
//            let translation = recognizer.translation(in: view)
//            recognizer.setTranslation(.zero, in: view)
//            let newPosition = CGPoint(x: markerPosition.x + translation.x, y: markerPosition.y + translation.y)
//            marker.position = mapView.projection.coordinate(for: newPosition)
//        }
//    }
//    
    func createMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.isHidden = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        view.addSubview(getMyCurrentLocationButton)
        let tabBarHeigh = self.tabBarController?.tabBar.frame.size.height
        _ = mapView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: (tabBarHeigh! * 2), rightConstant: 0, widthConstant: 0, heightConstant: 0)
        print("tabBarHeigh: \(tabBarHeigh!)")
        _ = getMyCurrentLocationButton.anchor(mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: tabBarHeigh!, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeigh!)
    }
    
    func creaMarker(mapView: GMSMapView, lat: CLLocationDegrees, long: CLLocationDegrees) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: lat , longitude: long)
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
                    // Add data to the array
                    
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
