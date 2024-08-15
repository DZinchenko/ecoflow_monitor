//
//  DeviceListItemViewModel.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_Domain

class DeviceListItemViewModel: ObservableObject {
    typealias Parameter = EcoflowDataResponse.Parameter
    
    @Published var observer: EcoflowDeviceObserver
    
    internal init(observer: EcoflowDeviceObserver) {
        self.observer = observer
    }
    
    var inputWattsSum: Int? {
        var sum: Int? = nil
        if case Parameter.int(let bmsInpValue)? = observer.getParameterValue(.bmsInputWatts) {
            sum = (sum ?? 0) + bmsInpValue
        }
        if case Parameter.int(let pdInpValue)? = observer.getParameterValue(.pdInputWatts) {
            sum = (sum ?? 0) + pdInpValue
        }
        return sum
    }
    
    var outputWattsSum: Int? {
        var sum: Int? = nil
        if case Parameter.int(let bmsOutpValue)? = observer.getParameterValue(.bmsOutputWatts) {
            sum = (sum ?? 0) + bmsOutpValue
        }
        if case Parameter.int(let pdOutpValue)? = observer.getParameterValue(.pdOutputWatts) {
            sum = (sum ?? 0) + pdOutpValue
        }
        return sum
    }
    
    var stateOfCharge: Double? {
        if case Parameter.double(let socValue)? = observer.getParameterValue(.stateOfCharge){
            return socValue
        }
        return nil
    }
    
    
}
