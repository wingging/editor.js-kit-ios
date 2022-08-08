//
//  UITextView+Fixed.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 09/10/2019.
//

import UIKit

///
public class UITextViewFixed: UITextView {
    
    var row: Int?
    var section: Int?
    var boolFocus = false
    var italicFocus = false
    var underlineFocues = false
    /**
     */
    override public func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    /**
     */
    public func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
    public func setTextViewMark(indexPath: IndexPath?){
        row = indexPath?.row
        section = indexPath?.section
    }
    
    @objc func boldTapped() {
        if selectedRange.length == 0{
            boolFocus.toggle()
        }else{
            let changeRange = NSRange(location: self.selectedRange.location, length: self.selectedRange.length)
            // Handle bold
            let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
            if self.attributedText.containNonBold(range: self.selectedRange){
                attributedText.setBold(range: changeRange)
            }
            else{
                attributedText.removeBold(range: changeRange)
            }
            self.attributedText = attributedText
            self.selectedRange = changeRange
            delegate?.textViewDidChange?(self)
        }
    }
    
    @objc func italicTapped() {
        if self.selectedRange.length == 0{
            italicFocus.toggle()
        }else{
            let changeRange = NSRange(location: self.selectedRange.location, length: self.selectedRange.length)
            // Handle bold
            let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
            if self.attributedText.containNonItalic(range: self.selectedRange){
                attributedText.setItalic(range: changeRange)
            }
            else{
                attributedText.removeItalic(range: changeRange)
            }
            self.attributedText = attributedText
            self.selectedRange = changeRange
            delegate?.textViewDidChange?(self)
        }
    }
    
    @objc func underlineTapped() {
        if self.selectedRange.length == 0{
            italicFocus.toggle()
        }else{
            let changeRange = NSRange(location: self.selectedRange.location, length: self.selectedRange.length)
            let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
            if self.attributedText.containNonUnderline(range: self.selectedRange){
                attributedText.setUnderlined(range: changeRange)
            }
            else{
                attributedText.removeUnderline(range: changeRange)
            }
            self.attributedText = attributedText
            self.selectedRange = changeRange
            delegate?.textViewDidChange?(self)
        }
    }
    
    func convertTextHTML()-> String{
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
        return attributedText.addBoldTag().addItalicTag().addUnderlineTag().tagStringClean()
    }
    
