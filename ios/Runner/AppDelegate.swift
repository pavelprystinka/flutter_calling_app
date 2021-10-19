import UIKit
import Flutter

import AzureCommunicationCalling
import CallingComposite

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let callingChannel = FlutterMethodChannel(name: "samples.microsoft.com/calling",
                                              binaryMessenger: controller.binaryMessenger)
   
      callingChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        guard call.method == "startCallingExperience" else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        if let args = call.arguments as? Dictionary<String, Any>,
           let authToken = args["authToken"] as? String,
           let userName = args["userName"] as? String,
           let callType = args["callType"] as? String,
           let groupCallId = args["groupCallId"] as? String,
           let meetingLink = args["meetingLink"] as? String {
          
            self?.startCallingExperience(authToken:authToken, userName:userName, callType:callType, groupCallId:groupCallId, meetingLink:meetingLink)
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
    })

    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func startCallingExperience(authToken: String, userName: String, callType: String, groupCallId: String, meetingLink: String) {
        let callCompositeOptions = CallCompositeOptions()
        let callComposite = CallComposite(withOptions: callCompositeOptions)
        let communicationTokenCredential = try! CommunicationTokenCredential(token:authToken)
        
        if (callType == "group_call") {
            let options = GroupCallOptions(
                communicationTokenCredential: communicationTokenCredential,
                displayName: userName,
                groupId: UUID(uuidString: groupCallId)!)
            
            callComposite.launch(with: options)
        }
        else {
            let options = TeamsMeetingOptions(
                communicationTokenCredential: communicationTokenCredential,
                displayName: userName,
                meetingLink: meetingLink)
            
            callComposite.launch(with: options)
        }
    }
}
