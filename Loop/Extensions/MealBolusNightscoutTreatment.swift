//
//  NightscoutTreatment.swift
//  Loop
//
//  Created by Pete Schwamb on 10/7/16.
//  Copyright © 2016 LoopKit Authors. All rights reserved.
//

import Foundation
import NightscoutUploadKit
import CarbKit
import HealthKit
import MinimedKit

class TimeFormat: NSObject {
    private static var formatterISO8601 = DateFormatter.ISO8601DateFormatter()
    
    static func timestampStrFromDate(_ date: Date) -> String {
        return formatterISO8601.string(from: date)
    }
}

extension MealBolusNightscoutTreatment {
    public convenience init(carbEntry: CarbEntry) {
        let carbGrams = carbEntry.quantity.doubleValue(for: HKUnit.gram())
        self.init(timestamp: carbEntry.startDate, enteredBy: "loop://\(UIDevice.current.name)", id: carbEntry.externalId, carbs: lround(carbGrams), absorptionTime: carbEntry.absorptionTime)
    }
}


public class NightscoutTreatment: DictionaryRepresentable {
    
    public enum GlucoseType: String {
        case Meter
        case Sensor
    }
    
    public enum Units: String {
        case MMOLL = "mmol/L"
        case MGDL = "mg/dL"
    }
    
    let timestamp: Date
    let enteredBy: String
    let id: String?
    
    init(timestamp: Date, enteredBy: String, id: String? = nil) {
        self.timestamp = timestamp
        self.enteredBy = enteredBy
        self.id = id
    }
    
    public var dictionaryRepresentation: [String: Any] {
        var rval = [
            "created_at": TimeFormat.timestampStrFromDate(timestamp),
            "timestamp": TimeFormat.timestampStrFromDate(timestamp),
            "enteredBy": enteredBy,
            ]
        if let id = id {
            rval["_id"] = id
        }
        return rval
    }
}
