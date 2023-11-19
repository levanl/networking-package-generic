// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class NetworkManager {
    
    public static func fetchData<T: Decodable>(from apiURL: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data!)
                completion(.success(result))
            } catch {
                if let decodingError = error as? DecodingError {
                    print("Decoding Error: \(decodingError)")
                }
                completion(.failure(NetworkError.invalidData))
            }
        }.resume()
    }
    
}


public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
