//
//  UIImageExtension.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/31/22.
//

import UIKit

extension UIImage {
    static func expenseCategory(named systemName: String) -> UIImage? {
        return Categories.init(rawValue: systemName)?.image
    }

    static func categoryImage(from sourceImage: UIImage, targetSize: CGSize, backgroundColor: UIColor, padding: CGFloat) -> UIImage? {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        // rect for image
        var scaledImageRect = CGRect.zero
        let aspectWidth = targetSize.width / sourceImage.size.width
        let aspectHeight = targetSize.height / sourceImage.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        scaledImageRect.size.width = (sourceImage.size.width - insets.left - insets.right) * aspectRatio
        scaledImageRect.size.height = (sourceImage.size.height - insets.top - insets.bottom) * aspectRatio
        scaledImageRect.origin.x = (targetSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (targetSize.height - scaledImageRect.size.height) / 2.0

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)

        // rect for background color and rounded corners
        let rect = CGRect(origin: CGPoint.zero, size: targetSize)

        // rounding the corners
        UIBezierPath(roundedRect: rect, cornerRadius: 5).addClip()

        // setting bg color
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        backgroundColor.setFill()
        context.fill(rect)

        sourceImage.draw(in: scaledImageRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }

    enum Categories: String {
        case train = "3005_train"
        case bus = "3001_bus2"
        case question = "8001_question"
        case dancing = "2002_dancing"
        case tax = "9007_tax"
        case fish = "7903_fish"
        case safe = "9006_safe"
        case doctor = "6503_doctor"
        case carousel = "6003_carousel"
        case cars = "3002_cars"
        case retroTV = "5502_retro_tv"
        case wineBottle = "1004_wine_bottle"
        case coat = "5001_coat"
        case gasStation = "3501_gas_station"
        case bath = "5402_bath"
        case exterior = "5401_exterior"
        case electrical = "5503_electrical"
        case doughnut = "1005_doughnut"
        case bunchIngredients = "1001_bunch_ingredients"
        case diningRoom = "1002_diningroom"
        case barbersScissors = "5004_barbers_scissors"
        case paintRoller = "5404_paint_roller"
        case smoking = "6505_smoking"
        case literature = "7002_literature"
        case bicycle = "3003_bicycle"
        case work = "3502_work"
        case internetExplorer = "8003_internet_explorer"
        case moneyBag = "9002_money_bag"
        case phone2 = "4501_phone2"
        case wallet = "9004_wallet"
        case broom = "5403_broom"
        case mobile = "5506_mobile"
        case stroller = "6002_stroller"
        case laptop = "5505_laptop"
        case candy = "2006_candy"
        case theatreMask = "2010_theatre_mask"
        case campfire = "7502_campfire"
        case woman = "6004_woman"
        case bottleOfWater = "1003_bottle_of_water"
        case motorcycle = "3004_motorcycle"
        case handshake = "8503_handshake"
        case taxi = "3004_taxi"
        case airport = "4001_airport"
        case goldBars = "9005_gold_bars"
        case pill = "6502_pill"
        case rottedPlant = "5510_rotted_plant"
        case globe = "8002_globe"
        case portraitMode = "5003_portrait_mode"
        case gift = "7001_gift"
        case children = "6001_children"
        case cashReceiving = "9001_cash_receiving"
        case doctorSuitcase = "6501_doctor_suitcase"

        var image: UIImage? {
            return UIImage()
//            switch self {
//            case .train:
//                return UIImage(systemName: "tram")
//            case .bus:
//                return UIImage(systemName: "bus")
//            case .question:
//                return UIImage(systemName: "questionmark")
//            case .dancing:
//                return UIImage(systemName: "music.quarternote.3")
//            case .tax:
//                return UIImage(systemName: "building.columns")
//            case .fish:
//                return UIImage(systemName: "hare")
//            case .safe:
//                return UIImage(systemName: "lock.circle")
//            case .doctor:
//                return UIImage(systemName: "heart.text.square")
//            case .carousel:
//                return UIImage(systemName: "questionmark")
//            case .cars:
//                return UIImage(systemName: "car.2")
//            case .retroTV:
//                return UIImage(systemName: "tv")
//            case .wineBottle:
//                return UIImage(systemName: "crown")
//            case .coat:
//                return UIImage(systemName: "bag.circle")
//            case .gasStation:
//                return UIImage(systemName: "bolt.car")
//            case .bath:
//                return UIImage(systemName: "drop.triangle")
//            case .exterior:
//                return UIImage(systemName: "building")
//            case .electrical:
//                return UIImage(systemName: "bolt")
//            case .doughnut:
//                return UIImage(systemName: "0.circle.fill")
//            case .bunchIngredients:
//                return UIImage(systemName: "multiply")
//            case .diningRoom:
//                return UIImage(systemName: "person.3")
//            case .barbersScissors:
//                return UIImage(systemName: "scissors")
//            case .paintRoller:
//                return UIImage(systemName: "paintbrush")
//            case .smoking:
//                return UIImage(systemName: "lungs")
//            case .literature:
//                return UIImage(systemName: "book")
//            case .bicycle:
//                return UIImage(systemName: "bicycle")
//            case .work:
//                return UIImage(systemName: "dollarsign.circle")
//            case .internetExplorer:
//                return UIImage(systemName: "network")
//            case .moneyBag:
//                return UIImage(systemName: "bag")
//            case .phone2:
//                return UIImage(systemName: "phone")
//            case .wallet:
//                return UIImage(systemName: "wallet.pass")
//            case .broom:
//                return UIImage(systemName: "clear")
//            case .mobile:
//                return UIImage(systemName: "iphone")
//            case .stroller:
//                return UIImage(systemName: "cart")
//            case .laptop:
//                return UIImage(systemName: "laptopcomputer")
//            case .candy:
//                return UIImage(systemName: "giftcard")
//            case .theatreMask:
//                return UIImage(systemName: "person.crop.rectangle")
//            case .campfire:
//                return UIImage(systemName: "flame")
//            case .woman:
//                return UIImage(systemName: "mouth")
//            case .bottleOfWater:
//                return UIImage(systemName: "drop")
//            case .motorcycle:
//                return UIImage(systemName: "bicycle.circle")
//            case .handshake:
//                return UIImage(systemName: "hands.sparkles")
//            case .taxi:
//                return UIImage(systemName: "car.circle")
//            case .airport:
//                return UIImage(systemName: "airplane")
//            case .goldBars:
//                return UIImage(systemName: "bitcoinsign.circle")
//            case .pill:
//                return UIImage(systemName: "pills")
//            case .rottedPlant:
//                return UIImage(systemName: "leaf")
//            case .globe:
//                return UIImage(systemName: "globe")
//            case .portraitMode:
//                return UIImage(systemName: "rectangle.portrait")
//            case .gift:
//                return UIImage(systemName: "gift")
//            case .children:
//                return UIImage(systemName: "face.smiling")
//            case .cashReceiving:
//                return UIImage(systemName: "banknote")
//            case .doctorSuitcase:
//                return UIImage(systemName: "cross.case")
//            }
        }
    }
}
