import Foundation
import UIKit

public let PLACE_API_KEY = "AIzaSyD5eBj9SeVQLGAqtG2Z4QW3sxAKIpI7ve4"

struct Messages {

}

struct Constants {
    static let PROGRESS_COLOR      = UIColor.black
    static let SAVE_ROOT_PATH      = "save_root"
    static let SCREEN_HEIGHT       = UIScreen.main.bounds.height
    static let SCREEN_WIDTH        = UIScreen.main.bounds.width
    static let TERMS_LINK    = "http://mofutomo.com/terms.pdf"
    static let PRIVACY_LINK    = "http://mofutomo.com/privacy.pdf"
    static let items = ["Document", "Medicine", "Makeup", "Money", "Food", "Mobile", "Laptop", "Electronics", "Books", "Toys", "Clothes", "Shoes"]
    static let ONE_MIN_TIMESTAMP      = 60 * 1000
    static let ONE_HOUR_TIMESTAMP      = 3600 * 1000
    static let ONE_DAY_TIMESTAMP      = 86400 * 1000
    static let ONE_WEEK_TIMESTAMP      = 604800 * 1000
    static let ONE_MONTH_TIMESTAMP      = 2629743 * 1000
    static let ONE_YEAR_TIMESTAMP      = 31556926 * 1000
    static let CLIENT_ID    = "491391337775-gjr5p6otsu0vqlmdgumt4c20qrgaefet.apps.googleusercontent.com"
}

struct COLORS {
    static let PRIMARY      = UIColor.init(named: "color_Primary")
    static let PRIMARYLIGHT = UIColor.init(named: "color_Primary_Light")
    static let PRIMARYDARK  = UIColor.init(named: "color_Primary")
    static let DECLINE  = UIColor.init(named: "color_decline")
    static let GENERAL_TEXT  = UIColor.init(named: "color_general_text")
}

struct TestData {
    static let user_images = ["https://i.pinimg.com/236x/0c/3d/bc/0c3dbc3fc00744e032fa8278e5e16741.jpg","https://i.pinimg.com/236x/4d/b0/10/4db0106cf43cea00b8c1c4c038d9f9b1.jpg","https://i.pinimg.com/236x/39/55/e9/3955e9f28508f563f1ae7e660f96b0a8.jpg","https://i.pinimg.com/236x/14/55/81/14558108de6f31aa19f5984bfbd3cbfc.jpg","https://i.pinimg.com/236x/3d/96/f1/3d96f14098bef76fdd23f22f353099cb.jpg","https://i.pinimg.com/236x/16/d1/91/16d191a2120592b0920f243e543ab5ed.jpg","https://i.pinimg.com/236x/48/ec/56/48ec56dd4aaa2508ef71ad3d8ff8a2ff.jpg","https://i.pinimg.com/236x/78/4b/30/784b30ff549ca6598e86ca55ffc5bd9f.jpg","https://i.pinimg.com/236x/61/be/9d/61be9d15e87fd945b7339ab598d655aa.jpg","https://i.pinimg.com/236x/55/64/b5/5564b54e232a080c4fd6c025c361d379.jpg"]
    static let post_times = [1609274408, 1602364408, 1609789408, 1609856408, 1605894408,  1609274487, 1609789508, 1608974408, 1609856408, 1609274896]
    
    
    static let dog_images = ["https://i.pinimg.com/236x/d1/aa/95/d1aa95325c4c8e13cee15a0efbb6d338.jpg","https://i.pinimg.com/236x/66/4a/7c/664a7c99bae0bea7dada04cb1c6df5d4.jpg","https://i.pinimg.com/236x/b3/fc/97/b3fc97a606565ce8c5472cac90e2e4f6.jpg","https://i.pinimg.com/236x/5d/60/0f/5d600f6dafceb07f95653c619b952e4d.jpg","https://i.pinimg.com/236x/ee/03/52/ee035279c7b8b8a5cff009e4eda4d968.jpg","https://i.pinimg.com/236x/29/8f/3b/298f3b7c8f3ae3b921d23505fbec4d48.jpg","https://i.pinimg.com/236x/5d/5c/f7/5d5cf747db25a1dca858a381b32aa0e4.jpg","https://i.pinimg.com/236x/6a/1b/b0/6a1bb018d6381b4c91ea52aa2221e93e.jpg","https://i.pinimg.com/236x/a6/be/e9/a6bee9b42e3685361e38351e67d5a62f.jpg","https://i.pinimg.com/236x/52/07/62/5207621ae23340f506c1c25e3c884601.jpg"]
    static let cat_images = ["https://i.pinimg.com/236x/29/b6/ba/29b6bab9904f319d8eba2466a0c0458f.jpg", "https://i.pinimg.com/236x/79/74/c4/7974c4296623393d16deaa616ef02ab8.jpg", "https://i.pinimg.com/236x/63/53/fa/6353fa275d96696062d89fd5987115d0.jpg", "https://i.pinimg.com/236x/e2/0f/08/e20f08bac7bbab3c636eefc26f90eabc.jpg", "https://i.pinimg.com/236x/1f/5d/86/1f5d867bdd4697d713311356ae042e1f.jpg", "https://i.pinimg.com/236x/26/22/5b/26225b92179d0039426d0d79732602a3.jpg", "https://i.pinimg.com/236x/6f/cb/e6/6fcbe6c6da54b44b3155fc092594a561.jpg", "https://i.pinimg.com/236x/43/a9/d6/43a9d6f820a074d6218eecba5f3f70a9.jpg", "https://i.pinimg.com/236x/b4/fb/7a/b4fb7a5dc9670fbbebbcdcb2b08a2d38.jpg", "https://i.pinimg.com/236x/f5/6f/41/f56f4116b472aa88b2fc1e300844e519.jpg"]
    static let userNames1 = ["Paul Newman","Hems Bett","Robert De Niro","Tom Ellis","Brad Pitt","Bloomberg kevin","Gerard Butler","Peter Kavinsky","Richard Madden","Johnny Depp"]
    
