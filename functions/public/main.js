'use strict';
function Demo() {
  document.addEventListener('DOMContentLoaded', function() {
    this.signInButton = document.getElementById('sign-in-button');
    this.signOutButton = document.getElementById('demo-sign-out-button');
    this.responseContainer = document.getElementById('demo-response');
    this.iframeContainer = document.getElementById('dashboardLink');
    this.responseContainer2 = document.getElementById('demo-response2');
    this.responseContainerCookie = document.getElementById('demo-response-cookie');
    this.urlContainer = document.getElementById('demo-url');
    this.urlContainerCookie = document.getElementById('demo-url-cookie');
    this.helloUserUrl = window.location.href + 'index';
    this.dashboardUserUrl = window.location.href + 'dashboard';
    this.signedOutCard = document.getElementById('demo-signed-out-card');
    this.signedInCard = document.getElementById('demo-signed-in-card');
    this.stripeButton = document.getElementById(`stripe-button`);
    this.dashboardButton = document.getElementById('stripe-dashboard');

    this.dashboardButton.addEventListener('click', this.viewDashboard.bind(this));
    this.stripeButton.addEventListener('click', this.setupStripe.bind(this));
    this.signInButton.addEventListener('click', this.signIn.bind(this));
    this.signOutButton.addEventListener('click', this.signOut.bind(this));
    firebase.auth().onAuthStateChanged(this.onAuthStateChanged.bind(this));
  }.bind(this));
}

// Triggered on Firebase auth state change.
Demo.prototype.onAuthStateChanged = function(user) {
  if (user) {
    console.log("user signed in");
    // this.urlContainer.textContent = user.uid;
    // this.urlContainerCookie.textContent = this.helloUserUrl;
    this.signedOutCard.style.display = 'none';
    this.signedInCard.style.display = 'block';
    this.startFunctionsRequest();
    this.startFunctionsCookieRequest();
    // this.stripeAccount();
  } else {
    console.log("user signed out");
    this.signedOutCard.style.display = 'block';
    this.signedInCard.style.display = 'none';
  }
};

Demo.prototype.setupStripe = function() {
  window.location.href = 'https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://foodapp-4ebf0.firebaseapp.com/token&client_id=ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO&state={STATE_VALUE}&suggested_capabilities[]=transfers&stripe_user[email]=user@example.com';
};

Demo.prototype.viewDashboard = function() {
  var uid = firebase.auth().currentUser.uid;
	const userRef = firebase.firestore().collection('StripeAccounts').doc(uid);
  userRef.get()
		.then((docSnapshot) => {
			if (docSnapshot.exists) {
        var data = docSnapshot.data().stripeLoginLink;
        window.location.href = data;
			} else {
				console.log('doc not exists')
			}
		});
}

// Initiates the sign-in flow using GoogleAuthProvider sign in in a popup.
Demo.prototype.signIn = function() {
  const email = document.getElementById('sign-in-email').value
	const password = document.getElementById('sign-in-password').value
	firebase.auth().signInWithEmailAndPassword(email, password)
	.then(() => {
    console.log('signed in')
	})
	.catch(error => {
    console.log(error)
	})
};

// Signs-out of Firebase.
Demo.prototype.signOut = function() {
  firebase.auth().signOut();
  // clear the __session cookie
  document.cookie = '__session=';
};

// Demo.prototype.stripeAccount = function() {
//   var uid = firebase.auth().currentUser.uid;
// 	const userRef = firebase.firestore().collection('StripeAccounts').doc(uid);
//   userRef.get()
// 		.then((docSnapshot) => {
// 			if (docSnapshot.exists) {
// 			   this.stripeButton.style.display = 'none';
// 			} else {
//         this.dashboardButton.style.display = 'none';
// 				console.log('doc not exists')
// 			}
// 		});
// };

// Does an authenticated request to a Firebase Functions endpoint using an Authorization header.
Demo.prototype.startFunctionsRequest = function() {
  firebase.auth().currentUser.getIdToken().then(function(token) {
    console.log('Sending request to', this.helloUserUrl, 'with ID token in Authorization header.');
    var req = new XMLHttpRequest();
    req.onload = function() {
      // this.responseContainer.innerHTML = req.response;
      // this.responseContainer.innerText = req.responseText;
    }.bind(this);
    req.onerror = function() {
      this.responseContainer.innerText = 'There was an error';
    }.bind(this);
    req.open('GET', this.helloUserUrl, true);
    req.setRequestHeader('Authorization', 'Bearer ' + token);
    req.send();
  }.bind(this));
};

// Does an authenticated request to a Firebase Functions endpoint using a __session cookie.
Demo.prototype.startFunctionsCookieRequest = function() {
  // Set the __session cookie.
  firebase.auth().currentUser.getIdToken(true).then(function(token) {
    // set the __session cookie
    document.cookie = '__session=' + token + ';max-age=3600';

    console.log('Sending request to', this.helloUserUrl, 'with ID token in __session cookie.');
    var req = new XMLHttpRequest();
    req.onload = function() {
      // this.responseContainerCookie.innerHTML = req.response;
    }.bind(this);
    req.onerror = function() {
      this.responseContainerCookie.innerText = 'There was an error';
    }.bind(this);
    req.open('GET', this.helloUserUrl, true);
    req.send();
  }.bind(this));
};

// Load the demo.
window.demo = new Demo();

