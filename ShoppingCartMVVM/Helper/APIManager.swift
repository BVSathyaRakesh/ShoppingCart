//
//  APIManager.swift
//  ShoppingCartMVVM
//
//  Created by Rakesh BVS. Kumar on 2023/6/23.
//

import Foundation

enum DataError : Error {
    
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

// typealias Handler = (Result<[Product], DataError>) -> Void
//typealias Handler<T> = (Result<T, DataError>) -> Void

 typealias ResultHandler<T> = (Result<T, DataError>) -> Void

 //Singleton DesignPattern
 //Final is used to avoid  the Inheritance with another class
final class APIManager {
    
    static let shared = APIManager()
    
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler(), responsehandler : ResponseHandler = ResponseHandler()) {
        // private is used to Avoid other classes to create another instance/object class
        
        self.networkHandler = networkHandler
        self.responseHandler = responsehandler
    }
    
    static var commonHeaders : [String :String] {
        return ["Content-Type":"application/json"]
    }
     
     func request<T:Codable>( modelType: T.Type, endpointType: EndPointType, completion: @escaping ResultHandler<T>){
         
         guard let url = endpointType.url else {
             completion(.failure(.invalidURL))
             return
         }
         var request = URLRequest(url: url)
         request.httpMethod = endpointType.method.rawValue
         
         if let parameters = endpointType.body {
             request.httpBody = try? JSONEncoder().encode(parameters)
         }
         
         request.allHTTPHeaderFields = endpointType.headers
         
         // Network Request - URL TO DATA
         networkHandler.requestDataToAPI(url: request) { result  in
             switch result {
             case .success(let data):
                 // Json parsing - Decoder - DATA TO MODEL
                 self.responseHandler.parseResponse(data: data, type: modelType) { response  in
                     switch response {
                     case .success(let mainResponse):
                         completion(.success(mainResponse))
                     case .failure(let error):
                         completion(.failure(error))
                     }
                 }
             case .failure(let error):
                 completion(.failure(error))
             }
         }
         
     }
     
//     func fetchProducts(completion: @escaping Handler ){
//         guard let url = URL(string: "\(Constant.API.url + Constant.API.product)") else {
//             completion(.failure(.invalidURL))
//             return
//         }
//
//         //Background Task
//         URLSession.shared.dataTask(with: url) { data, response, error in
//             guard let data, error == nil else {
//                 completion(.failure(.invalidData))
//                 return
//             }
//
//             guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
//                 completion(.failure(.invalidResponse))
//                 return
//             }
//
//             do {
//                 let productResponse = try JSONDecoder().decode([Product].self, from: data)
//                 completion(.success(productResponse))
//
//             }catch {
//                 completion(.failure(.network(error)))
//                 return
//             }
//         }.resume()
//     }
     
}


class NetworkHandler {
    
    func requestDataToAPI(url:URLRequest, completion: @escaping( Result<Data, DataError>) -> Void){
        //Background Task
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
        
    }
    
}

class ResponseHandler {
    func parseResponse<T:Decodable>(data: Data, type: T.Type, completionHandler: ResultHandler<T>){
        do {
            let productResponse = try JSONDecoder().decode(type, from: data)
            completionHandler(.success(productResponse))
            
        }catch {
            completionHandler(.failure(.network(error)))
        }
    }
}
