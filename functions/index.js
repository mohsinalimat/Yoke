const functions = require('firebase-functions')
const admin = require('firebase-admin')
const firebase = require('firebase')
var serviceAccount = require("./routes/serviceAccountKey.json")
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
const stripe = require('stripe')(functions.config().stripe.token)
//To view key: 
//firebase functions:config:get
var AUTHORIZE_URI = 'https://connect.stripe.com/express/oauth/authorize';
var TOKEN_URI = 'https://connect.stripe.com/oauth/token';

var express = require('express')
var app = express()
//postman-request
var request = require('postman-request')
const path = require('path')
const cookieParser = require('cookie-parser')()
var queryString = require('querystring')
const cors = require('cors')({ origin: true })
app.use(cors)

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'))

const db = admin.firestore()
let docRef = db.collection('stripeAccounts')

app.get('/', (req, res) => {
    // res.send('here')
    // res.render('index')
    res.redirect(AUTHORIZE_URI + "?" + queryString.stringify({
        response_type: "code",
        scope: "read_write",
        client_id: 'ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO',
        force_login: true
    }));
})

const validateFirebaseIdToken = async (req, res, next) => {
    functions.logger.log('Check if request is authorized with Firebase ID token');

    if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
        !(req.cookies && req.cookies.__session)) {
        functions.logger.error(
            'No Firebase ID token was passed as a Bearer token in the Authorization header.',
            'Make sure you authorize your request by providing the following HTTP header:',
            'Authorization: Bearer <Firebase ID Token>',
            'or by passing a "__session" cookie.'
        );
        res.status(403).send('Unauthorized');
        return;
    }

    let idToken;
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
        functions.logger.log('Found "Authorization" header');
        // Read the ID Token from the Authorization header.
        idToken = req.headers.authorization.split('Bearer ')[1];
    } else if (req.cookies) {
        functions.logger.log('Found "__session" cookie');
        // Read the ID Token from cookie.
        idToken = req.cookies.__session;
    } else {
        // No cookie
        res.status(403).send('Unauthorized');
        return;
    }

    try {
        const decodedIdToken = await admin.auth().verifyIdToken(idToken);
        functions.logger.log('ID Token correctly decoded', decodedIdToken);
        req.user = decodedIdToken;
        next();
        return;
    } catch (error) {
        functions.logger.error('Error while verifying Firebase ID token:', error);
        res.status(403).send('Unauthorized');
        return;
    }
};


app.use(cors)
app.use(cookieParser)
app.use(validateFirebaseIdToken)

exports.createConnectAccount = functions.https.onRequest((req, res) => {
    console.log("request.body: " + req.body); // <-- returns undefined
    console.log("request.query.code: " + req.query.code); // <-- returns undefined
    console.log("request.query.body: " + req.query.body); // <-- returns undefined
    console.log("request.query.state: " + req.query.state); // <-- returns undefined
    console.log("request uid: " + req.user.uid);
    var data = req.body
    var email = data.email
    var response = {}
    stripe.accounts.create(
        {
            type: 'custom',
            country: 'US',
            requested_capabilities: [
                'transfers',
            ],
            business_type: 'individual',
        },
        function (err, account) {
            if (err) {
                console.log("Couldn't create stripe account: " + err)
                return res.send(err)
            } console.log("ACCOUNT: " + account.id)
            response.body = { success: account.id }
            return res.send(response)
        }
    );

    // return stripeToken.oauth.token({
    //           grant_type: 'authorization_code',
    //           code: req.query.code,
    //     }).then(function(response) {
    //           // asynchronously called

    //         return res.send(response)

    //           // var connected_account_id = response.stripe_user_id;
    //         })
    //         .catch(error=> {
    //             res.send(error)
    //         })

    //     });
    // stripe.accounts.create(
    //     {
    //         type: 'custom',
    //         country: 'US',
    //         requested_capabilities: [
    //             'transfers',
    //         ],
    //         business_type: 'individual',
    //     },
    //     function (err, account) {
    //         if (err) {
    //             console.log("Couldn't create stripe account: " + err)
    //             return res.send(err)
    //         }
    //         console.log("ACCOUNT: " + account.id)
    //         response.body = { success: account.id }
    //         return res.send(response)
    //         // stripe.accountLinks.create({
    //         //     account: account.id,
    //         //     failure_url: 'https://example.com/failure',
    //         //     success_url: 'https://example.com/success',
    //         //     type: 'account_onboarding',
    //         //     collect: 'eventually_due',
    //         // }, function (err, accountLink) {
    //         //     if (err) {
    //         //         console.log(err)
    //         //         response.body = { failure: err }
    //         //         return res.send(response)
    //         //     } console.log(accountLink.url)
    //         //     response.body = { success: link.url}
    //         //     return res.send(response)
    //         // })
    //     }
    // )

})

// exports.createStripeAccountLink = functions.https.onRequest((req, res) => {
//     var data = req.body
//     var accountID = data.accountID
//     var response = {}
// stripe.accountLinks.create({
//     account: accountID,
//     failure_url: 'https://example.com/failure',
//     success_url: 'https://example.com/success',
//     type: 'custom_account_verification',
//     collect: 'eventually_due',
// }, function (err, accountLink) {
//     if (err) {
//         console.log(err)
//         response.body = { failure: err }
//         return res.send(response)
//     } console.log(accountLink.url)
//     response.body = { success: accountLink.url }
//     return res.send(response)
// })
// })

