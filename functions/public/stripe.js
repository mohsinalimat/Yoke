'use strict';
const functions = require('firebase-functions');
const stripe = require('stripe')(functions.config().stripe.token);

showAccountBalance = () => {
	const userRef = firebase.firestore().collection('StripeAccounts').doc(uid)
	userRef.get()
		.then((doc) => {
			if (doc.exists) {
				var accountId = doc.data().stripeId
				stripeAccount.textContent = accountId
				const balance = await stripe.balance.retrieve({
    				stripe_account: accountId,
  				})
  				console.log(balance)
			} else {
				console.log('doc not exists')
			}
	});
}