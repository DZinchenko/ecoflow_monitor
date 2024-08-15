//
//  KnownParameters.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation

public enum KnownParameters {
    public var keys: Array<String> {
        switch self {
        case .bmsInputWatts:
            return ["bms_bmsStatus.inputWatts"]
        case .bmsOutputWatts:
            return ["bms_bmsStatus.outputWatts"]
        case .pdInputWatts:
            return ["pd.wattsInSum"]
        case .pdOutputWatts:
            return ["pd.wattsOutSum"]
        case .stateOfCharge:
            return ["bms_bmsStatus.f32ShowSoc"]
        }
    }
    
    case bmsInputWatts
    case bmsOutputWatts
    case pdInputWatts
    case pdOutputWatts
    case stateOfCharge
}
