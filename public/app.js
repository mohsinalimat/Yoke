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
// const stripe = require('stripe')(firebase.config().stripe.token)
// Stripe.setPublishableKey(pk_test_pX3V6XXnlsluthlhaKXHrW5U00WHz0znIt)

var auth = firebase.auth()


// Reference to database method of Firebase
var database = firebase.database()

// UID needs to global. Declare here but get the value from the auth state listener
var uid 

// Get the modal
const modal = document.getElementById(`modal`)

// Get the element that closes the modal
const close = document.getElementById(`close`)

// When the user clicks the (x) button close the modal
close.addEventListener(`click`, () => {
    modal.style.display = `none`
})

// When the user click anywhere outside of the modal close it.
window.addEventListener(`click`, event => {
	if (event.target === modal){
		modal.style.display = `none`
	}
})

// Get forms for email and password authentication
const createUserForm = document.getElementById('create-user-form')
const signInForm = document.getElementById('sign-in-form')
const forgotPasswordForm = document.getElementById('forgot-password-form')

// Get element that holds OAuth providers
// const oauthProviders = document.getElementById('oauth-providers')

// Get the authentication dialogs
const createUserDialog = document.getElementById('create-user-dialog')
const signInDialog = document.getElementById('sign-in-dialog')
const hideOrNeedAccountDialog = document.getElementById('have-or-need-account-dialog')
const deleteAccountDialog = document.getElementById('delete-account-dialog')
const stripeAccount = document.getElementById('demo-response')

// Get trigger to show delete account dialog
const showDeleteAccountDialogTrigger = document.getElementById('show-delete-account-dialog-trigger')

// Get elements that need to be hidden or shown based on auth state
const hideWhenSignedIn = document.querySelectorAll('.hide-when-signed-in')
const hideWhenSignedOut = document.querySelectorAll('.hide-when-signed-out')

// Get element where email not verified notification will be placed
const emailNotVerifiedNotification = document.getElementById(`email-not-verified-notification`)

// Get element that is the input we will click to upload our profile photo file
// const uploadProfilePhotoButton = document.getElementById('upload-profile-photo-button')

// Get elements where we will place our users photos at
const profilePhotoAccount = document.getElementById('profile-photo-account')
const profilePhotoHeader = document.getElementById('profile-photo-header')

// Get element that shows the progress of the photo uploading action
const progressBar = document.getElementById('progress-bar')

// Get element that we will display our success and error messages 
const authMessage = document.getElementById(`message`)

// access auth elements to listen for auth actions
const authAction = document.querySelectorAll(`.auth`)

// Loop through elements and use the auth attribute to determine what action to take when clicked
authAction.forEach(eachItem => {
	eachItem.addEventListener(`click`, event => {
		let chosen = event.target.getAttribute(`auth`)
		if (chosen === 'show-create-user-form'){
			showCreateUserForm()
		} else if (chosen === 'show-sign-in-form'){
			showSignInForm()
		} else if (chosen === 'show-forgot-password-form'){
			showForgotPasswordForm()
		} else if (chosen === 'sign-out'){
			signOut()
		} else if (chosen === 'show-delete-account-dialog'){
			showDeleteAccountDialog()
		} else if (chosen === 'hide-delete-account-dialog'){
			hideDeleteAccountDialog()
		} else if (chosen === 'delete-account'){
			deleteAccount()
		} 
	})
})

// Invoked when we want to hide all auth elements
hideAuthElements = () => {
	clearMessage()
	loading(`hide`)
	hideDeleteAccountDialog()
	// oauthProviders.classList.add(`hide`)
	createUserForm.classList.add(`hide`)
	signInForm.classList.add(`hide`)
	forgotPasswordForm.classList.add(`hide`)
	createUserDialog.classList.add(`hide`)
	signInDialog.classList.add(`hide`)
	hideOrNeedAccountDialog.classList.add(`hide`)
}

