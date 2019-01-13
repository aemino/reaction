import 'dart:html';

import 'package:reaction/reaction.dart';

class MyComponent extends Component {
  @override
  render() => Div(children: [Text('hello')]);
}

void runApp() {
  print("Mounting!");
  magicMountMachine(MyComponent(), querySelector('#app-mount'));
}
