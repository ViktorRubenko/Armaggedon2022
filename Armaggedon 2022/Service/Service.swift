//
//  APICaller.swift
//  
//
//  Created by Victor Rubenko on 13.04.2022.
//

import Foundation
import Combine
import Alamofire
import XMLCoder

protocol ServiceProtocol {
    func fetchAsteroids(startDate: String, endDate: String?) -> AnyPublisher<DataResponse<ResponseModel, NetworkError>, Never>
}


final class Service {
    static let shared: ServiceProtocol = Service()
    private init() {}
    
    private enum Constants {
        static let apiKey = "Z8DbOHJ0vghMeraqDDY1bd9J19o9EAHvNU7PM9vP"
        static let apiURL = "https://neowsapp.com/rest/v1"
    }
}

extension Service: ServiceProtocol {
    func createURL(params: String) -> URL? {
        URL(string: "\(Constants.apiURL)\(params)&api_key=\(Constants.apiKey)")
    }
    
    func fetchAsteroids(startDate: String, endDate: String?) -> AnyPublisher<DataResponse<ResponseModel, NetworkError>, Never> {
        let url = createURL(params: "/feed?start_date=\(startDate)&end_date=\(endDate ?? "")")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: ResponseModel.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? XMLDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
