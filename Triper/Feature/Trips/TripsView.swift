//
//  TripsView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import SwiftUI

struct TripsView: View {
	@State var isLiked: Bool = false
    var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack {
					NavigationLink(destination: Text("Destination")) {
						HStack {
							Spacer()
							VStack {
								HStack {
									Text("Oslo trip")
										.font(.title)
										.foregroundColor(Color(.label))
										.bold()
										
									Spacer()
									LikeButton(isLiked: $isLiked)
										.buttonStyle(HighPriorityButtonStyle())
								}
								TripInfoView(placesCount: 4, estimatedTime: "3:21 h", distance: 30.5)
							}
							Spacer()
						}
						.padding()
						.background(Color(.secondarySystemBackground))
						.cornerRadius(10)
						.shadow(radius: 5)
					}.buttonStyle(PlainButtonStyle())
					
				}.padding()
			}
			.navigationBarTitle("Trips")
		}
		
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
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

struct TripInfoView: View {
	let placesCount: Int
	let estimatedTime: String
	let distance: Double
	
	var body: some View {
		HStack {
			TripInfoCell(label: "Places", value: "\(placesCount)")
			dividerWithSpacers
			TripInfoCell(label: "Estimated time", value: "\(estimatedTime)")
			dividerWithSpacers
			TripInfoCell(label: "Distance", value: "\(distance) km")
		}
	}
	
	private var dividerWithSpacers: some View {
		Group {
			Spacer()
			Divider()
			Spacer()
		}
	}
}

struct TripInfoCell: View {
	let label: String
	let value: String
	
	var body: some View {
		VStack {
			Text(label)
				.font(.callout)
				.foregroundColor(Color(.label))
			Text(value)
				.foregroundColor(Color(.secondaryLabel))
		}
	}
}
