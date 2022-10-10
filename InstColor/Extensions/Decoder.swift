//
//  Extensions.swift
//  InstColor
//
//  Created by Lei Cao on 10/8/22.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to located \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}


extension URLSession {
    
    // 1
    enum SessionError: Error {
        case noData
        case statusCode
    }
    
    /// Wraps the standard dataTask method with a JSON decode attempt using the passed generic type.
    /// Throws an error if decoding fails
    /// - Parameters:
    ///   - url: The URL to be retrieved.
    ///   - completionHandler: The completion handler to be called once decoding is complete / fails
    /// - Returns: The new session data task
    // 2
    func jsonDataTask<T: Decodable>(with url: URL,
                                completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        // 3
        return self.dataTask(with: url) { (data, response, error) in
            // 4
            guard error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            // 5
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) == false {
                completionHandler(nil, response, SessionError.statusCode)
            }
            
            // 6
            guard let data = data else {
                completionHandler(nil, response, SessionError.noData)
                return
            }
            
            // 7
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completionHandler(decoded, response, nil)
            } catch(let error) {
                completionHandler(nil, response, error)
            }
        }
    }
}
