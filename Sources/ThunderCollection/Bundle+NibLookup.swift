import Foundation

extension Bundle {

    /// Resource bundles found by module name, cached because the lookup walks
    /// the bundle's directory.
    private static var moduleResourceBundles: [String: Bundle] = [:]

    /// Returns the bundle that should be used to locate a given nib for a cell
    /// class: the class's own bundle (the app, or a dynamic framework) if the
    /// nib is there, otherwise the SPM resource bundle of the module that
    /// declares the class.
    ///
    /// Under SPM `Bundle(for: cellClass)` resolves to the binary that links the
    /// package (the app's main bundle for static libraries), while the package's
    /// xibs live in a separate generated resource bundle.
    static func thunderCollectionNibBundle(for cellClass: AnyClass, nibName: String) -> Bundle {
        let classBundle = Bundle(for: cellClass)
        if classBundle.path(forResource: nibName, ofType: "nib") == nil,
           let moduleBundle = resourceBundle(forModuleOf: cellClass),
           moduleBundle.path(forResource: nibName, ofType: "nib") != nil {
            return moduleBundle
        }
        return classBundle
    }

    /// Returns the SPM resource bundle of the module that declares `aClass`.
    ///
    /// SPM names each target's resource bundle `<Package>_<Target>.bundle` and
    /// places it next to the binary that links the target, which is where the
    /// generated `Bundle.module` accessor looks too.
    static func resourceBundle(forModuleOf aClass: AnyClass) -> Bundle? {
        let className = NSStringFromClass(aClass)
        guard let dotIndex = className.firstIndex(of: ".") else { return nil }
        let moduleName = String(className[..<dotIndex])

        if let cached = moduleResourceBundles[moduleName] {
            return cached
        }

        let suffix = "_\(moduleName).bundle"
        let searchURLs = [Bundle.main.resourceURL, Bundle(for: aClass).resourceURL].compactMap { $0 }
        for url in searchURLs {
            let contents = (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? []
            if let name = contents.first(where: { $0.hasSuffix(suffix) }),
               let bundle = Bundle(url: url.appendingPathComponent(name)) {
                moduleResourceBundles[moduleName] = bundle
                return bundle
            }
        }
        return nil
    }
}
