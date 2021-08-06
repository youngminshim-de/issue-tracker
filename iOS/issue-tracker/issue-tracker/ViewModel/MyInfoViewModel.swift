import Foundation
import Combine

class MyInfoViewModel {
    
    @Published private var myPostingsCount: String?
    @Published private var logInResource: String?
    
    init() {
        self.myPostingsCount = nil
        self.logInResource = nil
    }

    func didUpdatePostingsCount() -> AnyPublisher<String?, Never> {
        return $myPostingsCount
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateLogInResource() -> AnyPublisher<String?, Never> {
        return $logInResource
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func configurePostingsCount(_ count: Int) {
        let countString = String(count)
        self.myPostingsCount = countString + "개"
    }
    
    func configureLogInResource(_ resource: String) {
        self.logInResource = resource + " Log In"
    }
    
}
