abstract class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is FailureResult<T, E>;

  T? get data => (this is Success<T, E>) ? (this as Success<T, E>).value : null;
  E? get failure => (this is FailureResult<T, E>)
      ? (this as FailureResult<T, E>).error
      : null;

  R fold<R>(R Function(E error) onFailure, R Function(T data) onSuccess) {
    if (this is Success<T, E>) {
      return onSuccess((this as Success<T, E>).value);
    } else {
      return onFailure((this as FailureResult<T, E>).error);
    }
  }
}

class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

class FailureResult<T, E> extends Result<T, E> {
  final E error;
  const FailureResult(this.error);
}
