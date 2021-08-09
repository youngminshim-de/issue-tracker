import Foundation

struct UserInfoResponseDTO: Decodable {
    
    let data: UserInfoDTO?
    let error: String?
    
}

struct UserListResponseDTO: Decodable {
    
    let data: [UserInfoDTO]
    let error: String?
    
    func toDomain() -> UserList {
        return UserList(users: data.map { User(id: $0.id, email: $0.email ?? "", userName: $0.username, profileImage: $0.profileImage) })
    }
    
}

struct UserInfoDTO: Decodable {
    
    let id: Int
    let oauthResource: String
    let email: String?
    let profileImage: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case oauthResource = "oauth_resource"
        case email
        case profileImage = "profile_image"
        case username
    }
    
}
