import Foundation

enum NetworkError: Error {
    case invalidURL
    case resultIsEmpty
    case other(Error)
}

class NetworkService {
    private let jsonDecoder = JSONDecoder()
    private let urlString = "https://api.citybik.es/v2/networks/wienmobil-rad"
    
    func fetchCyclingStation(completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.resultIsEmpty))
                }
                return
            }
            
            do {
                let decodedObject = try self.jsonDecoder.decode(NetworkResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch let decodingError as DecodingError {
                DispatchQueue.main.async {
                    completion(.failure(.other(decodingError)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
            }
        }
        
        task.resume()
    }
}
