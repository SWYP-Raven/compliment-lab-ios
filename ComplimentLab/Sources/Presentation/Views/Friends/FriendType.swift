//
//  FriendType.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/15/25.
//

import Foundation
import SwiftUI

enum FriendType: String, CaseIterable, Codable {
    case kind = "5"
    case energetic = "4"
    case studious = "3"
    case special = "2"
    case quiet = "1"

    var title: String {
        switch self {
        case .kind:
            return "🌱 차근차근 칭구"
        case .energetic:
            return "📷 활발한 칭구"
        case .studious:
            return "📚 똑똑한 칭구"
        case .special:
            return "☀️ 특별한 칭구"
        case .quiet:
            return "🏁 든든한 칭구"
        }
    }
    
    var description: String {
        switch self {
        case .kind:
            return "\"오늘도 한 발자국 나아갔네.\""
        case .energetic:
            return "\"방금 그거 너무 멋있었어!\""
        case .studious:
            return "\"그럴 땐 이런 방법도 있어~\""
        case .special:
            return "\"너는 참 너답게 빛나.\""
        case .quiet:
            return "\"드디어 해냈구나\""
        }
    }
    
    var introductionText: String {
        switch self {
        case .kind:
            return "처음 만났는데도 왠지 편안하다.\n우리 차근차근 가까워지면 좋겠어:)"
        case .energetic:
            return "널 만나니까 벌써 신난다~\n지금부터 재미있게 얘기해보자!"
        case .special:
            return "작은 변화도 놓치지 않는 편이야.\n네 안에서 빛나는 부분을 꼭 짚어주고 싶어."
        case .quiet:
            return "첫인상부터 네 매력이 확 느껴지는데?\n우리 대화하면 금방 더 재미있어질 거야!"
        case .studious:
            return "오늘은 널 만나서 더 특별한 하루야!\n앞으로 같이 멋진 순간을 많이 만들자."
        }
    }
    
    var color1: Color {
        switch self {
        case .kind:
            return Color.pink1
        case .energetic:
            return Color.yellow1
        case .studious:
            return Color.violet1
        case .special:
            return Color.green1
        case .quiet:
            return Color.blue1
        }
    }
    
    var color2: Color {
        switch self {
        case .kind:
            return Color.pink2
        case .energetic:
            return Color.yellow2
        case .studious:
            return Color.violet2
        case .special:
            return Color.green2
        case .quiet:
            return Color.blue2
        }
    }
    
    var color3: Color {
        switch self {
        case .kind:
            return Color.pink3
        case .energetic:
            return Color.yellow3
        case .studious:
            return Color.violet3
        case .special:
            return Color.green3
        case .quiet:
            return Color.blue3
        }
    }
    
    var color4: Color {
        switch self {
        case .kind:
            return Color.pink4
        case .energetic:
            return Color.yellow4
        case .studious:
            return Color.violet4
        case .special:
            return Color.green4
        case .quiet:
            return Color.blue4
        }
    }
    
    var stickerSImage: Image {
        switch self {
        case .kind:
            return Image("Character Pink Stiker S")
        case .energetic:
            return Image("Character Yellow Stiker S")
        case .studious:
            return Image("Character Violet Stiker S")
        case .special:
            return Image("Character Green Stiker S")
        case .quiet:
            return Image("Character Blue Stiker S")
        }
    }
    
    var stickerLImage: Image {
        switch self {
        case .kind:
            return Image("Character Pink Stiker L")
        case .energetic:
            return Image("Character Yellow Stiker L")
        case .studious:
            return Image("Character Violet Stiker L")
        case .special:
            return Image("Character Green Stiker L")
        case .quiet:
            return Image("Character Blue Stiker L")
        }
    }
    
    var stickerXLImage: Image {
        switch self {
        case .kind:
            return Image("Character Pink Stiker Set XL")
        case .energetic:
            return Image("Character Yellow Stiker Set XL")
        case .studious:
            return Image("Character Violet Stiker Set XL")
        case .special:
            return Image("Character Green Stiker Set XL")
        case .quiet:
            return Image("Character Blue Stiker Set XL")
        }
    }
    
    var emoji: Image {
        switch self {
        case .kind:
            return Image("kind")
        case .energetic:
            return Image("energetic")
        case .studious:
            return Image("studious")
        case .special:
            return Image("special")
        case .quiet:
            return Image("quiet")
        }
    }
    
    var card: Image {
        switch self {
        case .kind:
            return Image("Card make Pink card")
        case .energetic:
            return Image("Card make Yellow card")
        case .studious:
            return Image("Card make Violet card")
        case .special:
            return Image("Card make Green card")
        case .quiet:
            return Image("Card make Blue card")
        }
    }
    
    var cardMake: Image {
        switch self {
        case .kind:
            return Image("Card make Pink")
        case .energetic:
            return Image("Card make Yellow")
        case .studious:
            return Image("Card make Violet")
        case .special:
            return Image("Card make Green")
        case .quiet:
            return Image("Card make Blue")
        }
    }
    
    var chatIntroduceImage: Image {
        switch self {
        case .kind:
            return Image("Chat introduce Pink")
        case .energetic:
            return Image("Chat introduce Yellow")
        case .studious:
            return Image("Chat introduce Violet")
        case .special:
            return Image("Chat introduce Green")
        case .quiet:
            return Image("Chat introduce Blue")
        }
    }
    
    var chatBackground: Image {
        switch self {
        case .kind:
            return Image("Chat background pink")
        case .energetic:
            return Image("Chat background yellow")
        case .studious:
            return Image("Chat background violet")
        case .special:
            return Image("Chat background green")
        case .quiet:
            return Image("Chat background blue")
        }
    }
    
    var flowerImage: Image {
        switch self {
        case .kind:
            return Image("flower pink")
        case .energetic:
            return Image("flower yellow")
        case .studious:
            return Image("flower violet")
        case .special:
            return Image("flower Green")
        case .quiet:
            return Image("flower blue")
        }
    }
}
