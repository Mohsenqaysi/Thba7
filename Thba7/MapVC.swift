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
    func getNearByURL(radius: Int) -> String {
        var url: String! = ""
        
        if let lat = lat, let long = long, let key = key {
            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&language=ar&location=\(lat),\(long)&radius=\(radius)&key=\(key)"
        }
        return url
    }
    
    func getGecodeURL() -> String {
        var url: String! = ""
        if let lat = lat, let long = long, let key = key {
            url = "https://maps.googleapis.com/maps/api/geocode/json?&language=ar&latlng=\(lat),\(long)&key=\(key)"
        }
        return url
    }
}

struct LikelyHoodsLocationsData {
    let nearByPlace: String!
    let locationAddress: String!
    let latLng: Geometry!
}

struct Geometry {
    let lat: String!
    let lng : String!
}

var zoomLevel: Float = 15.0


class MapVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var searchResultsItemButton: UIBarButtonItem!
    //    let vc = PickNearestPlaceTVC()
    let key = "AIzaSyD1alfLEREzjLBq8AyWPURxqvQ1bv_2TCo"
    var mapView: GMSMapView!
    var currentLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var radius: Int = 300
    var placesClient: GMSPlacesClient!
    
    var camera = GMSCameraPosition.camera(withLatitude: 16.533593,
                                          longitude: 42.798357, zoom: zoomLevel)
    
    var likelyHoodsLocationsData: LikelyHoodsLocationsData? = nil
    var likelyHoodsLocationsDataArray = [LikelyHoodsLocationsData]()
    var filteredData = [LikelyHoodsLocationsData]()
    
    let loader: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()//frame: CGRect(x: 0, y: 0, width: withd/3, height: 400))
        spinner.layer.cornerRadius = 3
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.backgroundColor = UIColor.darkGray
        spinner.layer.opacity = 0.9
        return spinner
    }()
    
    func centerTheLoderOnTheScreen() {
        view.addSubview(loader)
        loader.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if likelyHoodsLocationsDataArray.isEmpty {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 30
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        createMap()
        //        marker.isDraggable = true
        
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
        
        //        let pressGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePress))
        //        view.addGestureRecognizer(pressGestureRecognizer)
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        print("ended")
    //        let lastLocation = CLLocationCoordinate2D(latitude: (locations.last?.coordinate.latitude)!, longitude:  (locations.last?.coordinate.longitude)!)
    ////        fetchNearestPlaceAroundCoordinate(coordinates: lastLocation)
    //
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        likelyHoodsLocationsDataArray = []
    }
    override func didReceiveMemoryWarning() {
        print("To much memory useage...")
    }
    
    @IBAction func showNearBy(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "placesID", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "placesID" {
            if let vc = segue.destination as? PickedPlacesVC {
                vc.likelyPlacesTableDataArray = filteredData
                let backItem = UIBarButtonItem()
                backItem.title = "رجوع"
                navigationItem.backBarButtonItem = backItem
                // Pass the title
                vc.title = "أختر المكان الأقرب لك"
            }
        }
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
        print("Find Loaction around me .....")
        //        self.performSegue(withIdentifier: "unwindTohomeCV", sender: self)
        // Pass the new location and fetch the JSON data
        // with: "formatted_address" and "place_id"
        fetchNearestPlaceAroundCoordinate(coordinates: currentLocation!)
    }
    
    func createMap() {
        
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
        _ = mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: (tabBarHeigh! * 2), rightConstant: 0, widthConstant: 0, heightConstant: 0)
        print("tabBarHeigh: \(tabBarHeigh!)")
        _ = getMyCurrentLocationButton.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: tabBarHeigh!, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeigh!)
        
        //MARK: add the view on top of the currentButton and hide it until the data are available and show it
        
    }
    
    func createMarker(mapView: GMSMapView, coordinates: CLLocationCoordinate2D, title: String?, subtitle: String? ) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude , longitude: coordinates.longitude)
        marker.title = title
        marker.snippet = subtitle
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("new location: \(position.target.latitude),\(position.target.longitude)")
        self.createMarker(mapView: mapView, coordinates: position.target, title: nil, subtitle: nil)
        //MARK: Update the currentLocation realTime
        currentLocation = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
    }
    
    
    
    // MARK: Handel JSON data
    func fetchNearestPlaceAroundCoordinate(coordinates: CLLocationCoordinate2D) {
        let requestURL = ConstrucURL(lat: coordinates.latitude, long: coordinates.longitude, key: key).getGecodeURL();
        centerTheLoderOnTheScreen()
        loader.startAnimating()
        Alamofire.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let results = json["results"].arrayValue.first
                if let address = results?["formatted_address"].stringValue, let placeID = results?["place_id"].stringValue {
                    print("Address: \(address)")
                    print("ID: \(placeID)")
                    self.likelyPlace(address: address, coordinates: coordinates)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        print("I am back... form unwind Call")
        if let location = segue.source as? PickedPlacesVC {
            //            print("Current location is: \(String(describing: location.currentLocation?.coordinate))")
            print("Current location is: \(String(describing: location.nearestPickedPlaceByUser?.nearByPlace))")
            let lat = Double((location.nearestPickedPlaceByUser?.latLng.lat)!)
            let lng =  Double((location.nearestPickedPlaceByUser?.latLng.lng)!)
            let pickedLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            let title = location.nearestPickedPlaceByUser?.nearByPlace
            let subtitle = location.nearestPickedPlaceByUser?.locationAddress
            let newMarkerPosion = GMSCameraPosition.camera(withLatitude: lat!, longitude: lng!, zoom: zoomLevel)
            mapView.animate(to: newMarkerPosion)
            self.createMarker(mapView: mapView, coordinates: pickedLocation ,title:title , subtitle: subtitle)
        }
    }
    
    func likelyPlace(address: String, coordinates: CLLocationCoordinate2D){
        let requestURL = ConstrucURL(lat: coordinates.latitude, long: coordinates.longitude, key: key).getNearByURL(radius: radius);
        //MARK: clear the array
        self.likelyHoodsLocationsDataArray.removeAll()
        Alamofire.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let results = json["results"].arrayValue
                for result in results {
                    let types = result["types"].arrayValue
                    for type in types {
                        if type != "route" && type != "locality" && type != "political" && type != "street" {
                            print(type)
                            let nearByPlace = result["name"].stringValue
                            let city = result["vicinity"].stringValue
                            print("-------------------------------")
                            print("locationName: \(nearByPlace)")
                            print("vicinity: \(city)")
                            let location = result["geometry"]["location"]
                            let lat = location["lat"].stringValue
                            let lng = location["lng"].stringValue
                            print("location: \(lat) and \(lng)")
                            print("-------------------------------")
                            self.marker.title = nearByPlace
                            self.marker.snippet = city
                            let geometyLocation = Geometry(lat: lat, lng: lng)
                            self.likelyHoodsLocationsData = LikelyHoodsLocationsData(nearByPlace: nearByPlace, locationAddress: address, latLng: geometyLocation)
                            self.likelyHoodsLocationsDataArray.append(self.likelyHoodsLocationsData!)
                        }
                    }
                    self.likelyPlaces(likelyHoodArray: self.likelyHoodsLocationsDataArray)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    /*
     //    // Handle incoming location events.
     //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //        let location: CLLocation = locations.last!
     //        print("Location: \(location)")
     //
     //        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
     //                                              longitude: location.coordinate.longitude,
     //                                              zoom: zoomLevel)
     //        if mapView.isHidden {
     //            mapView.isHidden = false
     //            mapView.camera = camera
     //        } else {
     //            mapView.animate(to: camera)
     //        }
     //        // Populate the array with the list of likely places.
     //        //        likelyPlaces()
     //    }
     */
    
    // Populate the array with the list of likely places.
    
    func likelyPlaces(likelyHoodArray: [LikelyHoodsLocationsData]) {
        
        let newArray = Array<LikelyHoodsLocationsData>().removeDublicate(places: likelyHoodArray)
        filteredData = newArray
        for place in newArray {
            print(place.nearByPlace)
        }
        print(newArray.count)
        print(newArray)
        print("------------------------------")
        loader.stopAnimating()
        self.navigationController?.isNavigationBarHidden = false
        searchResultsItemButton.isEnabled = true
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

extension Array {
    func removeDublicate (places: [LikelyHoodsLocationsData]) -> [LikelyHoodsLocationsData] {
        var newSet = [LikelyHoodsLocationsData]()
        var temp = [String]()
        for i in places.enumerated() {
            if temp.contains(i.element.nearByPlace) {
            } else {
                temp.append(i.element.nearByPlace)
                newSet.append(i.element)
            }
        }
        return newSet
    }
}
