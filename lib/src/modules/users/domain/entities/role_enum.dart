enum RoleEnum {
  admin,
  user,
  manager;

  @override
  String toString() {
    switch (this) {
      case RoleEnum.admin:
        return 'admin';
      case RoleEnum.user:
        return 'user';
      case RoleEnum.manager:
        return 'manager';
    }
  }
}
