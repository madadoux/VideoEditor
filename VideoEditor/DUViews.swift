//
//  DUViews.swift
//  GoonieOnlineMarket
//
//  Created by Mohamed saeed on 11/26/20.
//

import Foundation

import Foundation
import UIKit
extension UIViewController  {
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let w = window {
                statusBarHeight = w.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            }
            else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
                
            }
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }

    var width : CGFloat {
        return self.view.frame.width
    }
    
    var height : CGFloat {
        return self.view.frame.height - getStatusBarHeight()
    }

    func calcWidthFromRef(_ widthInDesign: CGFloat ) -> CGFloat{
        return (widthInDesign/375 ) * width
    }
    
    func calcHeightFromRef(_ heightInDesign: CGFloat ) -> CGFloat{
        return (heightInDesign/812 ) * height
    }
    
    func calcXFromRef(_ xInDesign : CGFloat) -> CGFloat {
        return (xInDesign/375 ) * width
    }
    
    func calcYFromRef(_ yInDesign : CGFloat) -> CGFloat {
        return (yInDesign/812 ) * height
    }
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension CGRect {
    init(view:UIView, _ x:CGFloat,_ y:CGFloat , _ w: CGFloat , _ h : CGFloat , designWidth:CGFloat = 375 , designHeight: CGFloat = 812 ) {
        func getStatusBarHeight() -> CGFloat {
            var statusBarHeight: CGFloat = 0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                if let w = window {
                    statusBarHeight = w.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                }
                else {
                    statusBarHeight = UIApplication.shared.statusBarFrame.height
                    
                }
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            return statusBarHeight
        }

        let width : CGFloat =
             view.frame.width
        let height : CGFloat = view.frame.height - getStatusBarHeight()
        let newX = (x/designWidth ) * width
        let newY = (y/designHeight ) * height
        let newW = (w/designWidth ) * width
        let newH = (h/designHeight ) * height

        self.init(x: newX, y: newY, width: newW, height: newH)
    }
}
public func getYPositionCenterForHeightAtCell(cell:UITableViewCell!, height:CGFloat) -> CGFloat
{
    
    return cell.textLabel!.center.y - height/2.0
    
}

public func clipValue<T:Comparable>(value : T ,min : T ,max : T) -> T  {
      
      if (value < min){
          return min
      }
      
      if (value > max) {
          return max
      }
      
      return value
}

