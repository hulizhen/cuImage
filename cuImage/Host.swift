//
//  Host.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

// MARK: - Host
protocol Host: class {
    func uploadImage(_ image: NSImage, named name: String)
}

// MARK: - HostDelegate
protocol HostDelegate: class {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float)
    func host(_ host: Host, didSucceedToUploadImage image: NSImage, urlString: String)
    func host(_ host: Host, didFailToUploadImage image: NSImage, error: NSError)
}

// MARK: - SupportedHost
enum SupportedHost: String {
    case qiniu = "Qiniu"
    
    // It seems there is currently no elegant way to enumerate all the cases.
    // So, type each cases twice!
    static var allCases: [SupportedHost] {
        return [.qiniu]
    }
    
    static var defaultHost: SupportedHost {
        return allCases.first!
    }

    /// An icon image followed by the host name.
    var image: NSImage {
        switch self {
        case .qiniu: return #imageLiteral(resourceName: "QiniuHost")
        }
    }
    
    /// The view controller for host preferences setting pane.
    var viewController: NSViewController {
        switch self {
        case .qiniu: return QiniuHostInfoViewController(nibName: "QiniuHostInfoViewController", bundle: nil)!
        }
    }
}
