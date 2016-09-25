// Initialize Firebase
var config = {
  apiKey: "AIzaSyDzx9SCOhM-nf6_0qUl5Qyn_68h9Sf-l_o",
  authDomain: "ttt-firebase.firebaseapp.com",
  databaseURL: "https://ttt-firebase.firebaseio.com",
  storageBucket: "ttt-firebase.appspot.com",
  messagingSenderId: "980310354616"
};
firebase.initializeApp(config);

// auth
app.ports.authMsg.subscribe(function(action) {
  switch (action) {
    case 'SignInGoogle':
      firebase.auth().signInWithPopup(new firebase.auth.GoogleAuthProvider());
      break;
    default:
      firebase.auth().signOut();
  }
});

firebase.auth().onAuthStateChanged(function(user) {
  app.ports.currentUser.send(user);

  if (user !== null) {
    var gameRef = firebase.database().ref('private/'+user.uid);
    gameRef.on('value', function(snapshot) {
      var values = snapshot.val() || {};
      app.ports.updateGame.send({
        uid: values.uid || user.uid,
        coords: values.coords || [],
        nextPlayer: values.nextPlayer !== undefined ? values.nextPlayer : null
      });
    });
  }
});

// storing state
app.ports.saveGame.subscribe(function(data) {
  if (data.uid) {
    firebase.database().ref('private/'+data.uid).set(data);
  }
});

// generated content events
app.ports.bindClick.subscribe(function() {
  var listener = function(event) {
    if (event.target.nodeName === 'TABLE') {
      app.ports.clickOverlay.send(true);
    }
  };

  setTimeout(function() {
    document.querySelector('#ttt').addEventListener('dblclick', listener);
  }, 1000);
});
