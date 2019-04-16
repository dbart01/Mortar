import Foundation

public class Swapi {
    
    private static func base() -> URL {
        return URL(string: "http://swapi.co/api/")!
    }
    
    public static func people() -> URL {
        return self.base().appendingPathComponent("people")
    }
}
