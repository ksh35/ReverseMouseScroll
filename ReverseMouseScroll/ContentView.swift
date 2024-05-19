import SwiftUI

struct ContentView: View {
    @State private var reverseMouseScrolling = UserDefaults.standard.bool(forKey: "reverseMouseScrolling")
    @State private var permissionAlert = false
    var body: some View {
        VStack {
            Toggle(isOn: $reverseMouseScrolling){
                Text("Reverse only mouse scrolling")
            }.toggleStyle(.switch)
                .onChange(of: reverseMouseScrolling){oldVal, newVal in
                    UserDefaults.standard.set(newVal, forKey: "reverseMouseScrolling")
                    if(!manageEventTap(activated: newVal)){
                        UserDefaults.standard.set(false, forKey: "reverseMouseScrolling")
                        reverseMouseScrolling = false
                        permissionAlert = true
                    }
                }
            Button("Quit") {
                stopEventTap()
                NSApplication.shared.terminate(nil)
            }
        }.padding()
            .alert(isPresented: $permissionAlert){
                Alert(title: Text("Permission needed to enable reverse mouse scrolling"),
                      message: Text("To grant accessibility for reverse mouse scrolling, go to System Settings -> Privacy & Security -> Accessibility -> Toggle ReverseMouseScroll"),
                    dismissButton: .default(Text("Dismiss")))
        }
    }
}
