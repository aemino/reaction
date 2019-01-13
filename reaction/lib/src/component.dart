@JS()
library reaction.component;

import 'dart:html';
import 'dart:js';
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/create_react_class.dart';

part 'elements.dart';

class _ReactComponentProxy implements react.Component {
  final Component _dartComponent;
  react.ReactElement _reactElement;

  _ReactComponentProxy(this._dartComponent,
      {Map props, List children = const []}) {
    final componentProps = newObject();
    final componentChildren = children.map((c) => c._internalValue);
    final args = [_reactComponentClass, componentProps]
        .followedBy(componentChildren)
        .toList();

    print('here');
    setProperty(componentProps, '__proxy__', this);

    _reactElement =
        Function.apply(react.createComponent, args) as react.ReactElement;
  }

  @override
  String get displayName => _dartComponent.runtimeType.toString();

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
  react.ReactElement render() => _dartComponent._render();

  @override
  react.ComponentProps get props => _reactElement.props;

  // TODO: Fix this
  @override
  Map get state => null;

  @override
  void forceUpdate(callback) => callMethod(
      _reactElement, 'forceUpdate', [allowInteropCaptureThis(callback)]);

  @override
  void setState(updater, [callback]) => callMethod(_reactElement, 'setState',
      [updater, callback == null ? null : allowInteropCaptureThis(callback)]);
}

class _ReactComponentClass {
  static _ReactComponentProxy getProxy(self) {
    print('props');
    callMethod(window.console, 'log', [(self as react.ReactElement).props]);
    return (self as react.ReactElement).props['__proxy__']
        as _ReactComponentProxy;
  }

  static String getDisplayName(self) =>
      _ReactComponentClass.getProxy(self).displayName;

  static void componentWillMount(self) =>
      _ReactComponentClass.getProxy(self).componentWillMount();

  static void componentDidUpdate(
          self, react.ComponentProps prevProps, Map prevState, [snapshot]) =>
      _ReactComponentClass.getProxy(self)
          .componentDidUpdate(prevProps, prevState, snapshot);

  static void componentWillUnmount(self) =>
      _ReactComponentClass.getProxy(self).componentWillUnmount();

  static void shouldComponentUpdate(
          self, react.ComponentProps nextProps, Map nextState) =>
      _ReactComponentClass.getProxy(self)
          .shouldComponentUpdate(nextProps, nextState);

  static void getSnapshotBeforeUpdate(
          self, react.ComponentProps prevProps, Map prevState) =>
      _ReactComponentClass.getProxy(self)
          .getSnapshotBeforeUpdate(prevProps, prevState);

  static react.ReactElement render(self) => _ReactComponentClass.getProxy(self).render();
}

dynamic _createReactComponentClass() {
  final _classObject = newObject();
  setProperty(_classObject, 'render',
    allowInteropCaptureThis(_ReactComponentClass.render));

  return createReactClass(_classObject);
}

final _reactComponentClass = _createReactComponentClass();

abstract class BaseComponent<T> {
  T get _internalValue;
}

abstract class Component implements BaseComponent<react.ReactElement> {
  _ReactComponentProxy _reactComponentProxy;

  @override
  react.ReactElement get _internalValue => _reactComponentProxy._reactElement;

  final List<BaseComponent> children;

  Component({List<BaseComponent> children = const []})
      : this._internal(children);

  Component._internal([this.children = const []]) {
    _reactComponentProxy =
        _ReactComponentProxy(this, props: {}, children: children);
  }

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

  void componentWillMount() => null; // ignore: avoid_returning_null_for_void

  void componentDidUpdate(react.ComponentProps prevProps, Map prevState,
          [dynamic snapshot]) => // ignore: avoid_returning_null_for_void
      null;

  void componentWillUnmount() => null; // ignore: avoid_returning_null_for_void

  bool shouldComponentUpdate(react.ComponentProps nextProps, Map nextState) =>
      true;

  dynamic getSnapshotBeforeUpdate(
          react.ComponentProps prevProps, Map prevState) =>
      null;

  // Render handler

  react.ReactElement _render() => render()._internalValue;

  BaseComponent<react.ReactElement> render();
}

void magicMountMachine(Component component, Element container) =>
    react_dom.render(component._internalValue, container);
