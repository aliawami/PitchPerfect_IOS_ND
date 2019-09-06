//
//  Themes.swift
//  PitchPerfect
//
//  Created by Ali Alawami on 02/09/2019.
//  Copyright © 2019 Ali Alawami. All rights reserved.
//

import UIKit

enum Theme{
    case original, dark
    
    var themeName:String{
        switch self {
        case .original:
            return "Original"
        case .dark:
            return "Dark"
  
        }
    }
    
    var themeTextColor:UIColor{
        switch self {
        case .original:
            return .black
        case .dark:
            return .white
        }
    }
    
    
    var startRecording:String{
        switch self {
        case .original:
            return "recorder"
        case .dark:
            return  "Record"
        }
    }
    
    var stopRecording:String{
        switch self {
        case .original:
            return "stoper"
        case .dark:
            return  "Stop"
        }
    }
    

    
    
    
    
    
}
