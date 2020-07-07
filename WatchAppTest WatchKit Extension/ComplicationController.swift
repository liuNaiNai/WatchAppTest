//
//  ComplicationController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by 刘坤 on 2020/6/28.
//  Copyright © 2020 liukun. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    let startDate = Date()
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        if complication.family == .circularSmall
        {

            let template = CLKComplicationTemplateCircularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)

        } else if complication.family == .utilitarianSmall
        {

            let template = CLKComplicationTemplateUtilitarianSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Utilitarian")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)

        } else if complication.family == .modularSmall
        {

            let template = CLKComplicationTemplateModularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)

        } else {

            handler(nil)

        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        switch complication.family
        {
            case .circularSmall:
                let image: UIImage = UIImage(named: "Complication/Circular")!
                let template = CLKComplicationTemplateCircularSmallSimpleImage()
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                handler(template)
            case .utilitarianSmall:
                let image: UIImage = UIImage(named: "Complication/Utilitarian")!
                let template = CLKComplicationTemplateUtilitarianSmallSquare()
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                handler(template)
            case .modularSmall:
                let image: UIImage = UIImage(named: "Complication/Modular")!
                let template = CLKComplicationTemplateModularSmallSimpleImage()
                template.imageProvider = CLKImageProvider(onePieceImage: image)
                handler(template)
            default:
                handler(nil)
        }
    }

}