public func delay(seconds:TimeInterval , block: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds)  {
        block()
    }
}
public func mainQueue( block: @escaping ()->Void) {
    DispatchQueue.main.async {
        block()
    }
}
@discardableResult
public func DUSeparator(origin : CGPoint , width:CGFloat , height: CGFloat, color : UIColor, parent: UIView? , cb:((UIView)->Void)? ) -> UIView
{
    let sep = UIView()
    sep.backgroundColor = color
    sep.frame = CGRect(origin: origin, size: CGSize(width: width, height: height))
    if parent != nil {
        parent!.addSubview(sep)
    }
    cb?(sep)
    return sep
}
@discardableResult
public func DUContainer(frame:CGRect, backgroundColor:UIColor!,parent: UIView? = nil ,matchParentSize : Bool = true , child:UIView!,inset:UIEdgeInsets = .zero , cb: ((UIView)->Void )? = nil ) -> UIView {
    
    let container:UIView! = UIView(frame:frame)
    
    container.backgroundColor = backgroundColor
    
    if child != nil {
        container.addSubview(child)
    }
    if parent != nil {
        parent!.addSubview(container)
    }
    cb?(container)
    if matchParentSize {
        container?.layoutIfNeeded()
        child.frame = container!.bounds.inset(by: inset)
    }

    return container
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension UIView {
   static var debugUI = true

    func addDeubg()  {
        if(UIView.debugUI ){
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.random().cgColor
        }
    }
}
public func DUColumn(frame:CGRect, children:[UIView]!, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment, spacing:CGFloat) -> UIStackView {
    //Stack View
    let stackView:UIStackView! = UIStackView()
    stackView.frame = frame
    stackView.axis = .vertical
    stackView.distribution = distribution
    stackView.alignment = alignment
    stackView.spacing = spacing
    stackView.addDeubg()
    //iterating over childs
    for child:UIView in children {
        stackView.addArrangedSubview(child)
       child.addDeubg()
        
     }
    //stackView.translatesAutoresizingMaskIntoConstraints = false;
    return stackView
}
public func DURow(frame:CGRect, children:[UIView]!, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment,parent:UIView?, spacing:CGFloat , cb:((UIStackView)->Void)? = nil ) -> UIStackView {
    //Stack View
    let stackView:UIStackView! = UIStackView()
    stackView.frame = frame
    stackView.axis = .horizontal
    stackView.distribution = distribution
    stackView.alignment = alignment
    stackView.spacing = spacing
    stackView.addDeubg()

    //iterating over childs
    for child:UIView in children {
        stackView.addArrangedSubview(child)
        child.addDeubg()

     }
    
    parent?.addSubview(stackView)
    cb?(stackView)
    //stackView.translatesAutoresizingMaskIntoConstraints = false;
    return stackView
}

@discardableResult
public func DUButton(frame:CGRect = .zero, title:String!, textColor:UIColor! = .blue ,parent : UIView? = nil , bg:UIColor = .clear, textFont:UIFont!, onTap: @escaping (UIButton)->Void, cb : ((UIButton)-> Void)? = nil ) -> UIButton
{
    let button:UIButton! = UIButton(frame:frame)
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = bg
    button.titleLabel?.font = textFont
    button.addAction({ onTap(button) })
    if let parent = parent {
        parent.addSubview(button)
    }
    cb?(button)

    return  button
}
@discardableResult
public func DULabel(text: String, frame: CGRect = .zero, parent:UIView? = nil , font:UIFont, textColor:UIColor = .black, numOfLines:Int = 0 ,textAlignment: NSTextAlignment = .center, cb: ((UILabel)->Void)? = nil  )-> UILabel! {
    let label = UILabel()
    label.frame = frame
    label.font = font
    label.textColor = textColor
    label.textAlignment = textAlignment
    label.numberOfLines = numOfLines
    label.text = text
    if let parent = parent {
        parent.addSubview(label)
    }
    cb?(label)
    return label
}
@discardableResult
public func DUImageView(image:UIImage? , frame:CGRect = .zero , parent : UIView? = nil ,contentMode : UIView.ContentMode = .scaleAspectFit , cb: ((UIImageView)->Void)? = nil)->UIImageView? {
    let imgView = UIImageView()
    imgView.frame = frame
    imgView.image = image
    imgView.contentMode = contentMode
    if let parent = parent {
        parent.addSubview(imgView)
    }
    cb?(imgView)
    return imgView
}


public func DUSegmentControl(frame:CGRect, parent: UIView? , items: [String], onSelect : @escaping (Int,[String])->Void , currentSelectedIndex: Int = 0 , selectedSegmentColor: UIColor = .blue ) -> UISegmentedControl {
    let segmentItems = items
    
    // configuring segment control
    let segmentControl = UISegmentedControl(items: segmentItems)
    segmentControl.selectedSegmentIndex = currentSelectedIndex
    segmentControl.addAction(for: .valueChanged) {
        onSelect(segmentControl.selectedSegmentIndex,items)
    }
    segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

//    if #available(iOS 13.0, *) {
//        segmentControl.selectedSegmentTintColor = selectedSegmentColor
//    } else {
//        // Fallback on earlier versions
        segmentControl.tintColor = selectedSegmentColor
    //}
    
    if let parent = parent {
        parent.addSubview(segmentControl)
    }
    segmentControl.frame = frame
    return segmentControl
}


public func DUSwitcher(frame: CGRect , parent : UIView? , onChange:@escaping (Bool)->Void, initValue: Bool = false ) -> UISwitch {
    let switchButton = UISwitch(frame: frame)
    switchButton.isOn = initValue

    switchButton.addAction(for: .valueChanged, {
        let isOn =  switchButton.isOn
        onChange(isOn)
        
    })
    if let parent = parent {
        parent.addSubview(switchButton)
    }
    
    return switchButton
}


public func DUSingleChildScrollView(frame:CGRect,child:UIView,parent:UIView?) -> UIScrollView{
    let scrollView = UIScrollView(frame: frame)
    scrollView.addSubview(child)
    child.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      child.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      child.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      child.topAnchor.constraint(equalTo: scrollView.topAnchor),
      child.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
    
    child.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    if let parent = parent {
        parent.addSubview(scrollView)
    }
    
    return scrollView
}

@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
