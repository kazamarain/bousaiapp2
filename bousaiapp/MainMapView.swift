import SwiftUI
import MapKit

struct MainMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel // 1. Pass LocationViewModel
    @State private var isShowingCurrentLocation = false
    @State private var region: MKCoordinateRegion // 2. Use State for region

    init() {
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.689607, longitude: 139.700571),
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("地震情報")
                    .fontWeight(.heavy)
                HStack {
                    Text(isShowingCurrentLocation ? "現在地" : "全国")
                        .font(.title)
                        .padding()
                    
                    Toggle(isOn: $isShowingCurrentLocation) {}
                        .padding()
                }

                Map(coordinateRegion: $region, interactionModes: .pan, showsUserLocation: false)
                    .frame(width: min(geometry.size.width, geometry.size.height),
                           height: min(geometry.size.width, geometry.size.height))
                    .cornerRadius(16)
            }
        }
        .onAppear {
            // 3. Update region with the last known location
            if let coordinate = locationViewModel.lastSeenLocation?.coordinate {
                region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 10000,
                    longitudinalMeters: 10000
                )
            }
        }
    }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
            .environmentObject(LocationViewModel())
    }
}

