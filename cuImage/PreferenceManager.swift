//
//  PreferenceManager.swift
//  cuImage
//
//  Created by Lizhen Hu on 06/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import MASShortcut
import RNCryptor

/// A convenient global handler to access preferences with subscripts.
let preferences = PreferenceManager.shared

// MARK: - PreferenceManager
final class PreferenceManager {
    static let shared = PreferenceManager()
    private let shortcutManager = ShortcutManager.shared
    let defaults = UserDefaults.standard
    
    private init() {
        registerDefaultPreferences()
    }
    
    private func registerDefaultPreferences() {
        // Convert dictionary of type [PreferenceKey: Any] to [String: Any].
        let defaultValues: [String: Any] = defaultPreferences.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        defaults.register(defaults: defaultValues)
    }
}

// MARK: - Subscripts
extension PreferenceManager {
    subscript(key: PreferenceKey<Any>) -> Any? {
        get { return defaults.object(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<URL>) -> URL? {
        get { return defaults.url(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[Any]>) -> [Any]? {
        get { return defaults.array(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String: Any]>) -> [String: Any]? {
        get { return defaults.dictionary(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<String>) -> String? {
        get { return defaults.string(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String]>) -> [String]? {
        get { return defaults.stringArray(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Data>) -> Data? {
        get { return defaults.data(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Bool>) -> Bool {
        get { return defaults.bool(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Int>) -> Int {
        get { return defaults.integer(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Float>) -> Float {
        get { return defaults.float(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Double>) -> Double {
        get { return defaults.double(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<MASShortcut>) -> MASShortcut? {
        // Read-only because the shortcuts is managed and set by MASShortcut.
        get {
            var object: MASShortcut?
            let data = defaults.data(forKey: key.rawValue)
            if let options = MASShortcutBinder.shared().bindingOptions,
                let transformer = options[NSValueTransformerBindingOption] as? ValueTransformer {
                object = transformer.transformedValue(data) as? MASShortcut
            }
            return object
        }
    }
    
    subscript(key: PreferenceKey<HostInfo>) -> HostInfo? {
        // Encrypt host info preferences.
        get {
            var object: HostInfo?
            if let encrypted = defaults.data(forKey: key.rawValue),
                let data = try? RNCryptor.decrypt(data: encrypted, withPassword: Constants.cryptoKey) {
                object = NSKeyedUnarchiver.unarchiveObject(with: data) as? HostInfo
            }
            return object
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            let encrypted = RNCryptor.encrypt(data: data, withPassword: Constants.cryptoKey)
            defaults.set(encrypted, forKey: key.rawValue)
        }
    }
}

// MARK: - PreferenceKeys
class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}

final class PreferenceKey<T>: PreferenceKeys { }

// MARK: - Preference Keys
extension PreferenceKeys {
    // General
    static let launchAtLogin = PreferenceKey<Bool>("LaunchAtLogin")
    static let keepWindowsOnTop = PreferenceKey<Bool>("KeepWindowsOnTop")
    static let maxActiveUploadTasks = PreferenceKey<Int>("MaxActiveUploadTasks")
    static let useMarkdownURL = PreferenceKey<Bool>("UseMarkdownURL")
    static let copyURLWhenUploaded = PreferenceKey<Bool>("CopyURLWhenUploaded")
    static let useJPEGCompression = PreferenceKey<Bool>("UseJPEGCompression")
    static let jpegCompressionQuality = PreferenceKey<Float>("JPEGCompressionQuality")
    
    // Shortcuts
    static let uploadImageShortcut = PreferenceKey<MASShortcut>("UploadImageShortcut")
    
    // Hosts
    static let currentHost = PreferenceKey<String>("CurrentHost")
    static let qiniuHostInfo = PreferenceKey<HostInfo>("QiniuHostInfo")
}

// MARK: - Default Preference Values
let defaultPreferences: [PreferenceKeys: Any] = [
    // General
    .launchAtLogin: false,
    .keepWindowsOnTop: true,
    .maxActiveUploadTasks: 5,
    .useMarkdownURL: true,
    .copyURLWhenUploaded: true,
    .useJPEGCompression: true,
    .jpegCompressionQuality: 1.0,
    
    // Shortcuts
    .uploadImageShortcut: MASShortcut(key: kVK_F9).data(),
    
    // Hosts
    .currentHost: SupportedHost.qiniu.rawValue,
    .qiniuHostInfo: NSKeyedArchiver.archivedData(withRootObject: QiniuHostInfo()),
]
