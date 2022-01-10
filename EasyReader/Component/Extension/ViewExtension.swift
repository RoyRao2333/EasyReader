//
//  ViewExtension.swift
//
//  Created by Roy Rao on 2021/4/12.
//

import UIKit
import SwiftUI
import Combine

// MARK: View
extension View {
    
    /**
     * Display your `View` conditionally.
     *
     * - Parameters:
     *      - conditional: The condition you wanna check.
     *      - ifTure: What you wanna do if checked true.
     *      - ifFalse: What you wanna do if checked false.
     */
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, if ifTure: ((Self) -> Content)?, else ifFalse: ((Self) -> Content)?) -> some View {
        if conditional {
            if ifTure != nil {
                ifTure!(self)
            } else {
                self
            }
        } else {
            if ifFalse != nil {
                ifFalse!(self)
            } else {
                self
            }
        }
    }
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            } else {
                EmptyView()
            }
        } else {
            self
        }
    }
    
    /// A backwards compatible wrapper for iOS 14 `onChange`.
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
    
    /// Set if enable the scroll function in `List`s.
    func scrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
    
    /// Hide keyboard when tap outside the TextField
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    func openSystemPreferences() {
        if
            let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
        {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    var screenRect: CGRect {
        UIScreen.main.bounds
    }
}


// MARK: UIView
extension UIView {
    
    /// 描边的粗细
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        
        set { layer.borderWidth = newValue }
    }
    
    /// 描边的颜色
    @IBInspectable var borderColor: UIColor? {
        get {
            if let layColor = layer.borderColor {
              return UIColor(cgColor: layColor)
            }
               
            return .clear
        }
        
        set { layer.borderColor = newValue?.cgColor }
    }
    
    /// 圆角
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            if let lScolor = layer.shadowColor {
                return UIColor(cgColor: lScolor)
            }
            
            return .clear
        }
        
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    /// Hide keyboard when tap outside the TextField
    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


// MARK: UITextView
extension UITextView {
    
    func increaseFontSize() {
        guard let currentFont = font else { return }
        
        font = UIFont(name: currentFont.fontName, size: currentFont.pointSize + 1)
    }
    
    func decreaseFontSize() {
        guard let currentFont = font else { return }
        
        font = UIFont(name: currentFont.fontName, size: currentFont.pointSize - 1)
    }
}
