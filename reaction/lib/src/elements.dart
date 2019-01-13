part of 'component.dart';

class _ExternalComponent extends BaseComponent<react.ReactElement> {
  final List<BaseComponent> children;
  react.ReactElement _reactElement;

  @override
  react.ReactElement get _internalValue => _reactElement;

  _ExternalComponent(String element, [this.children = const []]) {
    _reactElement = Function.apply(
        react.createElement,
        [element, {}]
            .followedBy(children.map((c) => c._internalValue))
            .toList()) as react.ReactElement;
  }
}

class Text extends BaseComponent<String> {
  final String _text;

  @override
  String get _internalValue => _text;

  Text(this._text);
}

class Div extends _ExternalComponent {
  Div({List<BaseComponent> children = const []}) : super('div', children);
}
