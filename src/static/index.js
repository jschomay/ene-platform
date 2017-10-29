require( 'bootstrap-css-only' );
require( './styles/main.css' );

var Elm = require( '../elm/Main' );
Elm.Main.embed( document.getElementById( 'main' ) );
