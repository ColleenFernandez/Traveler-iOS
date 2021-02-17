//
//  Date+Extension.swift
//  bumerang
//
//  Created by RMS on 2019/9/26.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation

func getMessageTimeFromTimeStamp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm a" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}

func getWeekAndDateTimeFromTmp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "EEE, d/MMM/yyyy HH:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}


func getTimeFromTimeStamp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd/yyyy" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}

func gethourTimeFromTimeStamp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "h a" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}

func getHourandMinFromTimeStamp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "hh:mm a" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}

func getonlyDateFromTimeStamp(_ timeStamp: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd/yyyy" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
}


//update by RMS, 2019-08-13  add "formatStyle"
func getLocalTimeString(fromTime:String, formatStyle : String) -> String {
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    df.timeZone = TimeZone(abbreviation: "UTC")
    
    let fromDate = df.date(from: fromTime)
    
    df.timeZone = NSTimeZone.local
    //df.dateFormat = "yyyy.MM.dd"
    df.dateFormat = formatStyle
    
    let localTime = df.string(from: fromDate!)
    
    return localTime;
}

/*func getLocalTimeStringwithTimezone(fromTime:String, formatStyle : String, timezone: String) -> String {
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    df.timeZone = TimeZone(abbreviation: "UTC")
    
    let fromDate = df.date(from: fromTime)
    
    df.timeZone = TimeZone(identifier: timezone)
    //df.dateFormat = "yyyy.MM.dd"
    df.dateFormat = formatStyle
    
    let localTime = df.string(from: fromDate!)
    
    return localTime;
}*/

func getLocalTimeStringwithTimezone(_ timezone: String) -> String {
    let df = DateFormatter()
    df.dateFormat = "MMM/dd hh:mm a"
    df.timeZone = TimeZone(identifier: timezone)
    let localTime = df.string(from: Date())
    return localTime
}

func getCurrentDateStr() -> String {
    
    let date = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd hh:mm a" //Specify your format that you want
    
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}

func getCurrentDateStringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM/dd hh:mm a" //Specify your format that you want
    
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}

func getStringFormDate(date: Date, format: String = "yyyy/MM/dd") -> String {
    
    let df = DateFormatter()
    df.dateFormat = format
    return df.string(from: date)
}

func getDateSpecialFormatFromString(strDate: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
    let df = DateFormatter()
    //df.locale = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.dateFormat = format
    return df.date(from: strDate)
}

func getDateAndTime(_ tstamp: String) -> Date? {
    
    let date = Date(timeIntervalSince1970: TimeInterval(tstamp)!/1000)
    return date
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
  return (seconds / 86400 , (seconds % 86400) /  3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func getDateFromString(strDate: String, format: String = "MMM/dd/yyyy h a") -> Date? {
    
    let df = DateFormatter()
    df.locale = NSLocale.current
    df.dateFormat = format
    return df.date(from: strDate)
}

func getDateFromDateString(_ strDate: String) -> Date? {
    let format: String = "MMM/dd/yyyy"
    let df = DateFormatter()
    df.locale = NSLocale.current
    df.dateFormat = format
    return df.date(from: strDate)
}

func getTimeStampFromDateString(_ dateString: String) -> String{
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd'T'hh:mm:ssZ"
    let date = dfmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSta :Int = Int(dateStamp * 1000)
    return "\(dateSta)"
}

func getTimeStampValueFromDateString(_ dateString: String) -> Int{
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="MMM/dd/yyyy h a"
    let date = dfmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSta :Int = Int(dateStamp * 1000)
    return dateSta
}

func getTimeStampFromDateandMinString(_ dateString: String) -> String{
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="MMM/dd/yyyy hh:mm a"
    let date = dfmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSta :Int = Int(dateStamp * 1000)
    return "\(dateSta)"
}

func getTimeStampDateandMinString(_ dateString: String) -> String{
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd hh:mm a"
    let date = dfmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSta :Int = Int(dateStamp * 1000)
    return "\(dateSta)"
}

func getTimeStampValueFromDateandMinString(_ dateString: String) -> Int{
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="MMM/dd/yyyy hh:mm a"
    let date = dfmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSta :Int = Int(dateStamp * 1000)
    return dateSta
}





// RMS
func getDeffrenceDayVal(date1 : Date = Date(), date2 : Date = Date()) -> Int {
    
    //        var startDate : Date = date1 > date2 ? date2 : date1
    //        var endDate   : Date = date1 > date2 ? date1 : date2
    
    let calendar = Calendar.current
    return calendar.compare(date1, to: date2, toGranularity: .day).rawValue
    
    //        let components = calendar.dateComponents([.day], from: startDate, to: endDate, options: [])
    //        return components.day
    
}

extension Date {
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func specificDate(date: String = "2001/01/01", format: String = "yyyy/MM/dd") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: date)!
    }
    
    
    //get deffernce date between two date
    //ex : lastDate.interval(ofComponent: .day, fromDate: selectedStartDate)
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func compareTo(date: Date, toGranularity: Calendar.Component ) -> ComparisonResult  {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.compare(self, to: date, toGranularity: toGranularity)
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    
    func offset(from date: Date) -> String {
        var result: String = ""
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
    
    func from(year: Int, month: Int, day: Int, hour: Int = 0, munuts: Int = 0, sencond: Int = 0) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = munuts
        dateComponents.second = sencond
        
        
        return calendar.date(from: dateComponents) ?? nil
    }
    
}

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}

extension Date {

   var dayofTheWeek: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return daysOfTheWeek[dayNumber - 1]
        //return daysOfTheWeek[dayNumber]
   }

   private var daysOfTheWeek: [String] {
        return  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
   }
}

extension Date {
    func dayNumberOfWeek() -> Int? { //sun=1 ~ sat=7
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

@available(iOS 11.0, *)
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    @available(iOS 11.0, *)
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    @available(iOS 11.0, *)
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}

extension Date {

    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }

}

func getDateFromDateStringwithFormat(_ strDate: String, format: String) -> Date? {
    let format: String = format
    let df = DateFormatter()
    df.locale = NSLocale.current
    df.dateFormat = format
    return df.date(from: strDate)
}


func localToUTC(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.calendar = Calendar.current
    dateFormatter.timeZone = TimeZone.current
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
    
        return dateFormatter.string(from: date)
    }
    return nil
}

func utcToLocal(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
    
        return dateFormatter.string(from: date)
    }
    return nil
}



