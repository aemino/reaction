@JS('React')
library react.react;

import 'dart:js';

import 'package:js/js.dart';

@JS()
external ReactElement createElement(String name, [Map props, List children]);

@JS('createElement')
external ReactElement createComponent(JsObject obj, [Map props, List children]);

@anonymous
@JS()
abstract class ReactElement {
  external ComponentProps get props;
}

@anonymous
@JS()
abstract class ComponentProps implements Map<dynamic, dynamic> {
  external List<ReactElement> get children;
}

@JS()
abstract class Component implements ReactElement {
  external static Map getDerivedStateFromProps(ComponentProps props, Map state);

  external String get displayName;

  @override
  external ComponentProps get props;
  // external set props(Map props);
  external Map get state;
  //external set state(Map state);

  external Component(Map props);

  external void componentWillMount();
  external void componentDidUpdate(ComponentProps prevProps, Map prevState,
      [dynamic snapshot]);
  external void componentWillUnmount();
  external bool shouldComponentUpdate(ComponentProps nextProps, Map nextState);
  external dynamic getSnapshotBeforeUpdate(
      ComponentProps prevProps, Map prevState);
  // TODO: componentDidCatch()
  external void setState(Map Function(Map state, ComponentProps props) updater,
      [void Function() callback]);
  external void forceUpdate(void Function() callback);

  ReactElement render();
}