app.get('/authorize', async (req, res) => {
    res.redirect(AUTHORIZE_URI + "?" + queryString.stringify({
        response_type: "code",
        scope: "read_write",
        client_id: 'ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO',
        force_login: true
    }));
})


app.get('/redirect', async (req, res) => {
    //Users are redirected to this endpoint after their request to connect to Stripe is approved.

    var authCode = req.params.code;
    var scope = req.params.scope;
    var error = req.params.error;
    var errorDescription = req.params.error_description;
    var objectID = req.params.object_id


    if (error) {
        res.render('pages/fail');
    } else {

        // Make /oauth/token endpoint POST request
        request.post({
            url: TOKEN_URI,
            form: {
                grant_type: 'authorization_code',
                client_id: 'ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO',
                code: authCode,
                client_secret: 'sk_test_QoimFzURXIjRvNMtI356etvw00KjSz4gvd'
            }
        }, function (err, response, body) {

            if (err) {
                res.render('pages/fail');
                return;
            }

            // {
            //   "token_type": "bearer",
            //   "stripe_publishable_key": PUBLISHABLE_KEY,
            //   "scope": "read_write",
            //   "livemode": false,
            //   "stripe_user_id": USER_ID,
            //   "refresh_token": REFRESH_TOKEN,
            //   "access_token": ACCESS_TOKEN
            // }

            var stripeUserID = JSON.parse(body).stripe_user_id;

            var qs = queryString.stringify({
                stripe_user_id: stripeUserID
            });

            res.redirect('/success?' + qs);

        });
    }

});

app.get('/success', function (req, res) {
    var stripeUserID = req.query.stripe_user_id;

    stripe.accounts.createLoginLink(
        stripeUserID,
        (err, loginLink) => {
            if (err) {
                console.log(err)
            } else {
                docRef.doc('user').set({ stripeId: stripeUserID, stripeLoginLink: loginLink.url })
                res.redirect(loginLink.url)
            }
        }
    )
    // res.render('pages/success', {
    //     stripe_user_id: stripeUserID
});



// Post the authorization code to Stripe to complete the Express onboarding flow
// request.post(
//     'https://connect.stripe.com/oauth/token',
//     {
//         form: {
//             grant_type: 'authorization_code',
//             client_id: 'ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO',
//             client_secret: 'sk_test_QoimFzURXIjRvNMtI356etvw00KjSz4gvd',
//             code: req.query.code,
//             user: req.user.uid,
//         },
//         json: true,
//     },
//     (err, response, body) => {
//         if (err || body.error) {
//             console.log('The Stripe onboarding process has not succeeded.')
//         } else {
//             console.log(body.stripe_user_id)
//             var connected_account_id = body.stripe_user_id

// stripe.accounts.createLoginLink(
//     connected_account_id,
//     (err, loginLink) => {
//         if (err) {
//             console.log(err)
//         } else {
//             docRef.doc('user').set({ stripeId: connected_account_id, stripeLoginLink: loginLink.url })
//             res.redirect(loginLink.url)
//         }
//     }
// )
//         }

//     }
// )
// })



// exports.createStripeCustomer = functions.firestore.document('stripe_customers/{userId}').onCreate(async (snap, context) => {
//   const data = snap.data();
//   const email = data['email'];
//   const customer = await stripe.customers.create({ email: email });
//   return admin.firestore().collection('stripe_customers').doc(data['id']).update({ customer_id: customer.id });
// });

// exports.createEphemeralKey = functions.https.onCall(async (data, context) => {

//     const customerId = data.customer_id;
//     const stripeVersion = data.stripe_version;

//     return stripe.ephemeralKeys.create(
//         { customer: customerId },
//         { stripe_version: stripeVersion }
//     ).then((key) => {
//         return key
//     }).catch((err) => {
//         console.log(err)
//         throw new functions.https.HttpsError('internal', ' Unable to create ephemeral key: ' + err);
//     });
// });

// // This is the method used for credit cards and uses the new Payment Methods API.
// exports.createCharge = functions.https.onCall(async (data, context) => {

//     const customerId = data.customer_id;
//     const paymentMethodId = data.payment_method_id;
//     const totalAmount = data.total_amount;
//     const idempotency = data.idempotency;
//     const destination = data.destination;
//     const uid = context.auth.uid;

//     return stripe.paymentIntents.create({
//         payment_method: paymentMethodId,
//         customer: customerId,
//         amount: totalAmount,
//         currency: 'usd',
//         confirm: true,
//         payment_method_types: ['card'],
//         transfer_data: {
//           destination: destination,
//         },
//     }, {
//             idempotency_key: idempotency
//         }).then(intent => {
//             // const charge = db.collection('stripe_charges').doc(intent.id).set({ intent })
//             const charge = db.collection('stripe_customers').doc(uid).collection('charges').doc(intent.id).set({ intent })
//             console.log('uid user', context.auth.uid)
//             console.log('Charge Success: ', intent)
//             return charge
//         }).catch(err => {
//             console.log(err);
//             throw new functions.https.HttpsError('internal', ' Unable to create charge: ' + err);
//         });
// });

exports.app = functions.https.onRequest(app)
