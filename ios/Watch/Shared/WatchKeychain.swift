import Foundation
import Security

/// Storage the Watch app and its complications share. watchOS has no shared App Group here,
/// so the two read and write one keychain access group (`$(AppIdentifierPrefix)com.zakaria.noor.watch`,
/// set as `NoorKeychainGroup` in both Info.plists). Keychain groups under the team prefix need no
/// portal setup, unlike App Groups.
enum WatchKeychain {
    private static let service = "com.zakaria.noor.watch"

    private static var group: String? {
        Bundle.main.object(forInfoDictionaryKey: "NoorKeychainGroup") as? String
    }

    private static func query(_ key: String, group: String?) -> [String: Any] {
        var q: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: service,
                                kSecAttrAccount as String: key]
        if let group, !group.hasPrefix("$(") { q[kSecAttrAccessGroup as String] = group }
        return q
    }

    static func data(_ key: String) -> Data? {
        var q = query(key, group: group)
        q[kSecReturnData as String] = true
        q[kSecMatchLimit as String] = kSecMatchLimitOne
        var out: AnyObject?
        return SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess ? out as? Data : nil
    }

    static func set(_ data: Data, _ key: String) {
        let q = query(key, group: group)
        let attrs: [String: Any] = [kSecValueData as String: data,
                                    kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock]
        if SecItemUpdate(q as CFDictionary, attrs as CFDictionary) == errSecItemNotFound {
            SecItemAdd(q.merging(attrs) { $1 } as CFDictionary, nil)
        }
    }
}