    public func addAccessoryView() {
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(resignFirstResponder))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .blue
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolbar
    }
    
    public func addAccessoryAttributedView() {
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(resignFirstResponder))
        let italicButton = UIBarButtonItem(title: "italic", style: .plain, target: self, action: #selector(italicTapped))
        let boldButton = UIBarButtonItem(title: "bold", style: .plain, target: self, action: #selector(boldTapped))
        let underlineButton = UIBarButtonItem(title: "u_line", style: .plain, target: self, action: #selector(underlineTapped))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .blue
        toolbar.sizeToFit()
        toolbar.setItems([italicButton, boldButton, underlineButton, flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolbar
    }
}

extension NSMutableAttributedString{
    func tagStringClean() -> String{
        var cleanString = string
        cleanString = cleanString.replacingOccurrences(of: "</b><b>", with: "")
        cleanString = cleanString.replacingOccurrences(of: "</i><i>", with: "")
        cleanString = cleanString.replacingOccurrences(of: "</u><u>", with: "")
        debugPrint(cleanString)
        
        return cleanString
    }
    
    func addBoldTag() -> NSMutableAttributedString{
        let convertHTMLRange = ConvertRangeArray()

        beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length)) {
            (attributes, range, stop) in
            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            if font!.isBold{
                                convertHTMLRange.appendRange(startIndex: range.location, endIndex: range.location + (range.length - 1))
                                removeAttribute(NSAttributedString.Key.font, range:range)
                                addAttribute(NSAttributedString.Key.font, value:font!.detBoldFnc(), range:range)
                            }
                        }
                    default:
                        break
                }
            }
        }
        endEditing()
        
        convertHTMLRange.updateHTMLRange()
        
        for convertRange in convertHTMLRange.array{
            insert(NSAttributedString(string: "<b>"), at: convertRange.startIndex)
            insert(NSAttributedString(string: "</b>"), at: convertRange.endIndex)
        }
        
        return self
    }
    
    func addItalicTag() -> NSMutableAttributedString{
        let convertHTMLRange = ConvertRangeArray()

        beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length)) {
            (attributes, range, stop) in
            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            if font!.isItalic{
                                convertHTMLRange.appendRange(startIndex: range.location, endIndex: range.location + (range.length - 1))
                                removeAttribute(NSAttributedString.Key.font, range:range)
                                addAttribute(NSAttributedString.Key.font, value:font!.detItalicFnc(), range:range)
                            }
                        }
                    default:
                        break
                }
            }
        }
        endEditing()
        
        convertHTMLRange.updateHTMLRange()
        
        for convertRange in convertHTMLRange.array{
            insert(NSAttributedString(string: "<i>"), at: convertRange.startIndex)
            insert(NSAttributedString(string: "</i>"), at: convertRange.endIndex)
        }
        
        return self
    }
    
    func addUnderlineTag() -> NSMutableAttributedString{
        let convertHTMLRange = ConvertRangeArray()

        beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length)) {
            (attributes, range, stop) in
            attributes.forEach {
                (key, value) in
                switch key {
                    case NSAttributedString.Key.underlineStyle:
                        convertHTMLRange.appendRange(startIndex: range.location, endIndex: range.location + (range.length - 1))
                        removeAttribute(.underlineStyle, range:range)
                    default:
                        break
                }
            }
        }
        endEditing()
        
        convertHTMLRange.updateHTMLRange()
        
        for convertRange in convertHTMLRange.array{
            insert(NSAttributedString(string: "<u>"), at: convertRange.startIndex)
            insert(NSAttributedString(string: "</u>"), at: convertRange.endIndex)
        }
        
        return self
    }
    
    func removeBold(range: NSRange){
        beginEditing()
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in

            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            removeAttribute(NSAttributedString.Key.font, range:range)
                            addAttribute(NSAttributedString.Key.font, value:font!.detBoldFnc(), range:range)
                        }
                    default:
                        break
                }
            }
        }
        endEditing()
    }
    
    func removeItalic(range: NSRange){
        beginEditing()
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in

            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            removeAttribute(NSAttributedString.Key.font, range:range)
                            addAttribute(NSAttributedString.Key.font, value:font!.detItalicFnc(), range:range)
                        }
                    default:
                        break
                }
            }
        }
        endEditing()
    }
    
    func removeUnderline(range: NSRange){
        beginEditing()
        removeAttribute(NSAttributedString.Key.underlineStyle, range:range)
        endEditing()
    }
    
    func setBold(range: NSRange){
        beginEditing()
        
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in
            if attributes.keys.contains(NSAttributedString.Key.font){
                let font =  attributes[NSAttributedString.Key.font] as? UIFont
                if font != nil{
                    removeAttribute(NSAttributedString.Key.font, range:range)
                    addAttribute(NSAttributedString.Key.font, value:font!.setBoldFnc(), range:range)
                }
            }else{
                addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        
        endEditing()
        
    }
    
    func setItalic(range: NSRange){
        beginEditing()
        
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in
            if attributes.keys.contains(NSAttributedString.Key.font){
                let font =  attributes[NSAttributedString.Key.font] as? UIFont
                if font != nil{
                    removeAttribute(NSAttributedString.Key.font, range:range)
                    addAttribute(NSAttributedString.Key.font, value:font!.setItalicFnc(), range:range)
                }
            }else{
                addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        
        endEditing()
    }
    
    func setUnderlined(range: NSRange){
        beginEditing()
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in
            if attributes.keys.contains(NSAttributedString.Key.underlineStyle){
                let line =  attributes[NSAttributedString.Key.underlineStyle] as? NSUnderlineStyle
                if line != nil{
                    removeAttribute(NSAttributedString.Key.underlineStyle, range:range)
                    addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
                }
            }else{
                addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        endEditing()
    }
}

extension NSAttributedString{
    func containNonBold(range: NSRange)-> Bool{
        var returnValue = false
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in

            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            if !(font!.isBold){
                                returnValue = true
                            }
                        }
                    case NSAttributedString.Key.foregroundColor:
                        break
                    default:
                        break
                }
            }
        }
        return returnValue
    }
    
    func containNonItalic(range: NSRange)-> Bool{
        var returnValue = false
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in

            attributes.forEach { (key, value) in
                switch key {
                    case NSAttributedString.Key.font:
                        let font = value as? UIFont
                        if font != nil{
                            if !(font!.isItalic){
                                returnValue = true
                            }
                        }
                    case NSAttributedString.Key.foregroundColor:
                        break
                    default:
                        break
                }
            }
        }
        return returnValue
    }
    
    func containNonUnderline(range: NSRange)-> Bool{
        var returnValue = false
        enumerateAttributes(in: NSRange(location: range.location, length: range.length)) {
            (attributes, range, stop) in
            if !attributes.keys.contains(NSAttributedString.Key.underlineStyle){
                returnValue = true
            }
        }
        return returnValue
    }
}

extension NSUnderlineStyle{
    var isSingleLined: Bool{
        //return self.
        return false
    }
}

extension UIFont
{
    var isBold: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

    func setBoldFnc() -> UIFont
    {
        if(isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        }
    }

    func setItalicFnc()-> UIFont
    {
        if(isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        }
    }

    func setBoldItalicFnc()-> UIFont
    {
        return setBoldFnc().setItalicFnc()
    }

    func detBoldFnc() -> UIFont
    {
        if(!isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        }
    }

    func detItalicFnc()-> UIFont
    {
        if(!isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        }
    }
    /*
    func SetNormalFnc()-> UIFont
    {
        return detbBoldFnc().detbItalicFnc()
    }

    func toggleBoldFnc()-> UIFont
    {
        if(isBold)
        {
            return detbBoldFnc()
        }
        else
        {
            return setBoldFnc()
        }
    }

    func toggleItalicFnc()-> UIFont
    {
        if(isItalic)
        {
            return detbItalicFnc()
        }
        else
        {
            return setItalicFnc()
        }
    }
    */
}

class ConvertRangeArray{
    struct ConvertRange{
        var startIndex : Int
        var endIndex : Int
        
        init(start: Int, end: Int){
            startIndex = start
            endIndex = end
        }
    }
    
    var array : [ConvertRange] = []
    
    func appendRange(startIndex: Int, endIndex: Int){
        array.append(ConvertRange(start: startIndex, end: endIndex))
    }
    
    func updateHTMLRange(){
        if array.count == 0{
            return
        }
        
        for i in 0 ... array.count - 1{
            let newStartIndex = array[i].startIndex
            let newEndIndex = array[i].endIndex
            array[i].startIndex = newStartIndex + (i * 7)
            array[i].endIndex = newEndIndex + (i * 7) + 4
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, completionHandler:@escaping((UIImage)->Void)){
        guard let url = URL(string: link) else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completionHandler(image)
            }
        }.resume()
    }
    
}
