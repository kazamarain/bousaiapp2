import SwiftUI
import CoreLocation

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel

    var body: some View {
        VStack {
            Text("経度：" + String(coordinate?.longitude ?? 0))
            Text("緯度：" + String(coordinate?.latitude ?? 0))
        }
    }

    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
}

struct TrackingVie_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
            .environmentObject(LocationViewModel())
    }
}

import SwiftUI

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        Text(errorText)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorText: "エラーメッセージ")
    }
}
