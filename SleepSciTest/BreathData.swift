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
    var breathType: BreathType = .inhale
    var duration = TimeInterval()
    var color = UIColor()
    
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
    
    enum CodingKeys: String, CodingKey {
        case type
        case duration
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let stringType = try container.decode(String.self, forKey: .type)
        type = stringType.uppercased()
        breathType = toBreathTipe(with: stringType)
        
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        
        let stringColor = try container.decode(String.self, forKey: .color)
        color = UIColor(hex: stringColor)
    }
    
    private func toBreathTipe(with type: String) -> BreathType {
        if type == "inhale" {
            return .inhale
        } else if type == "exhale" {
            return .exhale
        } else {
            return .hold
        }
    }
}
