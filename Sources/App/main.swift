import Vapor
import Sessions
import HTTP
import Foundation
import Cookies


let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)

let drop = Droplet()
drop.middleware.append(sessions)





// Sessions

drop.get("createSession") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    
    try request.session().data["name"] = Node.string(name)
    
    return "saved"
}

drop.get("sessions") { request in
    return try request.session().data["name"]?.string ?? "no session value found"
}






// Cookies

drop.get("createCookie") { request in
    guard let age = request.data["age"]?.string else {
        throw Abort.badRequest
    }
    
    let response = Response(status: .ok)
    let expiry = Date(timeIntervalSinceNow: 60)
    let cookie = Cookie(name: "age", value: age, expires: expiry)
    response.cookies.insert(cookie)
    return response
}

drop.get("cookie") { request in
    return request.cookies["age"]?.string ?? "no cookie found with name \'age\'"
}




drop.run()
