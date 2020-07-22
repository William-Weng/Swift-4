// [傳送告白推播的 Push Notification](https://www.appcoda.com.tw/push-notification/)
// [用 Node.js 完成 Apple Push Notification Service - node-apn](http://iosdevelopersnote.blogspot.com/2012/08/nodejs-apple-push-notification-service.html)
// [iOS開發之推送警告but you still need to add "remote-notification" to the list of ....](https://www.jianshu.com/p/e3176299fa54)
// [Open app in specific view when user taps on push notification with iOS Swift](https://github.com/mariohercules/ios-notification)

var apn = require('apn');

var options = {
    token: {
      key: "<Your P8 File Name>.p8",
      keyId: "<Your P8 AuthKey ID>",
      teamId: "<Your Membership Details Team ID>"
    },
    production: false
  };

var apnProvider = new apn.Provider(options);
var note = new apn.Notification();

let deviceToken = "<Your iPhone DeviceToken>";

note.topic = "<Your App Bundle ID>";
note.alert = "No Money, No Talking";
note.sound = "default";
note.contentAvailable = 1;

note.badge = 87;
note.payload = {'customInfo':{'tab':2,'page':1,'item':3}};

apnProvider.send(note, deviceToken).then((result) => {
    console.log(note.payload);
});


