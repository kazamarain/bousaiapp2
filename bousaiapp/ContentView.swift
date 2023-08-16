////
////  ContentView.swift
////  bousaiapp
////
////  Created by ユウ・カザマ on 2023/07/26.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}


import SwiftUI
import CoreLocation
import Combine
import UIKit
import MapKit


// MapViewModelを定義
class MapViewModel: ObservableObject {
    // 地図の中心座標
    @Published var coordinate: CLLocationCoordinate2D
    // その他のプロパティ
    // ...

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    // 他の必要なメソッドや関数を追加することもできます
    // ...
}

// MapViewを定義
struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel

    // MKMapViewを作成して返す
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    // 地図の表示更新などを行う
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 地図の中心座標を更新
        let coordinate = viewModel.coordinate
        uiView.setCenter(coordinate, animated: true)

        // 他の必要な更新処理を実行
        // ...
    }

    // Coordinatorを作成
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinatorを定義
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // 必要なMKMapViewDelegateのメソッドを実装
        // ...
    }
}

// ContentViewでMapViewを使う例
struct ContentView: View {
    // MapViewModelを作成
    @StateObject private var viewModel = MapViewModel(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    
    var body: some View {
        MapView(viewModel: viewModel)
    }
}



struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    // The center of the map.
    private var coordinate: CLLocationCoordinate2D
    private let mapView = MKMapView(frame: .zero)
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        self.coordinate = viewModel.mapCenter
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        print("map new coordinate", coordinate)
        view.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        var changeCurrentLocation: ((CLLocationCoordinate2D) -> Void)?

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            //print(mapView.centerCoordinate)
            print("** mapViewDidChangeVisibleRegion ** \(parent.viewModel.latitude)")
            
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            print("User location\(userLocation.coordinate) \(parent.viewModel.latitude)")
        }

        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            print("Map will start loading \(parent.viewModel.latitude)")
        }
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("Map did finish loading \(parent.viewModel.latitude)")
        }

        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            print("Map will start locating user \(parent.viewModel.latitude)")
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }
}

