import Mortar

public class Session {
    
    public typealias DataTaskCompletion = (Result<Data, NSError>) -> Void
    
    public static func fetch(with request: URLRequest, completion: @escaping DataTaskCompletion) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response,
                let data = data {
                completion(.success(data))
            } else {
                completion(.failure(error! as NSError))
            }
        }
        task.resume()
    }
}
