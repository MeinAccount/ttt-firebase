// Initialize Firebase
var config = {
  apiKey: "AIzaSyDzx9SCOhM-nf6_0qUl5Qyn_68h9Sf-l_o",
  authDomain: "ttt-firebase.firebaseapp.com",
  databaseURL: "https://ttt-firebase.firebaseio.com",
  storageBucket: "ttt-firebase.appspot.com",
  messagingSenderId: "980310354616"
};
firebase.initializeApp(config);

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
