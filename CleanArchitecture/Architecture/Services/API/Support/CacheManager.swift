enum CacheManagerError: Error {
    case invalidFileName(urlString: String)
    case invalidFileData
}

class CacheManager {
    static var sharedInstance = CacheManager()
    
    let fileExtension = "cache"
    
    func fileURL(fileName: String) -> URL? {
        return try? FileManager.default
            .url(for: .cachesDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: false)
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
    }
    
    func encodedFileName(urlString: String) -> String? {
        return urlString
            .toBase64()
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func read(urlString: String) throws -> JSONDictionary {
        if let fileName = self.encodedFileName(urlString: urlString),
            let url = self.fileURL(fileName: fileName) {
            if let data = try? Data(contentsOf: url),
                let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] {
                return dictionary
            } else {
                throw CacheManagerError.invalidFileData
            }
        } else {
            throw CacheManagerError.invalidFileName(urlString: urlString)
        }
    }
    
    func write(urlString: String, data: JSONDictionary) throws {
        guard let fileName = self.encodedFileName(urlString: urlString),
            let fileURL = self.fileURL(fileName: fileName) else {
                throw CacheManagerError.invalidFileName(urlString: urlString)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: data)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func clear() {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let folderPath = paths.first else { return }
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: folderPath)
        while let element = enumerator?.nextObject() as? String {
            let url = URL(fileURLWithPath: folderPath).appendingPathComponent(element)
            if url.pathExtension == fileExtension {
                try? fileManager.removeItem(at: url)
            }
        }
    }
}
