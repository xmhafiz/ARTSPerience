//
//  Place.swift
//  AwesomeAR
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import ObjectMapper

struct Place: Mappable {
    
    var name: String?
    var description: String?
    var imgURL: String?
    var coordinates: [Double]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        description <- map["properties.description"]
        name <- map["properties.Name"]
        imgURL <- map["properties.gx_media_links"]
        coordinates <- map["geometry.coordinates"]
    }
}

