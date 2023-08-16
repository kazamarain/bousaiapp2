
import SwiftUI

struct ContentView: View {
    
    @State private var selection: Int = 1
    
    var body: some View {
        TabView(selection: $selection) {
            
            UserLocationMapView()
                .tabItem {
                    Label("UserLocation", systemImage: "location.fill")
                }.tag(2)
            
        }
    }
}
        
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
