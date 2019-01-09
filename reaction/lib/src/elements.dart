part of 'component.dart';

mixin _ExternalComponent on Component {
  @override
  render() => null;
}

class Text extends Component with _ExternalComponent {
  final String _text;

  @override
  String get _internalValue => _text;

  Text(this._text) : super._empty();
}

class Div extends Component with _ExternalComponent {
  Div({List<Component> children = const []}) : super._element('div', children);
}
