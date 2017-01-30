//
//  AboutWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

struct ThirdPartyLibrary {
    let name: String
    let link: String
    let description: String
}

final class AboutWindowController: BaseWindowController {
    static let shared = AboutWindowController()

    @IBOutlet weak var appIconImageView: NSImageView!
    @IBOutlet weak var applicationNameTextField: NSTextField!
    @IBOutlet weak var copyrightTextField: NSTextField!
    @IBOutlet weak var versionTextField: NSTextField!
    @IBOutlet weak var extraInfoTextField: NSTextView!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Sets the window’s location to the center of the screen.
        window?.center()
        
        let infoDictionary = Bundle.main.infoDictionary!
        let applicationName = infoDictionary[Constants.applicationName] as! String
        let iconFileName = infoDictionary[Constants.iconFileName] as! String
        let copyright = infoDictionary[Constants.humanReadableCopyright] as! String
        let shortVersion = infoDictionary[Constants.shortVersion] as! String
        let buildVersion = infoDictionary[Constants.buildVersion] as! String
        let version = localizedString(key: "Version") + " \(shortVersion) (\(buildVersion))"
        
        let attributes = [kCTFontAttributeName as String: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize())]
        let applicationDescription =
        NSAttributedString(string: "cuImage(See You, Image!)", attributes: attributes) +
        NSAttributedString(string: " by ") +
        NSAttributedString.hyperlink(from: "Hu Lizhen", with: URL(string: Constants.authorLink)!) +
        NSAttributedString(string: "\n") +
        NSAttributedString(string: Constants.applicationDescription) +
        NSAttributedString(string: "\n\n\n")
        
        var thirdPartyLibrariesInfo = NSAttributedString(string: localizedString(key: "Acknowledgment\n"), attributes: attributes) +
            NSAttributedString(string: localizedString(key: "Special thanks to these awesome third-party libraries:\n"))
        for lib in Constants.thirdPartyLibraries {
            thirdPartyLibrariesInfo += NSAttributedString(string: "\n")
            thirdPartyLibrariesInfo += NSAttributedString.hyperlink(from: lib.name, with: URL(string: lib.link)!)
            thirdPartyLibrariesInfo += NSAttributedString(string: "\n\(lib.description)\n")
        }
        let extraInfo = NSAttributedString(attributedString: applicationDescription + thirdPartyLibrariesInfo)
        
        applicationNameTextField.stringValue = applicationName
        appIconImageView.image = NSImage(named: iconFileName)
        copyrightTextField.stringValue = copyright
        versionTextField.stringValue = version
        extraInfoTextField.textStorage?.setAttributedString(extraInfo)
    }
}
