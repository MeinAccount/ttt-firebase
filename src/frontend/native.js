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
