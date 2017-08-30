
//Build final --- from tutorial
//https://www.raywenderlich.com/166182/mapkit-tutorial-overlay-views

import UIKit
import MapKit

class ParkMapViewController: UIViewController {
  
  var selectedOptions : [MapOptionsType] = []
  
    @IBOutlet weak var mapView: MKMapView!
    
    var park = Park(fileName: "MagicMountain")
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        let latDelta = park.overlayTopLeftCoordinate.latitude -
            park.overlayBottomRightCoordinate.latitude
        
        // Think of a span as a tv size, measure from one corner to another
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake(park.midCoordinate, span)
        
        mapView.region = region
        
  }
  
    func loadSelectedOptions() {
        // TODO -- added
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        for option in selectedOptions {
            switch(option) {
            case .mapOverlay:
                addOverlay()
            case .mapPins:
                addAttractionPins()
            case .mapRoute:
                addRoute()
            case .mapBoundary:
                addBoundary()
            case .mapCharacterLocation:
                addCharacterLocation()
            }
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? MapOptionsViewController)?.selectedOptions = selectedOptions
    }
    
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        // TODO -- added
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    func addOverlay() {
        let overlay = ParkMapOverlay(park:park)
        mapView.add(overlay)
    }
    
    func addAttractionPins() {
        guard let attractions = Park.plist("MagicMountainAttractions") as? [[String: String]] else { return }
        
        for attraction in attractions {
            let coordinate = Park.parseCoord(dict: attraction, fieldName: "location")
            let title = attraction["name"] ?? ""
            let typeRawValue = Int(attraction["type"] ?? "0") ?? 0
            let type = AttractionType(rawValue: typeRawValue) ?? .misc
            let subtitle = attraction["subtitle"] ?? ""
            let annotation = AttractionAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func addRoute() {
        guard let points = Park.plist("EntranceToGoliathRoute") as? [String] else { return }
        
        let cgPoints = points.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        
        mapView.add(myPolyline)
    }
    
    func addBoundary() {
        mapView.add(MKPolygon(coordinates: park.boundary, count: park.boundary.count))
    }
    
    func addCharacterLocation() {
        mapView.add(Character(filename: "BatmanLocations", color: .blue))
        mapView.add(Character(filename: "TazLocations", color: .orange))
        mapView.add(Character(filename: "TweetyBirdLocations", color: .yellow))
    }
    
}


extension ParkMapViewController: MKMapViewDelegate {
    
    /*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ParkMapOverlay {
            let extractedExpr = #imageLiteral(resourceName: "overlay_park")
            return ParkMapOverlayView(overlay: overlay, overlayImage:extractedExpr)
        }
        
        return MKOverlayRenderer()
    }
    */
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ParkMapOverlay {
            print(#line, #function, "dbg-overlay:", overlay)
            return ParkMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "overlay_park"))
        } else if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.green
            return lineView
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magenta
            return polygonView
        } else if let character = overlay as? Character {
            let circleView = MKCircleRenderer(circle: character)
            circleView.strokeColor = character.color
            return circleView
        }
        
         return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = AttractionAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationView.canShowCallout = true
        return annotationView
    }
    
}




