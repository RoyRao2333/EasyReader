//
//  StoryBoardExtension.swift
//  EasyWeather
//
//  Created by Roy on 2021/11/16.
//

import UIKit

extension UIViewController {
    
    static func instantiate(withStoryboard sbName: String) -> Self {
        UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: "\(Self.self)") as! Self
    }
}
