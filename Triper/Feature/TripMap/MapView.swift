//
//  MapView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 23/05/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
	@Binding var annotations: [MKAnnotation]
	@Binding var routes: [MKRoute]
    
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		return mapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		uiView.addOverlays(routes.map(\.polyline))
		uiView.addAnnotations(annotations)
		guard let visibleRect = routes.first?.polyline.boundingMapRect else {
			return
		}
		uiView.setVisibleMapRect(
			routes.map(\.polyline.boundingMapRect).reduce(visibleRect) { $0.union($1) },
			animated: true
		)
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		MapViewCoordinator()
	}
	
	class MapViewCoordinator: NSObject, MKMapViewDelegate {
		
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let render = MKPolylineRenderer(overlay: overlay)
			render.strokeColor = .systemBlue
			render.lineWidth = 3
			return render
		}
	}
}
