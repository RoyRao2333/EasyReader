//
//  StoryBoardExtension.swift
//  EasyWeather
//
//  Created by Roy on 2021/11/16.
//

import UIKit

enum StoryboardName: String {
    case main = "Main"
}

extension UIViewController {
    
    static func instantiate(withStoryboard sbName: StoryboardName) -> Self {
        UIStoryboard(name: sbName.rawValue, bundle: nil).instantiateViewController(withIdentifier: "\(Self.self)") as! Self
    }
}
