//
//  SelectStartNodeTableViewCell.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import MapKit
import UIKit

final class SelectStartNodeTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeDirection: UILabel!
    @IBOutlet weak var nodeDistance: UILabel!

    @IBOutlet weak var mapView: MKMapView!

    private let nodeCoordinate = CLLocationCoordinate2D(
        latitude: 36.014099310928216,
        longitude: 129.32591317393107
    )

    static func nib() -> UINib {
        return UINib(nibName: "SelectStartNodeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.mapType = MKMapType.standard
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        mapView.isHidden = true
        mapView.removeAnnotations(mapView.annotations)
        self.backgroundColor = .clear
    }

    // MARK: 셀 확장 설정

    func settingData(isClicked: Bool) {
        mapView.isHidden = !isClicked
        self.backgroundColor = isClicked ? .duduBlue : .clear
        if isClicked {
            addCustomPin()
            mapView.setRegion(
                MKCoordinateRegion(
                    center: nodeCoordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.005,
                        longitudeDelta: 0.005
                    )
                ),
                animated: false
            )
        }
    }

    // MARK: 어노테이션 설정

    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = nodeCoordinate
        pin.title = nodeName.text
        pin.subtitle = nodeDirection.text
        mapView.addAnnotation(pin)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        var annotationView =
        mapView.dequeueReusableAnnotationView(withIdentifier: "BusNode") as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "BusNode")
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.glyphImage = UIImage(systemName: "bus.fill")
        annotationView?.markerTintColor = .duduDeepBlue
        annotationView?.canShowCallout = false

        return annotationView
    }
}
