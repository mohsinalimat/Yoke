const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = require('firebase');
var serviceAccount = require("./routes/serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://foodapp-4ebf0.firebaseio.com"
});

var config = {
    apiKey: "AIzaSyAzk4x5BukIC0N0yiDC9O4nfe1vn_7GUxM",
    authDomain: "foodapp-4ebf0.firebaseapp.com",
    databaseURL: "https://foodapp-4ebf0.firebaseio.com",
    projectId: "foodapp-4ebf0",
    storageBucket: "foodapp-4ebf0.appspot.com",
    messagingSenderId: "801948295113",
    appId: "1:801948295113:web:72b6aab34ff33381201218"
  };
  firebase.initializeApp(config);

//Firebase environment congiguration:
//firebase functions:config:set stripe.secret_test_key=""
const stripe = require('stripe')(functions.config().stripe.secret_test_key);
//To view key: 
//firebase functions:config:get

var express = require('express');
var app = express();
var request = require('request');
const path = require('path');
const cookieParser = require('cookie-parser')();
const cors = require('cors')({origin: true});
app.use(cors);

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

const db = admin.firestore();
let docRef = db.collection('stripeAccounts');

app.get('/', (req, res) => {
  res.render('index');
});

const validateFirebaseIdToken = async (req, res, next) => {
  console.log('Check if request is authorized with Firebase ID token');

  if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
      !(req.cookies && req.cookies.__session)) {
    console.error('No Firebase ID token was passed as a Bearer token in the Authorization header.',
        'Make sure you authorize your request by providing the following HTTP header:',
        'Authorization: Bearer <Firebase ID Token>',
        'or by passing a "__session" cookie.');
    res.status(403).send('Unauthorized 01');
    return;
  }

  let idToken;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
    console.log('Found "Authorization" header');
    // Read the ID Token from the Authorization header.
    idToken = req.headers.authorization.split('Bearer ')[1];
  } else if(req.cookies) {
    console.log('Found "__session" cookie');
    // Read the ID Token from cookie.
    idToken = req.cookies.__session;
  } else {
    // No cookie
    res.status(403).send('Unauthorized 02');
    return;
  }

  try {
    const decodedIdToken = await admin.auth().verifyIdToken(idToken);
    console.log('ID Token correctly decoded', decodedIdToken);
    req.user = decodedIdToken;
    next();
    return;
  } catch (error) {
    console.error('Error while verifying Firebase ID token:', error);
    res.status(403).send('Unauthorized 03');
    return;
  }
};


app.use(cors);
app.use(cookieParser);
app.use(validateFirebaseIdToken);

app.get('/token', async (req, res, next) => {
// Post the authorization code to Stripe to complete the Express onboarding flow

request.post(
  'https://connect.stripe.com/oauth/token',
  {
    form: {
      grant_type: 'authorization_code',
          client_id: 'ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO',
          client_secret: 'sk_test_QoimFzURXIjRvNMtI356etvw00KjSz4gvd',
          code: req.query.code,
          user: req.user.uid,
    },
    json: true,
  },
  (err, response, body) => {
    if (err || body.error) {
      console.log('The Stripe onboarding process has not succeeded.');
    } else {
    
      var connected_account_id = body.stripe_user_id;

      stripe.accounts.createLoginLink(
        connected_account_id,
        (err, loginLink) => {
          if (err) {
            console.log(err)
          } else {
            docRef.doc(req.user.uid).set({stripeId : connected_account_id, stripeLoginLink : loginLink.url});
            res.redirect(loginLink.url);
          }
        }
      );
    }

  }
  );
});



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

exports.app = functions.https.onRequest(app);
