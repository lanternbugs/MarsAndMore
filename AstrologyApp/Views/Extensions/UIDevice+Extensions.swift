//
//  UIDevice+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/3/22.
//

import SwiftUI
#if os(iOS)
extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
#elseif os(macOS)
        
#endif



