library notificator;

typedef void EmptyCallback();

class Notificator {
  List<EmptyCallback> _stack = [];
  Map<Notificator, EmptyCallback> _pipes;

  void add(void callback()) {
    if (_stack.contains(callback)) return;
    _stack.add(callback);
  }

  void remove(void callback()) {
    _stack.remove(callback);
  }

  void notify() {
    for (EmptyCallback callback in new List<EmptyCallback>.unmodifiable(_stack)) {
      callback();
    }
  }

  void addPipe(Notificator next) {
    if (_pipes == null) _pipes = <Notificator, EmptyCallback>{};
    if (_pipes.containsKey(next)) return;
    _pipes[next] = () {
      next.notify();
    };
    _stack.add(_pipes[next]);
  }

  void removePipe(Notificator next) {
    if (_pipes == null) return;
    if (!_pipes.containsKey(next)) return;
    _stack.remove(_pipes[next]);
    _pipes.remove(next);
  }

  void clear() {
    _stack.clear();
  }

  void announce(dynamic message, String category) {
    add(() {
     print("$message, $category");
    });
  }
}

class LazyNotificator extends Notificator {
  EmptyCallback onFirstAdd;
  bool _first = true;
  LazyNotificator(this.onFirstAdd);

  @override
  void add(void callback()) {
    _stack.add(callback);
    if (_first) {
      onFirstAdd();
      _first = false;
    }
  }
}

typedef void _ValueCallback<S>(S s);

class ValueNotificator<T> {
  List<_ValueCallback> _stack = [];
  Map<ValueNotificator<T>, _ValueCallback> _pipes;

  void add(void callback(T value)) {
    if (_stack.contains(callback)) return;
    _stack.add(callback);
  }

  void remove(void callback(T value)) {
    _stack.remove(callback);
  }

  void addPipe(ValueNotificator<T> next) {
    if (_pipes == null) _pipes = <ValueNotificator<T>, _ValueCallback>{};
    if (_pipes.containsKey(next)) return;
    _pipes[next] = (T value) {
      next.notify(value);
    };
    _stack.add(_pipes[next]);
  }

  void removePipe(ValueNotificator<T> next) {
    if (_pipes == null) return;
    if (!_pipes.containsKey(next)) return;
    _stack.remove(_pipes[next]);
    _pipes.remove(next);
  }

  void notify(T value) {
    for (_ValueCallback callback in new List<_ValueCallback>.unmodifiable(_stack)) {
      callback(value);
    }
  }

  void clear() {
    _stack.clear();
  }

//  void announce(dynamic messageGenerator(T value), String category) {
//    add((T value) {
//      Inspector.log(messageGenerator(value), category);
//    });
//  }
}
