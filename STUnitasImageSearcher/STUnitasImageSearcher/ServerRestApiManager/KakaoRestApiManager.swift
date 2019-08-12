//
//  KakaoRestApiManager.swift
//  STUnitasImageSearcher
//
//  Created by 강진석 on 10/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//

import UIKit
import Alamofire

enum ImageSearchError {
    case NoDocument
    case NoNetworkConnection
    case RequestFail
}

class KakaoRestApiManager {
    static let sharedInstance = KakaoRestApiManager()
    
    func requestSearchImage(keyword: String, onResponse: @escaping (_ error: ImageSearchError?, _ documents: NSMutableArray?) -> Void) {
        
        if (NetworkReachabilityManager()!.isReachable == false) {
            onResponse(ImageSearchError.NoNetworkConnection, nil)
            return
        }
        
        let keywordWebLink = "https://dapi.kakao.com/v2/search/image?query=\(keyword)"
        
        let requestURL = keywordWebLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(requestURL,
                          method: .get,
                          encoding: JSONEncoding.prettyPrinted,
                          headers: ["Authorization": "KakaoAK 679ff5163a6922124c47571c457e72e3"])
            .responseJSON{ response in
                switch response.result
                {
                case .success(let json):
                    print(json)
                    
                    let documents = NSMutableArray()
                    // json parsing
                    if let result = response.result.value {
                        let resultDictionary = result as! NSDictionary
                        // let metaDictionary = resultDictionary.object(forKey: "meta") as! NSDictionary
                        let documentsArray = resultDictionary.object(forKey: "documents") as! NSArray
                        if (documentsArray.count == 0) {
                            onResponse(ImageSearchError.NoDocument, nil)
                            return
                        }
                        
                        for document in documentsArray {
                            let imageDocument = ImageDocument()
                            
                            let documentsDictionary = document as! NSDictionary
                            imageDocument.collection = documentsDictionary.object(forKey: "collection") as? String
                            imageDocument.thumbnailUrl = documentsDictionary.object(forKey: "thumbnail_url") as? String
                            imageDocument.imageUrl = documentsDictionary.object(forKey: "image_url") as? String
                            imageDocument.height = documentsDictionary.object(forKey: "height") as? Int;
                            imageDocument.width = documentsDictionary.object(forKey: "width") as? Int
                            imageDocument.siteName = documentsDictionary.object(forKey: "display_sitename") as? String
                            imageDocument.documentURL = documentsDictionary.object(forKey: "doc_url") as? String
                            imageDocument.dateTime = documentsDictionary.object(forKey: "datetime") as? String
                            documents.add(imageDocument)
                        }
                        
                    }
                    onResponse(nil, documents)
                    return
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    DispatchQueue.main.async {
                        print("검색 도중에 에러가 발생했습니다.")
                        
                    }
                    onResponse(ImageSearchError.RequestFail, nil)
                    return
                    
                }
                
        }
    }
    
}
