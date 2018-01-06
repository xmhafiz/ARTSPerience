//
//  PlaceStore.swift
//  ARTSPerience
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import ObjectMapper

class PlaceStore {
    static func getAll() -> [Place] {
        if let filepath = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let json = try String(contentsOfFile: filepath)
                print(json)
                if let places = Mapper<Place>().mapArray(JSONString: json) {
                    return places
                }
            } catch {
                // contents could not be loaded
                print("json file not loaded")
            }
        }
        
        return [Place]()
    }
    
    static func readJson() {
        
        
    }
}
