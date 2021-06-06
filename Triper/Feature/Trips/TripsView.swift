//
//  TripsView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import SwiftUI

struct TripsView: View {
	@StateObject var viewModel: TripsViewModel
	@State var isLiked: Bool = false
    var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack(spacing: 12) {
					ForEach(viewModel.trips, id: \.id) { trip in
						TripPreviewCell(tripName: trip.name, placesCount: trip.numberOfPlaces, estimatedTime: trip.estimatedTime.stringFromTimeInterval(), distance: trip.distance/1000, isLiked: $isLiked)
					}
					
				}.padding()
			}
			.onAppear { viewModel.loadTrips() }
			.loadingOverlay(viewModel.isLoading)
			.navigationBarTitle("Trips")
			.navigationBarItems(trailing: Toggle(isOn: $isLiked, label: {
				Image.init(systemName: "heart")
					.resizable()
					.scaledToFit()
					.frame(width: 32, height: 32)
			}))
		}
		
    }
	
	struct TripPreviewCell: View {
		let tripName: String
		let placesCount: Int
		let estimatedTime: String
		let distance: Double
		@Binding var isLiked: Bool
		
		var body: some View {
			NavigationLink(destination: TripPreviewView()) {
				HStack {
					Spacer()
					VStack {
						HStack {
							Text(tripName)
								.font(.title)
								.foregroundColor(Color(.label))
								.bold()
							
							Spacer()
							LikeButton(isLiked: $isLiked)
								.buttonStyle(HighPriorityButtonStyle())
						}
						TripInfoView(
							placesCount: placesCount,
							estimatedTime: estimatedTime,
							distance: distance
						)
					}
					Spacer()
				}
				.padding()
				.background(Color(.secondarySystemBackground))
				.cornerRadius(10)
				.shadow(radius: 5)
			}.buttonStyle(PlainButtonStyle())
		}
	}
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(viewModel: TripsViewModel())
    }
}

struct LikeButton: View {
	@Binding var isLiked: Bool
	
	var body: some View {
		Button(action: { isLiked.toggle() }) {
			ZStack {
				HeartImage(name: "heart")
				HeartImage(name: "heart.fill")
					.opacity(isLiked ? 1 : 0)
					.rotation3DEffect(
						isLiked ? .zero : .init(radians: 5),
						axis: (x: 1.0, y: 0.0, z: 0.5)
					)
					.scaleEffect(isLiked ? 1.0 : 0.1)
					.animation(.linear)
			}
			.foregroundColor(color)
			.colorMultiply(color)
		}
	}
	
	private var color: Color {
		isLiked ? Color(.systemRed).opacity(0.7) : Color(.systemGray)
	}
	
	private struct HeartImage: View {
		let name: String
		var body: some View {
			Image.init(systemName: name)
				.resizable()
				.scaledToFit()
				.frame(width: 40, height: 40)
		}
	}
}

struct HighPriorityButtonStyle: PrimitiveButtonStyle {
	func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
		MyButton(configuration: configuration)
	}
	
	private struct MyButton: View {
		@State var pressed = false
		let configuration: PrimitiveButtonStyle.Configuration
		
		var body: some View {
			let gesture = DragGesture(minimumDistance: 0)
				.onChanged { _ in self.pressed = true }
				.onEnded { value in
					self.pressed = false
					if value.translation.width < 10 && value.translation.height < 10 {
						self.configuration.trigger()
					}
				}
			
			return configuration.label
				.opacity(self.pressed ? 0.5 : 1.0)
				.highPriorityGesture(gesture)
		}
	}
}

extension Double {
	
	func stringFromTimeInterval() -> String {
		
		let time = NSInteger(self)
		
		let minutes = (time / 60) % 60
		let hours = (time / 3600)
		
		return String(format: "%0.2d:%0.2d h",hours,minutes)
		
	}
}