// Invoked when user wants to create a new account
showCreateUserForm = () => {
	hideAuthElements()
	modal.style.display = `block`
	// oauthProviders.classList.remove(`hide`)
	createUserForm.classList.remove(`hide`)
	signInDialog.classList.remove(`hide`)
	hideOrNeedAccountDialog.classList.remove(`hide`)
}

// Invoked when a user wants to sign in
showSignInForm = () => {
	hideAuthElements()
	modal.style.display = `block`
	// oauthProviders.classList.remove(`hide`)
	signInForm.classList.remove(`hide`)
	createUserDialog.classList.remove(`hide`)
	hideOrNeedAccountDialog.classList.remove(`hide`)
}

// Invoked when a user wants reset their password
showForgotPasswordForm = () => {
	hideAuthElements()
	forgotPasswordForm.classList.remove(`hide`)
}

// Invoked when a user wants to sign out
signOut = () => {
	auth.signOut()
	clearLocalStorage()
}

// Invoked when a user wants to delete their account
deleteAccount = () => {
	storage.ref(`user-profile-photos/`).child(uid).delete()
	auth.currentUser.delete()
	.then(() => {
		// clearLocalStorage()
		return hideAuthElements()
	})
	.catch(error => {
		if (error.code === 'auth/requires-recent-login'){
			return auth.signOut()
			.then(() => {
				showSignInForm()
				return displayMessage(`error`, error.message)
			})
		}
	})
}

// Invoked when user clicks show account dialog 
showDeleteAccountDialog = () => {
	deleteAccountDialog.classList.remove(`hide`)
	showDeleteAccountDialogTrigger.classList.add(`hide`)
}

// Invoked when user clicks cancel delete account
hideDeleteAccountDialog = () => {
	deleteAccountDialog.classList.add(`hide`)
	showDeleteAccountDialogTrigger.classList.remove(`hide`)
}

sendTokenId = () => {
	firebase.auth().currentUser.getIdToken().then(function(token) {
		var req = new XMLHttpRequest();
		req.onload = function() {
			// stripeAccount.innerText = req.responseText;
			// stripeAccount.innerText = `Hello ${req.user.uid}`
		}.bind(this);
		req.onerror = function() {
		  console.log('There was an error');
		  // this.responseContainer.innerText = 'There was an error';
		}.bind(this);
		//worked with /connected
		req.open('GET', 'https://foodapp-4ebf0.firebaseapp.com/', true);
		req.setRequestHeader('Authorization', 'Bearer ' + token);
		req.send();
	  }.bind(this));
}

startFunctionsCookieRequest = function() {
	// Set the __session cookie.
	firebase.auth().currentUser.getIdToken(true).then(function(token) {
	  // set the __session cookie
	  document.cookie = '__session=' + token + ';max-age=3600';
	  var req = new XMLHttpRequest();
	  req.onload = function() {
		// this.responseContainerCookie.innerText = req.responseText;
	  }.bind(this);
	  req.onerror = function() {
		// this.responseContainerCookie.innerText = 'There was an error';
	  }.bind(this);
	  req.open('GET', 'https://foodapp-4ebf0.firebaseapp.com/', true);
	  req.send();
	}.bind(this));
  };

// Firebase monitors the auth state in real time. Use an if/else statement to do different things based on that state
auth.onAuthStateChanged(user => {
	if (user) {
		// Everything inside here happens if user is signed in
		console.log(user)
		uid = user.uid
		modal.style.display = `none`
		sendTokenId()
		startFunctionsCookieRequest()

		// Greet the user with a message and make it personal by using their name
		if(user.displayName){
			document.getElementById(`display-name`).textContent = `Hello, ${user.username}`
		}
		const stripeButton = document.getElementById(`stripe-button`)
		const userRef = firebase.firestore().collection('StripeAccounts').doc(uid)
        userRef.get()
		.then((docSnapshot) => {
			if (docSnapshot.exists) {
			   console.log(docSnapshot)
			   stripeButton.style.display = 'none'
			} else {
				console.log('doc not exists')
			}
		});

	} else {
		// Everything inside here happens if user is not signed in
		console.log('not signed in');

		// Hides or show elements depending on if user is signed out
		hideWhenSignedIn.forEach(eachItem => {
			eachItem.classList.remove(`hide`)
		})
		hideWhenSignedOut.forEach(eachItem => {
			eachItem.classList.add(`hide`)
		})
	}
})

