import Foundation

struct UserList {
    
    let users: [User]
    
}

struct User {

    let id: Int
    let email: String
    let userName: String
    let profileImage: String

}

class MyInfo {

    static let shared = MyInfo()
    var id: Int
    var oauthResource: String
    var email: String
    var userName: String
    var profileImage: String
    var postingsCount: Int
    
    private init() {
        self.id = 0
        self.oauthResource = ""
        self.email = ""
        self.userName = ""
        self.profileImage = ""
        self.postingsCount = 0
    }
    
    func setMyInfo(_ myInfo: UserInfoDTO) {
        self.id = myInfo.id
        self.oauthResource = myInfo.oauthResource
        self.email = myInfo.email ?? ""
        self.userName = myInfo.username
        self.profileImage = myInfo.profileImage
    }
    
    func setWroteIssueCount(_ count: Int) {
        self.postingsCount = count
    }
    
}
