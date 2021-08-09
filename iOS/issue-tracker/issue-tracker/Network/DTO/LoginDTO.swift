import Foundation

struct LoginDTO: Encodable {
    
    let email: String
    let username: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case email, username
        case profileImage = "profile_image"
    }
    
}
