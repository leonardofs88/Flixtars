//
//  Service.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation
import Alamofire
import RxSwift

protocol ServiceProtocol: AnyObject {
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T>
    func requestImage(_ urlConvertible: URLRequestConvertible) -> Observable<Data>
}

class Service: ServiceProtocol {
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T,AFError>) in
                
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestImage(_ urlConvertible: URLRequestConvertible) -> Observable<Data> {
        return Observable<Data>.create { observer in
            
            let request = AF.request(urlConvertible).response(completionHandler: { response in
                if let imageData = response.data {
                    observer.onNext(imageData)
                } else {
                    observer.onError(AFError.explicitlyCancelled)
                }
                observer.onCompleted()
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
