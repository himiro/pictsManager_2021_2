import 'package:permission_handler/permission_handler.dart';

class PermissionHandler
{
  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  PermissionHandler(this._permission)
  {
    requestPermission(_permission);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    print(status);
    _permissionStatus = status;
    print(_permissionStatus);
  }
}