// Create user form submit event
createUserForm.addEventListener(`submit`, event => {
	event.preventDefault()
	loading(`show`)
	const displayName = document.getElementById('create-user-display-name').value
	const email = document.getElementById('create-user-email').value
	const password = document.getElementById('create-user-password').value
	auth.createUserWithEmailAndPassword(email, password)
	.then(() => {
	   firebase.auth().currentUser.updateProfile({
			displayName: displayName
		})
		createUserForm.reset()
		hideAuthElements()
		return localStorage.setItem('isAuthenticatedWithEmail', 'true')
	})
	.catch(error => {
		loading(`hide`)
		displayMessage(`error`, error.message)
    })
})

// Sign in form submit event
logInForm.addEventListener(`submit`, event => {
	console.log('sign in hit')
	event.preventDefault()
	loading(`show`)
	const email = document.getElementById('sign-in-email').value
	const password = document.getElementById('sign-in-password').value
	auth.signInWithEmailAndPassword(email, password)
	.then(() => {
		signInForm.reset()
		hideAuthElements()
		console.log('signed in')
		return localStorage.setItem('isAuthenticatedWithEmail', 'true')
	})
	.catch(error => {
		loading(`hide`)
		displayMessage(`error`, error.message)
	})
})

// Forgot password form submit event
forgotPasswordForm.addEventListener(`submit`, event => {
	event.preventDefault()
	loading(`show`)
	email = document.getElementById('forgot-password-email').value
	auth.sendPasswordResetEmail(email)
	.then(() => {
		loading(`hide`)
		forgotPasswordForm.reset()
		return displayMessage(`success`, 'Message sent. Please check your email')
	})
	.catch(error => {
		loading(`hide`)
		displayMessage(`error`, error.message)
	})
})

// Makes the messageTimeout and success Timeout global so that the clearTimeout method will work when invoked
let messageTimeout

// Error and message handling
// displayMessage = (type, message) => {
// 	if (type === `error`){
// 		authMessage.style.borderColor = `red`
// 		authMessage.style.color = 'red'
// 		authMessage.style.display = `block`
// 	} else if (type === `success`){
// 		authMessage.style.borderColor = `green`
// 		authMessage.style.color = 'green'
// 		authMessage.style.display = `block`
// 	}

// 	authMessage.innerHTML = message
// 	messageTimeout = setTimeout(() => {
// 		authMessage.innerHTML = ``
// 		authMessage.style.display = `none`
// 	}, 7000)
// }

// clearMessage = () => {
// 	clearTimeout(messageTimeout)
// 	authMessage.innerHTML = ``
// 	authMessage.style.display = `none`
// }

// Function to hide and show the loading visual cue
loading = (action) => {
	if (action === `show`){
		document.getElementById(`loading-outer-container`).style.display = `block`
	} else if (action === `hide`){
		document.getElementById(`loading-outer-container`).style.display = `none`
	} else {
		console.log(`loading error`);	
	}
}

// Clear users email verification status from localStorage
clearLocalStorage = () => {
	localStorage.removeItem('emailVerificationSent')
	localStorage.removeItem('isAuthenticatedWithEmail')
}

const balanceButton = document.getElementById('dash-button')
balanceButton.addEventListener(`click`, event => {
	window.location.href = 'https://foodapp-4ebf0.firebaseapp.com/dashboard'
	console.log('working')
})

const stripeButton = document.getElementById(`stripe-button`)
stripeButton.addEventListener(`click`, event => {
	window.location.href = 'https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://foodapp-4ebf0.firebaseapp.com/token&client_id=ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO&state={STATE_VALUE}&suggested_capabilities[]=transfers&stripe_user[email]=user@example.com'
})

