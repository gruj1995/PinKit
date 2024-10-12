//
//  File.swift
//  
//
//  Created by 李品毅 on 2023/7/20.
//

import Foundation
import Network

// https://www.appcoda.com.tw/network-framework/
// 網路連線狀態
@available(iOS 13.0, *)
public final class NetworkMonitor {
    // MARK: Lifecycle

    private init() {
        monitor = NWPathMonitor()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: Internal

    public static let shared = NetworkMonitor()

    /// 是否連線到網路介面
    @Published public var isConnected: Bool = false

    /// 目前的網路介面類型(無線網路、行動網路、乙太網路)
    public var interfaceType: NWInterface.InterfaceType? {
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type)
        }.first?.type
    }

    /// 所有可用的網路介面類型
    public var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        monitor.currentPath.availableInterfaces.map { $0.type }
    }

    /// 檢查路徑是否使用了被認為是昂貴的 NWInterface
    /// 行動網路被認為是昂貴的。來自 iOS 設備的 WiFi 熱點也被認為是昂貴的。其他介面在未來也可能被認為是昂貴的。
    public var isExpensive: Bool {
        monitor.currentPath.isExpensive
    }

    public func startMonitoring() {
        // 在任何網路狀態變化時通知訂閱者
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    // MARK: Private

    /// Network 框架透過 NWPathMonitor 類別來觀察網路變化
    private let monitor: NWPathMonitor

    /// 觀察網路狀態變化需要在背景執行緒中執行，不可以在主執行緒中執行
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
}
