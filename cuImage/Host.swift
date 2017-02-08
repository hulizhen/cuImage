//
//  Host.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

// MARK: - Host
protocol Host: class {
    func uploadImageData(_ data: Data, named name: String)
}

// MARK: - HostDelegate
protocol HostDelegate: class {
    func host(_ host: Host, isUploadingImageNamed name: String, percent: Float)
    func host(_ host: Host, didSucceedToUploadImageNamed name: String, urlString: String)
    func host(_ host: Host, didFailToUploadImageNamed name: String, error: NSError)
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
    var viewController: BaseViewController {
        switch self {
        case .qiniu: return QiniuHostInfoViewController()
        }
    }
}
