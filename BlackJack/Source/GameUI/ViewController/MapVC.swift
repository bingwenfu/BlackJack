//
//  MapVC.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/21/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation

class MapVC: NSViewController, MKMapViewDelegate {
    
    @IBOutlet weak var labelBackgroundView: NSView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var homeButton: GrayTransparentRoundButton!
    var annotationMap = Dictionary<String, Bool>()
    
    override func viewDidLoad() {
        mapView.delegate = self
        homeButton.setCenterImageWithName("home")
        centerMapAtUnitedStates()
        labelBackgroundView.wantsLayer = true
        labelBackgroundView.layer?.cornerRadius = labelBackgroundView.h/2.0
        labelBackgroundView.layer?.backgroundColor = NSColor.blackColor().CGColor
        labelBackgroundView.layer?.opacity = 0.4
    }
    
    // MARK: Handel Action
    // ----------------------------------------------------------------
    
    @IBAction func homeButtonClicked(sender: AnyObject) {
        self.dismissController(nil)
    }
    
    func annotationButtonClicked(button: AnnotationButton) {
        if let urlStr = button.annotationWebUrlString {
            system("open -a safari \(urlStr)")
        }
    }

    
    // MARK: MKMapView Delegate
    // ----------------------------------------------------------------
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        searchAndShowOnMapOfNearBy("casino")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CasinoAnnotation {
            
            let button = AnnotationButton()
            button.annotationWebUrlString = annotation.subtitle!
            button.responseFunc = { str in
                if let url = str {
                    system("open -a safari \(url)")
                }
            }
            
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "sdc")
            annotationView.animatesDrop = true
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = button
            return annotationView
        }
        return nil
    }
    
    // MARK: Helper function
    // ----------------------------------------------------------------
    
    func centerMapAtUnitedStates() {
        let spanLevel = 2500000.0
        let coordi = CLLocationCoordinate2DMake(40.1097, -98.2042)
        let region = MKCoordinateRegionMakeWithDistance(coordi, spanLevel, spanLevel)
        mapView.setRegion(region, animated: false)
    }
    
    func addMapItemsToMapAnnotations(mapItems: [MKMapItem]) {
        for item in mapItems {
            guard let name = item.name else { continue }
            guard annotationMap[name] == nil else { continue }
            
            let coordinate = item.placemark.coordinate
            let urlStr = item.url?.relativeString
            let annotation = CasinoAnnotation(coordinate: coordinate, title:name, subtitle: urlStr)
            self.mapView.addAnnotation(annotation)
            self.annotationMap[name] = true
        }
    }
    
    func searchAndShowOnMapOfNearBy(object: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = object
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler() { res, err in
            guard let response = res else { return print("Search error: \(err)") }
            self.addMapItemsToMapAnnotations(response.mapItems)
        }
    }
}


