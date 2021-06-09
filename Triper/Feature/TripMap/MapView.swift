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
	@Binding var selectedAnnotation: MKAnnotation
    
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		return mapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		uiView.addOverlays(routes.map(\.polyline))
		uiView.addAnnotations(annotations)
		uiView.selectedAnnotations = [selectedAnnotation]
		guard let visibleRect = routes.first?.polyline.boundingMapRect else {
			return
		}
		uiView.setVisibleMapRect(
			routes.map(\.polyline.boundingMapRect).reduce(visibleRect) { $0.union($1) },
			edgePadding: .init(top: 8, left: 16, bottom: 8, right: 16),
			animated: true
		)
	}
	
	func makeCoordinator() -> MapViewCoordinator {
		MapViewCoordinator(selectedAnnotation: $selectedAnnotation)
	}
	
	class MapViewCoordinator: NSObject, MKMapViewDelegate {
		
		init(selectedAnnotation: Binding<MKAnnotation>) {
			self._selectedAnnotation = selectedAnnotation
		}
		
		@Binding var selectedAnnotation: MKAnnotation
		
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let render = MKPolylineRenderer(overlay: overlay)
			render.strokeColor = .systemBlue
			render.lineWidth = 3
			return render
		}
		
		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let annotation = view.annotation {
				self.selectedAnnotation = annotation
			}
		}
	}
}
