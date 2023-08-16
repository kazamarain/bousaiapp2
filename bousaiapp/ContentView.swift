import SwiftUI
import CoreLocation
import Combine
import UIKit
import MapKit

class MapViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = viewModel.coordinate
        uiView.setCenter(coordinate, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        // Other MKMapViewDelegate methods...
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    
    var body: some View {
        MapViewRepresentable(viewModel: viewModel)
    }
}

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

