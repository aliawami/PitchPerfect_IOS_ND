//
//  StringReferrence.swift
//  PitchPerfect
//
//  Created by Ali Alawami on 02/09/2019.
//  Copyright © 2019 Ali Alawami. All rights reserved.
//

import Foundation


enum Recording{
    case start, stop, new
    
    var infomation:String{
        switch self {
        case .start:
            return "tap to start recording"
        case .stop:
            return "tap to stop recording"
        case .new:
            return "New Recording"
   
        }
    }
}
