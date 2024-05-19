import SwiftUI

@main
struct ReverseMouseScrollApp: App {
    init(){
        let reverseMouse:Bool = UserDefaults.standard.bool(forKey: "reverseMouseScrolling")
        if(!manageEventTap(activated: reverseMouse)){
            UserDefaults.standard.set(false, forKey: "reverseMouseScrolling")
        }
        
    }
    var body: some Scene {
        MenuBarExtra("main", systemImage: "scroll") {
            ContentView()
        }.menuBarExtraStyle(.window)
    }
}
public func manageEventTap(activated:Bool)->Bool{
    if activated{
        return startEventTap()
    }else{
        stopEventTap()
    }
    return true
}
