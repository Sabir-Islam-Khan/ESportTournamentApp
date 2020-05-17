const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var msgData;
exports.PostsTrigger = functions.firestore.document(
    'Posts/{PostId}'
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
     
   return admin.firestore().collection('Tokens').get().then((snapshots) => {
   
        var tokens = [];
        if (snapshots.empty){
           return console.log('No Devices');

        }
        else{
            for(var token of snapshots.docs){
                tokens.push(token.data().Tokens);
            }
            var payload = {
                "notification": {
                    "title": "From " + msgData.EventName,
                    "body": "Posts" + msgData.Details,
                    "sound": "defaut"
                },
                "data": {
                    "sendername": msgData.EventName,
                    "message": msgData.Details
                }
            }
            return admin.messaging().sendToDevice(tokens, payload).then ((response) => {
                 
         return   console.log('Pushed them all');
            }).catch((err) => {
                console.log(err);
            })
        }
    })

})
