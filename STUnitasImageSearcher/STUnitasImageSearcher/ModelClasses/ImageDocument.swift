//
//  ImageDocument.swift
//  STUnitasImageSearcher
//
//  Created by 강진석 on 10/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//

import UIKit

class ImageDocument {
    var collection: String! = nil // 컬렉션
    var siteName: String! = nil // 출처명
    var image: UIImage! = nil // 이미지
    var imageUrl: String! = nil // 이미지 URL
    var thumbnailUrl : String! = nil // 이미지 썸내일 URL
    var documentURL: String! = nil // 문서 URL
    var dateTime: String! = nil // 문서 작성 시간
    var width: Int! = nil // 이미지의 가로 크기
    var height: Int! = nil // 이미지의 세로 크기
}
