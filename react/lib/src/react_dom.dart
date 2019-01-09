@JS('ReactDOM')
library react.react_dom;

import 'dart:html';

import 'package:js/js.dart';

import 'react.dart';

// TODO: This actually returns a Ref to the root Component instance.
@JS()
external dynamic render(ReactElement element, Element container);
