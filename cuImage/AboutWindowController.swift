//
//  AboutWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class AboutWindowController: BaseWindowController {
    static let shared = AboutWindowController()

    @IBOutlet weak var appIconImageView: NSImageView!
    @IBOutlet weak var applicationNameTextField: NSTextField!
    @IBOutlet weak var copyrightTextField: NSTextField!
    @IBOutlet weak var versionTextField: NSTextField!

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
        let version = "Version \(shortVersion) (\(buildVersion))"
        
        applicationNameTextField.stringValue = applicationName
        appIconImageView.image = NSImage(named: iconFileName)
        copyrightTextField.stringValue = copyright
        versionTextField.stringValue = version
    }
}
