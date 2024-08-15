//
//  EcoflowDeviceObserver.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation
import ecoflow_monitor_Data

public class EcoflowDeviceObserver: ObservableObject {
    @Published private var parameters: [String:ParameterValue] = [:]
    @Published public private(set) var firstLoadTimePassed = false
    @Published public private(set) var isOnline = false
    
    private let timerThresholdSec: Double = 60 //TODO: Add to config
    private var onlineTimer: Timer?
    
    struct ParameterValue {
        var date: Date
        var value : EcoflowDataResponse.Parameter
    }
    
    public init() {}
    
    public func getParameterValue(_ parameter: KnownParameters) -> EcoflowDataResponse.Parameter? {
        for key in parameter.keys {
            if let value = self.parameters[key] {
                return value.value
            }
        }
        
        return nil
    }
    
    func onSubscribe() {
        self.onlineTimer?.invalidate()
        self.onlineTimer = Timer.scheduledTimer(
            withTimeInterval: self.timerThresholdSec,
            repeats: false,
            block: { _ in
                self.firstLoadTimePassed = true
            })
    }
    
    func update(message: EcoflowDataResponse) {
        self.isOnline = true
        let now = Date.now
        for (paramName, paramVal) in message.params {
            self.parameters[paramName] = .init(date: now, value: paramVal)
        }
        
        self.firstLoadTimePassed = true
        self.startOnlineTimer()
    }
    
    private func startOnlineTimer() {
        self.onlineTimer?.invalidate()
        self.onlineTimer = Timer.scheduledTimer(
            withTimeInterval: self.timerThresholdSec,
            repeats: false,
            block: { _ in
                self.isOnline = false
            })
    }
}
