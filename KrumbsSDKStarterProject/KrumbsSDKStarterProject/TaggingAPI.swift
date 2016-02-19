import Foundation

class TaggingAPI {

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

    func tag(completion: (() -> Void)!) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // set up API key as base64encoded string
        let apiKey : String = "acc_6a60ccd77b9be63:eeba195b827309b590b3e466d6753b7f"
        let apiKeyString = apiKey.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = apiKeyString!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let authString = "Basic \(base64EncodedCredential)"
        
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        
        let session = NSURLSession(configuration: config)


        // set up request object
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/asdf")!)
        request.HTTPMethod = "POST"
        // create boundry
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let str : String = "asdf"
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        // image
        //let imageData = UIImageJPEGRepresentation(myImageView.image, 1)
        //if(imageData==nil)  { return; }

        let task = session.uploadTaskWithRequest(request, fromData: data!)

        task.resume()
    }

    func test() {

    }
}

var taggingAPI = TaggingAPI()
taggingAPI.tag(taggingAPI.test)