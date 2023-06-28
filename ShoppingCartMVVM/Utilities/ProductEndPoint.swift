//
//  ProductEndPoint.swift
//  ShoppingCartMVVM
//
//  Created by Rakesh on 26/06/23.
//

import Foundation

enum ProductEndpointItems {
    case products
    case addProduct(product: AddProduct)
}

extension ProductEndpointItems : EndPointType {
    
    var path: String {
        switch self {
        case .products :
            return "products"
        case .addProduct:
            return "products/add"
        }
    }
    
    var baseURL: String {
        switch self {
        case .products :
            return "https://fakestoreapi.com/"
        case .addProduct:
            return "https://dummyjson.com/"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .products :
            return .get
        case .addProduct:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .products:
            return nil
        case .addProduct(product: let product):
            return product
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
    
}
