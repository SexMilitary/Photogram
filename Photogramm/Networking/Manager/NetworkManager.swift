//
//  NetworkManager.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

struct NetworkManager<T: EndPointType, J: Decodable> {
    
    let router = Router<T>()
    
    func getRequest(endPoint: T, completion: @escaping (_ responce: (Result<J, Error>)) -> Void){
        
        router.request(endPoint) { data, response, error in
            
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    
                    if error != nil {
                        completion(.failure(NSError(domain: "Photogram.com",
                                                    code: response.statusCode,
                                                    userInfo: [NSLocalizedDescriptionKey : NetworkResponse.checkConnection.rawValue])))
                    }
                    
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NSError(domain: "Photogram.com",
                                                        code: response.statusCode,
                                                        userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue])))
                            return
                        }
                        
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print("JSONData:\n \(jsonData)")
                            let apiResponse = try JSONDecoder().decode(J.self, from: responseData)
                            completion(.success(apiResponse))
                        } catch let error {
                            print(error)
                            completion(.failure(NSError(domain: "Photogram.com",
                                                        code: response.statusCode,
                                                        userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue + "\n" + error.localizedDescription])))
                        }
                        
                    case .failure(let networkFailureError):
                        completion(.failure(networkFailureError))
                    }
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<HTTPURLResponse, Error> {
        switch response.statusCode {
        case 200...299:
            return .success(response)
        case 401...500:
            return .failure(NSError(domain: "Photogram.com",
                                    code: response.statusCode,
                                    userInfo: [NSLocalizedDescriptionKey : NetworkResponse.authenticationError.rawValue]))
        case 501...599:
            return .failure(NSError(domain: "Photogram.com",
                                    code: response.statusCode,
                                    userInfo: [NSLocalizedDescriptionKey : NetworkResponse.badRequest.rawValue]))
        case 600:
            return .failure(NSError(domain: "Photogram.com",
                                    code: response.statusCode,
                                    userInfo: [NSLocalizedDescriptionKey : NetworkResponse.outdated.rawValue]))
        default:
            return .failure(NSError(domain: "Photogram.com",
                                    code: response.statusCode,
                                    userInfo: [NSLocalizedDescriptionKey : NetworkResponse.failed.rawValue]))
        }
    }
}
