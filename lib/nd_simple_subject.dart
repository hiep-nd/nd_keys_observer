//
//  nd_simple_subject.dart
//  nd_keys_observer
//
//  Created by Nguyen Duc Hiep on 01/12/2021.
//

import 'dart:math';

import 'package:nd_keys_observer/nd_subject.dart';

extension NDSimpleSubject on NDSubject {
  static NDSubject create() => _NDSimpleSubject();
}

class _NDSimpleSubjectObserver {
  final NDKeys keys;
  final NDCallback callback;

  _NDSimpleSubjectObserver({required this.keys, required this.callback});
}

class _NDSimpleSubject extends NDSubject {
  final Map<NDHandle, _NDSimpleSubjectObserver> _observers = {};

  @override
  void didChange(NDKeys keys, void Function()? action) {
    if (action != null) {
      action();
    }

    _observers.forEach((handle, observer) {
      var observedKeys = NDKeys.empty(growable: true);
      for (var key in observer.keys) {
        if (keys.any((element) => isRelative(element, key))) {
          observedKeys.add(key);
        }
      }
      if (observedKeys.isNotEmpty) {
        observer.callback(observedKeys);
      }
    });
  }

  @override
  NDHandle observe(NDKeys keys, NDCallback callback) {
    NDHandle handle = _observers.isEmpty ? 0 : _observers.keys.reduce(max) + 1;
    _observers[handle] =
        _NDSimpleSubjectObserver(keys: keys, callback: callback);
    return handle;
  }

  @override
  void removeObserver(NDHandle handle) {
    _observers.remove(handle);
  }

  @override
  void dispose() {
    _observers.clear();
  }
}

/*

// class Observer {
//   int key;
//   final String path;
//   Function callback;
// }


class _Handler {
  final _Callback callback;
  _Node node;
}

typedef _Nodes = List<_Node>;

class _Node {
  final _Node? parent;
  final _Nodes children = [];

  _Node({this.parent, required this.name}) {
    parent?.children.add(this);
    key = _findKey();
  }

  final String name;

  late final String key;

  String _findKey() {
    var builder = name;
    var node = this;
    while (node.parent != null) {
      node = node.parent!;
      builder = node.name + "." + builder;
    }
    return builder;
  }
}

class NDSubject {
  int observe(List<String> keys, void Function(List<String> keys) callback) {
    return 0;
  }

  void removeObserver(int handle) {}

  void didChange(List<String> keys) {
    var nodes = _findNodes(keys);
    var callbacks = _findCallbacks(nodes);
    for (Callback callback in callbacks) {
      callback(keys);
    }
  }

  void _didChangeNodes(_Nodes nodes) {}

  // final Map<int, Function> _observers = {};

  // int observe(List<String> paths, Function callback) {
  //   int key = _observers.isEmpty ? 0 : _observers.keys.reduce(max) + 1;
  //   _observers[key] = observer;
  //   return key;
  // }

  // void remoteHandler(int key) {
  //   _observers.remove(key);
  // }

  // void didUpdate(List<String> paths) {

  // }
}
*/
