////
////  MapVC.swift
////  Thba7
////
////  Created by Mohsen Qaysi on 8/3/17.
////  Copyright © 2017 Mohsen Qaysi. All rights reserved.
////
//
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

struct ConstrucURL {
    var lat: Double?
    var long: Double?
    var key: String?
    
    init(lat: Double, long: Double, key: String) {
        self.lat = lat
        self.long = long
        self.key = key
    }
    func getNearByURL() -> String {
        var url: String! = ""
   
//        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=21.5014766075092,39.1828934848309&radius=10&&key=AIzaSyD1alfLEREzjLBq8AyWPURxqvQ1bv_2TCo"
        if let lat = lat, let long = long, let key = key {
            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=10&key=\(key)"
        }
        return url
    }
    
    func getGecodeURL() -> String {
        var url: String! = ""
        if let lat = lat, let long = long, let key = key {
            url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=\(key)"
        }
        return url
    }
}
struct CurrentLocatioData {
    let locationAddress: String?
    let placeID: String?
}

struct Type{
    let route = "route"
    let street = "street_address"
    let locality = "locality"
    let political = "political"
}
class MapVC: UIViewController, GMSMapViewDelegate {
    
    let key = "AIzaSyD1alfLEREzjLBq8AyWPURxqvQ1bv_2TCo"
    var mapView: GMSMapView!
    var currentLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var zoomLevel: Float = 15.0
    var placesClient: GMSPlacesClient!
    
    var currentLocatioData: CurrentLocatioData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        createMap()
        
        /*
         // Create a center-fix marker
         
         let circleView = CustomMarker()
         view.addSubview(circleView)
         //        view.bringSubview(toFront: circleView)
         
         circleView.translatesAutoresizingMaskIntoConstraints = false
         let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
         let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
         let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
         let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
         NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
         
         view.updateConstraints()
         */
    }
    
    override func didReceiveMemoryWarning() {
        print("To much memory useage...")
    }
    
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
        //        self.performSegue(withIdentifier: "unwindTohomeCV", sender: self)
        // Pass the new location and fetch the JSON data
        // with: "formatted_address" and "place_id"
        fetchNearestPlaceAroundCoordinate(coordinates: currentLocation!)
    }
    
    func createMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 16.533593,
                                              longitude: 42.798357, zoom: 15)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        view.addSubview(getMyCurrentLocationButton)
        
        let tabBarHeigh = self.tabBarController?.tabBar.frame.size.height
        _ = mapView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: (tabBarHeigh! * 2), rightConstant: 0, widthConstant: 0, heightConstant: 0)
        print("tabBarHeigh: \(tabBarHeigh!)")
        _ = getMyCurrentLocationButton.anchor(mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: tabBarHeigh!, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeigh!)
    }
    
    func creaMarker(mapView: GMSMapView, coordinates: CLLocationCoordinate2D, title: String?, subtitle: String? ) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude , longitude: coordinates.longitude)
        marker.title = title
        marker.snippet = subtitle
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("new location: \(position.target.latitude),\(position.target.longitude)")
        self.creaMarker(mapView: mapView, coordinates: position.target, title: nil, subtitle: nil)
        //MARK: Update the currentLocation realTime
        currentLocation = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("Long tap - new location: \(coordinate.latitude) \(coordinate.longitude)")
        self.creaMarker(mapView: mapView, coordinates: coordinate, title: nil, subtitle: nil)
    }
    
    // MARK: Handel JSON data
    func fetchNearestPlaceAroundCoordinate(coordinates: CLLocationCoordinate2D) {
        let requestURL = ConstrucURL(lat: coordinates.latitude, long: coordinates.longitude, key: key).getGecodeURL();
        
        Alamofire.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let results = json["results"].arrayValue.first
                if let address = results?["formatted_address"].stringValue, let placeID = results?["place_id"].stringValue {
                    print("Address: \(address)")
                    print("ID: \(placeID)")
                    self.currentLocatioData = CurrentLocatioData(locationAddress: address, placeID: placeID)
                    self.likelyPlace(coordinates: coordinates)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func likelyPlace(coordinates: CLLocationCoordinate2D){
        let requestURL = ConstrucURL(lat: coordinates.latitude, long: coordinates.longitude, key: key).getNearByURL();       print("requestURL: \(requestURL)")
        
        Alamofire.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print(json)
                let results = json["results"].arrayValue
                for result in results {
                    let types = result["types"].arrayValue
                    for type in types {
                        if type != "route" && type != "locality" && type != "political" && type != "street" {
                            print(type)
                            let locationName = result["name"].stringValue
                            let vicinity = result["vicinity"].stringValue
                            print("locationName: \(locationName)")
                            print("vicinity: \(vicinity)")
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
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
        //        likelyPlaces()
    }
    
    // Populate the array with the list of likely places.
    
    func likelyPlaces() {
        // Clean up from previous sessions.
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let likely = placeLikelihoodList.likelihoods.first?.likelihood
                    
                    print("---------------------------------")
                    print("Current Place name \(place.name) with likleyhood of: \(String(describing: likely))")
                    print("Current Coordinate \(place.coordinate)")
                    print("Current Place address \(String(describing: place.formattedAddress!))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)")
                    print("---------------------------------")
                }
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
            //MARK: Display the map using the default location.
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
