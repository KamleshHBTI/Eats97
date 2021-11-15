//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Kamlesh on 20/10/21.
//

import Foundation
import Combine

//MARK: Blue print of NetworkManagerProtocol
protocol NetworkManagerProtocol {
  typealias Headers = [String: Any]
  
  func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
  
  func post<T>(url: URL, headers: Headers, payload: T) -> AnyPublisher<T, FailureReason> where T: Codable
  
  func post<T, U>(url: URL, headers: Headers, payload: T, type: U.Type) -> AnyPublisher<U, FailureReason> where T: Codable, U: Codable

  func update<T>(url: URL, headers: Headers, payload: T) -> AnyPublisher<T, Error> where T: Codable
  
  func delete<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
  
}


//MARK: NetworkManager
final class NetworkManager: NetworkManagerProtocol {
  
  func post<T>(url: URL, headers: Headers,  payload: T) -> AnyPublisher<T, FailureReason> where T: Codable {
    var urlRequest = URLRequest(url: url)
    
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    let encoder = JSONEncoder()
    do {
      let jsonData = try encoder.encode(payload)
      urlRequest.httpBody = jsonData
      urlRequest.httpMethod = "POST"
    }catch {
      print("\(error.localizedDescription)")
    }
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .mapError { error -> FailureReason in
        return FailureReason.api(description: error.localizedDescription)
      }
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { .api(description: $0.localizedDescription) }
      .eraseToAnyPublisher()
  }
  
  func update<T, U>(url: URL, headers: Headers,  payload: T) -> AnyPublisher<U, Error> where T: Codable, U: Decodable {
    var urlRequest = URLRequest(url: url)
    
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    let encoder = JSONEncoder()
    do {
      let jsonData = try encoder.encode(payload)
      urlRequest.httpBody = jsonData
      urlRequest.httpMethod = "PUT"
    }catch {
      print("\(error.localizedDescription)")
    }
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: U.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
  func delete<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T : Decodable {
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "DELETE"
    
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
  
  func get<T: Decodable>(type: T.Type,  url: URL, headers: Headers ) -> AnyPublisher<T, Error> {
    
    var urlRequest = URLRequest(url: url)
    
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
  func post<T, U>(url: URL, headers: Headers, payload: T, type: U.Type) -> AnyPublisher<U, FailureReason> where T: Codable, U: Codable{
    var urlRequest = URLRequest(url: url)
    
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    let encoder = JSONEncoder()
    do {
      let jsonData = try encoder.encode(payload)
      urlRequest.httpBody = jsonData
      urlRequest.httpMethod = "POST"
    }catch {
      print("\(error.localizedDescription)")
    }
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .mapError { error -> FailureReason in
        return FailureReason.api(description: error.localizedDescription)
      }
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: U.self, decoder: JSONDecoder())
      .mapError { .api(description: $0.localizedDescription) }
      .eraseToAnyPublisher()
  }
  
}
