//
//  BreathData.swift
//  SleepSciTest
//
//  Created by Alexander Kudlak on 11/13/18.
//  Copyright © 2018 Alexandr Kudlak. All rights reserved.
//

import UIKit

struct BreathData: Decodable {
    var type = String()
    var duration = TimeInterval()
    var color = String()
    
    static func getJsonData() -> [BreathData]?{
        if let path = Bundle.main.path(forResource: "JsonDataFile", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let myStruct = try JSONDecoder().decode([BreathData].self, from: data)
                
                return myStruct
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
