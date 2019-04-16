import Mortar

public typealias JSON = [String : Any]

public class Parser {

    public static func parse(data: Data) -> Result<JSON, NSError> {
        do {
            let value = try JSONSerialization.jsonObject(with: data, options: [])
            return .success(value as! JSON)
        } catch {
            return .failure(error as NSError)
        }
    }
}
