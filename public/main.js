function Demo() {
    document.addEventListener('DOMContentLoaded', function() {
      // Shortcuts to DOM Elements.
      this.signInButton = document.getElementById('demo-sign-in-button');
      this.signOutButton = document.getElementById('demo-sign-out-button');
      this.emailInput = document.getElementById('email')
      this.passwordInput = document.getElementById('password')
      this.responseContainer = document.getElementById('demo-response');
      this.responseContainerCookie = document.getElementById('demo-response-cookie');
      this.urlContainer = document.getElementById('demo-url');
      this.urlContainerCookie = document.getElementById('demo-url-cookie');
      this.helloUserUrl = window.location.href + 'hello';
      this.signedOutCard = document.getElementById('demo-signed-out-card');
      this.signedInCard = document.getElementById('demo-signed-in-card');
  
      // Bind events.
      this.signInButton.addEventListener('click', this.signIn.bind(this));
      this.signOutButton.addEventListener('click', this.signOut.bind(this));
      firebase.auth().onAuthStateChanged(this.onAuthStateChanged.bind(this));
    }.bind(this));
  }
  // Triggered on Firebase auth state change.
  Demo.prototype.onAuthStateChanged = function(user) {
    if (user) {
      this.urlContainer.textContent = this.helloUserUrl;
      this.urlContainerCookie.textContent = this.helloUserUrl;
      this.signedOutCard.style.display = 'none';
      this.signedInCard.style.display = 'block';
      this.startFunctionsRequest();
      this.startFunctionsCookieRequest();
    } else {
      this.signedOutCard.style.display = 'block';
      this.signedInCard.style.display = 'none';
    }
  };
  
  // Initiates the sign-in flow using GoogleAuthProvider sign in in a popup.
  Demo.prototype.signIn = function() {
      const auth = firebase.auth();
        auth.signInWithEmailAndPassword(emailInput, passwordInput);
        firebase
          .catch(function (error) {
            // Handle Errors here.
            var errorCode = error.code;
            var errorMessage = error.message;
            alert(errorMessage);
          });
  //   firebase.auth().signInWithPopup(new firebase.auth.GoogleAuthProvider());
  };
  
  // Signs-out of Firebase.
  Demo.prototype.signOut = function() {
    firebase.auth().signOut();
    // clear the __session cookie
    document.cookie = '__session=';
  };
  
  // Does an authenticated request to a Firebase Functions endpoint using an Authorization header.
  Demo.prototype.startFunctionsRequest = function() {
    firebase.auth().currentUser.getIdToken().then(function(token) {
      console.log('Sending request to', this.helloUserUrl, 'with ID token in Authorization header.');
      var req = new XMLHttpRequest();
      req.onload = function() {
        this.responseContainer.innerText = req.responseText;
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
        this.responseContainerCookie.innerText = req.responseText;
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