    static let userNames = ["Paul","Hems","Robert","Tom","Brad","Bloomberg","Gerard","Peter","Richard","Johnny"]
    
    static let userEmails = ["paul@gmail.com","hems@gmail.com","robert@gmail.com","tom@gmail.com","brad@gmail.com","bloomberg@gmail.com","gerad@gmail.com","peter@gmail.com","kavinsky@gmail.com","richard@gmail.com"]
    
    static let pet_names = ["Bingo","Dusty","Tetris","Vixen","Disco","Bailey","Feta","Gem","Hoagie","Spot"]
    
    static let pet_birthday = ["2017-10-19","2016-11-19","2018-04-19","2019-10-22","2015-12-19","2018-03-19","2020-11-19","2020-10-19","2020-03-19","2020-07-19"]
    static let postTime = ["2s","5s","10s","1min","2min","5min","8min","10min","12min","20min"]
    static let userLocation = ["London","Tokyo","Washington","Moscow","Paris","Beijing","Kanagawa","Amman","Tehran","Berlin"]
    static let postContent = ["猫の手も借りたい","目の中に入れても痛くない","耳にたこができる","喉から手が出る","まな板の上の鯉","ほっぺたが落ちる","雀の涙","烏の行水","犬猿の仲","箸より重いものを持ったことがない"]
    static let likeNum = [10, 13, 45, 67, 43, 23, 34, 34, 64, 67]
    static let price = [100, 130, 450, 670, 430, 230, 340, 340, 640, 670]
    static let weight = [100.56, 135.25, 45.59, 67.45, 430.56, 238.59, 347.59, 347.56, 640.89, 677.77]
    static let rating: [Float] = [5.0, 4.2, 3.7, 4.5, 2.6, 3.8, 1.0, 4.8, 2.7, 3.3]
    static let dog_kind = ["Labrador Retriever", "Australian Shepherd", "Pembroke Welsh Corgi", "Beagle", "Boxer", "Golden Retriever", "Yorkshire Terrier", "Pembroke Welsh Corgi", "French Bulldog", "Poodle"]
    static let cat_kind = ["Persian", "Bengal", "Burmese", "Sphynx", "American Curl", "American Bobtail", "American Shorthair", "Siamese", "Turkish Angora", "Manx"]
    static let items = ["Document", "Medicine", "Makeup", "Money", "Food", "Mobile", "Laptop", "Electronics", "Books", "Toys", "Clothes", "Shoes"]
    static let lats = [35.6897,34.6936 ,35.1167, 35.4333, 33.5903, 43.0621, 35.0111, 34.6913, 35.5300, 35.8617]
    static let langs = [139.6922, 135.5019, 136.9333, 139.6333, 130.4019, 141.3544, 135.7669, 135.1830, 139.7050, 139.6453]
    
    static let des = ["Absence makes the heart grow fonder","Actions speak louder than words.","A journey of a thousand miles begins with a single step","All good things must come to an end","A picture is worth a thousand words","    A watched pot never boils","Beggars can’t be choosers","Beauty is in the eye of the beholder","Better late than never","Birds of a feather flock together"]
    
}


