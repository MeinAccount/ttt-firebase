var node = document.getElementById('my-app');
var app = Elm.Main.embed(node);

if ('requestIdleCallback' in window && document.images) {
  var cross = new Image();
	cross.src = "/assets/cross.svg";

  var circle = new Image();
	circle.src = "/assets/circle.svg";
}
