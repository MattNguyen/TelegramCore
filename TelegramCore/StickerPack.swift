import Foundation
#if os(macOS)
    import PostboxMac
#else
    import Postbox
#endif

public struct StickerPackCollectionInfoFlags : OptionSet {
    public var rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = 0
    }
    
    public init(_ flags: StickerPackCollectionInfoFlags) {
        var rawValue: Int32 = 0
        
        if flags.contains(StickerPackCollectionInfoFlags.masks) {
            rawValue |= StickerPackCollectionInfoFlags.masks.rawValue
        }
        
        if flags.contains(StickerPackCollectionInfoFlags.official) {
            rawValue |= StickerPackCollectionInfoFlags.official.rawValue
        }
        
        self.rawValue = rawValue
    }
    
    public static let masks = StickerPackCollectionInfoFlags(rawValue: 1)
    public static let official = StickerPackCollectionInfoFlags(rawValue: 2)
}


public final class StickerPackCollectionInfo: ItemCollectionInfo, Equatable {
    public let id: ItemCollectionId
    public let flags:StickerPackCollectionInfoFlags
    public let accessHash: Int64
    public let title: String
    public let shortName: String
    public let hash: Int32
    
    public init(id: ItemCollectionId, flags: StickerPackCollectionInfoFlags, accessHash: Int64, title: String, shortName: String, hash: Int32) {
        self.id = id
        self.flags = flags
        self.accessHash = accessHash
        self.title = title
        self.shortName = shortName
        self.hash = hash
    }
    
    public init(decoder: Decoder) {
        self.id = ItemCollectionId(namespace: decoder.decodeInt32ForKey("i.n"), id: decoder.decodeInt64ForKey("i.i"))
        self.accessHash = decoder.decodeInt64ForKey("a")
        self.title = decoder.decodeStringForKey("t")
        self.shortName = decoder.decodeStringForKey("s")
        self.hash = decoder.decodeInt32ForKey("h")
        self.flags = StickerPackCollectionInfoFlags(rawValue: decoder.decodeInt32ForKey("f"))
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeInt32(self.id.namespace, forKey: "i.n")
        encoder.encodeInt64(self.accessHash, forKey: "a")
        encoder.encodeInt64(self.id.id, forKey: "i.i")
        encoder.encodeString(self.title, forKey: "t")
        encoder.encodeString(self.shortName, forKey: "s")
        encoder.encodeInt32(self.hash, forKey: "h")
        encoder.encodeInt32(self.flags.rawValue, forKey: "f")
    }
    
    public static func ==(lhs: StickerPackCollectionInfo, rhs: StickerPackCollectionInfo) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.shortName == rhs.shortName && lhs.hash == rhs.hash
    }
}

public final class StickerPackItem: ItemCollectionItem, Equatable {
    public let index: ItemCollectionItemIndex
    public let file: TelegramMediaFile
    public var indexKeys: [MemoryBuffer]
    
    public init(index: ItemCollectionItemIndex, file: TelegramMediaFile, indexKeys: [MemoryBuffer]) {
        self.index = index
        self.file = file
        self.indexKeys = indexKeys
    }
    
    public init(decoder: Decoder) {
        self.index = ItemCollectionItemIndex(index: decoder.decodeInt32ForKey("i.n"), id: decoder.decodeInt64ForKey("i.i"))
        self.file = decoder.decodeObjectForKey("f") as! TelegramMediaFile
        self.indexKeys = decoder.decodeBytesArrayForKey("s")
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeInt32(self.index.index, forKey: "i.n")
        encoder.encodeInt64(self.index.id, forKey: "i.i")
        encoder.encodeObject(self.file, forKey: "f")
        encoder.encodeBytesArray(self.indexKeys, forKey: "s")
    }
    
    public static func ==(lhs: StickerPackItem, rhs: StickerPackItem) -> Bool {
        return lhs.index == rhs.index && lhs.file == rhs.file && lhs.indexKeys == rhs.indexKeys
    }
}