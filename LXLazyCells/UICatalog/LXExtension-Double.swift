//
//  LXExtension-Double.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/16/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

public extension Double {
    public func getCleanDecimalString() ->String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

