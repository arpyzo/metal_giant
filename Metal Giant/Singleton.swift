class Singleton {
    
    private static var sharedNetworkManager: Singleton = {
        let networkManager = Singleton()
        
        print("INSIDE CLOSURE")
        
        return networkManager
    }()
    
    
    private init() {
        print("INSIDE INIT")
    }
    
    
    class func shared() -> Singleton {
        return sharedNetworkManager
    }
    
}
