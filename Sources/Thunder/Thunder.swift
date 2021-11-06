import Foundation
import Combine

public class Thunder: Restfulable, Parseable {
    
    public static func parserToData<T: Codable>(from model: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return try? encoder.encode(model)
    }
    
        
    public static func parser<T>(from data: Data, to: T.Type, dateFormat: JSONDecoder.DateDecodingStrategy = .iso8601) -> T? where T : Decodable, T : Encodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateFormat
        
        return try? decoder.decode(T.self, from: data)
    }
    
    public static func send<T>(model: T.Type, _ request: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void)
        where T : Codable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            switch(BasicRequest.handleBasicResponse(with: data, response: response, error: error)) {
                
                case .success(let data):
                     guard let model = Thunder.parser(from: data, to: T.self) else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                               
                    completion(.success(model))
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
            }
        })
        
        task.resume()
    }
    
    public static func send<T>(model: T.Type, _ request: URLRequest, decoder: JSONDecoder = BasicRequest.thunderDecoder) -> AnyPublisher<T, RequestError> where T : Codable {
        
        let sessionPublisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                try BasicRequest.handleBasicResponse(with: output)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> RequestError in
                error is RequestError ? error as! RequestError : RequestError.unableToMakeRequest
            }
        .eraseToAnyPublisher()
        
        return sessionPublisher
    }
}
