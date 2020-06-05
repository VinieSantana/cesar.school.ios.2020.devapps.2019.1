//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 29/05/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import Foundation
import Alamofire

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

final class REST {
    
    // URL principal + endpoint
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration) // URLSession.shared
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        AF.request(url).response { response in
            do{
                
                if response.data == nil{
                    onError(.noData)
                    return
                }
                
                if let error = response.error{
                    
                    if error.isSessionTaskError{
                        onError(.taskError(error: error))
                        return
                    }
                    if error.isInvalidURLError {
                        onError(.url)
                        return
                    }
                    if error._code == NSURLErrorTimedOut {
                        onError(.noResponse)
                    }
                    
                    if error._code != 200 {
                        onError(.responseStatusCode(code: error._code))
                    }
                }
                
                let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                onComplete(cars)
            }catch is DecodingError {
                onError(.invalidJSON)
            }catch{
                onError(.taskError(error: error))
            }
        }
        
    }
    
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError )
    }
    
    
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void ) {
        // o endpoint do servidor para update é: URL/id
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        
        var httpMethod: String = ""
        
        switch operation {
        case .delete:
            httpMethod = "DELETE"
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        }
        
        // transformar objeto para um JSON, processo contrario do decoder -> Encoder
        guard let json = try? JSONEncoder().encode(car) else {
            onError(.invalidJSON)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        AF.request(request).response { response in
            if let error = response.error{
                if error.isSessionTaskError {
                    onError(.taskError(error: error))
                    return
                }
                if error.isInvalidURLError {
                    onError(.url)
                    return
                }
                if error._code == NSURLErrorTimedOut {
                    onError(.noResponse)
                    return
                }
                
                if error._code != 200 {
                    onError(.responseStatusCode(code: error._code))
                    return
                }
            }
            
            onComplete(true)
        }
        
    }
    
    // o metodo pode retornar um array de nil se tiver algum erro
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (CarError) -> Void) {
        
        // URL TABELA FIPE
        let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        guard let url = URL(string: urlFipe) else {
            onError(.url)
            return
        }
        AF.request(url).response {response in
            
            do{
                if response.data == nil{
                    onError(.noData)
                    return
                }
                
                if let error = response.error{
                    if error.isSessionTaskError {
                        onError(.taskError(error: error))
                        return
                    }
                    if error.isInvalidURLError {
                        onError(.url)
                        return
                    }
                    if error._code == NSURLErrorTimedOut {
                        onError(.noResponse)
                        return
                    }
                    
                    if error._code != 200 {
                        onError(.responseStatusCode(code: error._code))
                        return
                    }
                }
                
                let brands = try JSONDecoder().decode([Brand].self, from: response.data!)
                onComplete(brands)
                
            }catch{
                onError(.taskError(error: error))
            }
        }
        
    }
    
    class func friendfyError(carError: CarError) -> String {
        
        switch carError {
        case .invalidJSON:
            return "JSON inválido"
        case .noData:
            return "Nenhum dado foi retornado"
        case .noResponse:
            return "Tempo máximo da requisição excedido"
        case .url:
            return "Requisição inválida"
        case .taskError(let error):
            return "\(error.localizedDescription)"
        case .responseStatusCode(let code):
            if code != 200 {
                return "Problema com o servidor. :( \nError:\(code)"
            }
        }
        
        return ""
    }
} // fim da classe
