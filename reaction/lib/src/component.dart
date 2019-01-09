@JS()
library reaction.component;

import 'dart:html';
import 'dart:js';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

part 'elements.dart';

class _ReactComponent {
  Component get _dartComponent => props['_dartComponent'];

  get displayName => _dartComponent.runtimeType.toString();

  @override
  void componentWillMount() => _dartComponent._componentWillMount();

  @override
  void componentDidUpdate(prevProps, prevState, [snapshot]) =>
      _dartComponent._componentDidUpdate(prevProps, prevState, snapshot);

  @override
  void componentWillUnmount() => _dartComponent._componentWillUnmount();

  @override
  bool shouldComponentUpdate(nextProps, nextState) =>
      _dartComponent._shouldComponentUpdate(nextProps, nextState);

  @override
  dynamic getSnapshotBeforeUpdate(prevProps, prevState) =>
      _dartComponent._getSnapshotBeforeUpdate(prevProps, prevState);

  // TODO: componentDidCatch()

  @override
  render() => _dartComponent._render();
}

final JsObject _reactComponent = JsObject.jsify({});

@JS()
external JsObject createReactClass(JsObject obj);

final _ReactComponentClass = createReactClass(_ReactComponent());

abstract class Component {
  dynamic get _internalValue => _reactComponent;
  react.Component _reactComponent;

  final List<Component> children;

  Component._internal([this.children = const []]) {
    _reactComponent = react.createComponent(
        _ReactComponentClass,
        /*props*/ {'_dartComponent': this},
        children.map((c) => c._internalValue).toList());
  }

  Component._element(String element, [this.children = const []]) {
    _reactComponent = react.createElement(
        element,
        /* props */ {'_dartComponent': this},
        children.map((c) => c._internalValue).toList());
  }

  Component._empty() : children = const [];

  Component() : this._internal();

  // React Component event interceptors

  void _componentWillMount() => componentWillMount();

  void _componentDidUpdate(react.ComponentProps prevProps, Map prevState,
          [dynamic snapshot]) =>
      componentDidUpdate(prevProps, prevState, snapshot);

  void _componentWillUnmount() => componentWillUnmount();

  bool _shouldComponentUpdate(react.ComponentProps nextProps, Map nextState) =>
      shouldComponentUpdate(nextProps, nextState);

  dynamic _getSnapshotBeforeUpdate(
          react.ComponentProps prevProps, Map prevState) =>
      getSnapshotBeforeUpdate(prevProps, prevState);

  // Overridable event handlers

  void componentWillMount() => null;

  void componentDidUpdate(react.ComponentProps prevProps, Map prevState,
          [dynamic snapshot]) =>
      null;

  void componentWillUnmount() => null;

  bool shouldComponentUpdate(react.ComponentProps nextProps, Map nextState) =>
      true;

  dynamic getSnapshotBeforeUpdate(
          react.ComponentProps prevProps, Map prevState) =>
      null;

  // Render handler

  dynamic _render() => render()._internalValue;

  Component render();
}

void magicMountMachine(Component component, Element container) =>
    react_dom.render(component._internalValue, container);
