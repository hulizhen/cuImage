//
//  Host.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

protocol Host: class {
    func uploadImage(_ image: NSImage, named name: String, in type: NSBitmapImageFileType);
}

protocol HostDelegate: class {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float);
    func host(_ host: Host, didUploadImageWithURLString urlString: String);
}

enum SupportedHost: String {
    case qiniu = "Qiniu"
    
    // It seems there is currently no elegant way to enumerate all the cases.
    // So, type each cases twice!
    static var allCases: [SupportedHost] {
        return [.qiniu]
    }

    var image: NSImage {
        switch self {
        case .qiniu: return #imageLiteral(resourceName: "QiniuHost")
        }
    }
    
    var viewController: NSViewController {
        switch self {
        case .qiniu: return QiniuHostPreferencesViewController(nibName: "QiniuHostPreferencesViewController", bundle: nil)!
        }
    }
}
