import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config_example/usecases.dart';
import 'package:bloc/bloc.dart';

class DeviceInspectorBloc
    extends Bloc<DeviceInspectorEvent, DeviceInspectorState> {
  DeviceInspectorBloc() : super(const DeviceInspectorStateInitial()) {
    on<DeviceInspectorEventAppStart>((_onDeviceInspectorEventAppStart));
    on<DeviceInspectorEventChangePath>(_onDeviceInspectorEventChangePath);
  }

  void _onDeviceInspectorEventChangePath(
    DeviceInspectorEventChangePath event,
    Emitter<DeviceInspectorState> emit,
  ) async {
    if (state is DeviceInspectorStateEmulated) {
      return;
    }
    emit(DeviceInspectorStateWebView(path: event.path));
    savePath(event.path);
  }

  void _onDeviceInspectorEventAppStart(
    DeviceInspectorEventAppStart event,
    Emitter<DeviceInspectorState> emit,
  ) async {
    emit(const DeviceInspectorStateInitial());

    bool emulation = await checkEmulation();
    if (emulation) {
      emit(const DeviceInspectorStateEmulated());
      return;
    }

    String? path = await savedPath();
    if (path != null) {
      emit(DeviceInspectorStateWebView(path: path));
    } else {
      emit(const DeviceInspectorStatePathWaiting());
    }
  }
}

class DeviceInspectorState extends Equatable {
  const DeviceInspectorState();

  @override
  List<Object> get props => [];
}

class DeviceInspectorStateInitial extends DeviceInspectorState {
  const DeviceInspectorStateInitial();

  @override
  List<Object> get props => [];
}

class DeviceInspectorStateEmulated extends DeviceInspectorState {
  const DeviceInspectorStateEmulated();

  @override
  List<Object> get props => [];
}

class DeviceInspectorStatePathWaiting extends DeviceInspectorState {
  const DeviceInspectorStatePathWaiting();

  @override
  List<Object> get props => [];
}

class DeviceInspectorStateWebView extends DeviceInspectorState {
  const DeviceInspectorStateWebView({required this.path});

  final String path;

  @override
  List<Object> get props => [path];
}

class DeviceInspectorEvent extends Equatable {
  const DeviceInspectorEvent();

  @override
  List<Object> get props => [];
}

class DeviceInspectorEventAppStart extends DeviceInspectorEvent {
  const DeviceInspectorEventAppStart();

  @override
  List<Object> get props => [];
}

class DeviceInspectorEventChangePath extends DeviceInspectorEvent {
  const DeviceInspectorEventChangePath({required this.path});

  final String path;

  @override
  List<Object> get props => [path];
}
