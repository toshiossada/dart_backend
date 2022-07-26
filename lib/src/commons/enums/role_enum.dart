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

RoleEnum toRoleEnum(String str) {
  switch (str) {
    case 'admin':
      return RoleEnum.admin;
    case 'user':
      return RoleEnum.user;
    case 'manager':
    default:
      return RoleEnum.manager;
  }
}
