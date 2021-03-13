import SwiftUI
import Foundation


struct NewTripView: View {
	
	var body: some View {
		NavigationView {
			ZStack {
				VStack {
					Spacer()
					Text("Starting place")
					Circle()
						.fill(Color.yellow)
				}
				.padding(.horizontal, 16)
			}
			.navigationBarTitle("New Trip", displayMode: .inline)
		}
		
	}
}

struct NewTripView_Previews: PreviewProvider {
	static var previews: some View {
		NewTripView()
	}
}
