import SwiftUI

struct CompassView: View {
	
	let pointerLength: CGFloat = 20
	let angels: [Double] = [0, 45, 90, 135]
	
    var body: some View {
		GeometryReader { geo in
			let size = min(geo.size.width, geo.size.height)
			VStack {
				ZStack {
					Circle()
						.stroke(
							LinearGradient(
								gradient: Gradient(colors: [Color.white, Color.gray]),
								startPoint: .topLeading, endPoint: .bottomTrailing
							)
							,lineWidth: size * 0.08
						)
						.scaleEffect(.init(0.92))
						.shadow(color: Color.gray, radius: 5, x: 5, y: 5)
						.shadow(color: Color.white, radius: 5, x: -5, y: -5)
						.clipShape(Circle())
						.shadow(radius: 20)
						.compositingGroup()
						.shadow(
							color: Color.white.opacity(0.9),
							radius: 10,
							x: -5,
							y: -5)
						.shadow(
							color: Color.gray.opacity(0.5),
							radius: 10,
							x: 5,
							y: 5)
					Circle()
						.stroke(Color.black, lineWidth: 2)
						.scaleEffect(.init(0.85))
					Circle()
						.stroke(Color.black, lineWidth: 2)
						.background(
							Circle()
								.fill(RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 10, endRadius: 230))
								.clipShape(
									Circle()
								)
						)
						.scaleEffect(.init(0.6))
						
					Circle()
						.stroke(Color.black, lineWidth: 2)
						.overlay (ZStack {
							ForEach(0..<angels.count) { index in
								VStack {
									Rectangle()
										.fill(LinearGradient(
											gradient: Gradient(colors: [Color.gray, Color.white]),
											startPoint: .topLeading, endPoint: .bottomTrailing
										))
										.frame(width: size*0.008, height: size*0.2)
									Spacer()
									Rectangle()
										.fill(LinearGradient(
											gradient: Gradient(colors: [Color.white, Color.gray]),
											startPoint: .topLeading, endPoint: .bottomTrailing
										))
										.frame(width: size*0.008, height: size*0.2)
								}
								.opacity(0.8)
								.rotationEffect(Angle.degrees(angels[index]))
							}
							.scaleEffect(.init(0.6))
						})
					DirectionsSymbolsView(size: size)
					DirectionPointer(size: size)
						.shadow(radius: 16)
					
					
				}.frame(width: size, height: size, alignment: .center)
			}
			.frame(alignment: .center)
	}
    }
}

struct DirectionPointer: View {
	let size: CGFloat
	@State var isRotated: Bool = false
	
	let widthScale: CGFloat = 0.06
	var body: some View {
		ZStack {
			Triangle()
				.fill(Color.red)
				.overlay(Triangle()
							.fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.red, Color.black.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
							.clipped(antialiased: true)
				)
				.clipped(antialiased: true)
				.scaleEffect(.init(width: widthScale, height: 0.4))
				.offset(x: 0, y: -size * 0.2)
			Triangle()
				.fill(Color.blue)
				.overlay(
					Triangle()
					.fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.blue, Color.black.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
						.clipped(antialiased: true)
				)
				.clipped(antialiased: true)
				.scaleEffect(.init(width: widthScale, height: 0.4))
				.offset(x: 0, y: -size * 0.2)
				.rotationEffect(.degrees(180))
			Circle()
				.fill(RadialGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color.black]), center: .center, startRadius: 1, endRadius: 600))
				.scaleEffect(.init(widthScale))
				.shadow(radius: 8)
		}
		.rotationEffect(Angle.degrees(isRotated ? 360 : 0))
		.animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: false))
		.onAppear(perform: {
			isRotated = true
		})
	}
}

struct DirectionsSymbolsView: View {
	let size: CGFloat
	
	var body: some View {
		ZStack {
			HStack {
				// <div>Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
				Image.init("letter-w")
					.resizable()
					.scaledToFit()
					.frame(width: size * 0.1, height: size * 0.1)
				Spacer()
				Image.init("letter-e")
					.resizable()
					.scaledToFit()
					.frame(width: size * 0.1, height: size * 0.1)
			}
			VStack {
				Image.init("letter-n")
					.resizable()
					.scaledToFit()
					.frame(width: size * 0.1, height: size * 0.1)
				Spacer()
				Image.init("letter-s")
					.resizable()
					.scaledToFit()
					.frame(width: size * 0.1, height: size * 0.1)
			}
		}
		.scaleEffect(.init(0.8))
	}
}

struct Triangle: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		path.move(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
		
		return path
	}
}


struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
		CompassView().padding()
    }
}
