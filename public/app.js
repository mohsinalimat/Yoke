const functions = require('firebase-functions')
const admin = require('firebase-admin')
const firebase = require('firebase')
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://foodapp-4ebf0.firebaseio.com"
})

var config = {
    apiKey: "AIzaSyAzk4x5BukIC0N0yiDC9O4nfe1vn_7GUxM",
    authDomain: "foodapp-4ebf0.firebaseapp.com",
    databaseURL: "https://foodapp-4ebf0.firebaseio.com",
    projectId: "foodapp-4ebf0",
    storageBucket: "foodapp-4ebf0.appspot.com",
    messagingSenderId: "801948295113",
    appId: "1:801948295113:web:72b6aab34ff33381201218"
}
firebase.initializeApp(config)

//Firebase environment congiguration:
//firebase functions:config:set stripe.secret_test_key=""
const stripe = require('stripe')(functions.config().stripe.secret_test_key)
//To view key: 
//firebase functions:config:get

app.get('/authorize', async (req, res) => {
    var uid = req.body.user.uid
    console.log('uid: ' + uid)
    // const uid = req.user.uid;
    // console.log(req.user.uid);
    // const userRef = admin.firestore().collection('StripeAccounts').doc(uid);
})
exports.app = functions.https.onRequest(app)