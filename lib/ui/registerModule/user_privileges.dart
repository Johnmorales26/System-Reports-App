enum UserPrivileges { user, admin }

UserPrivileges getUserPrivilegeFromString(String privilegeString) {
  switch (privilegeString) {
    case 'user':
      return UserPrivileges.user;
    case 'admin':
      return UserPrivileges.admin;
    default:
      throw ArgumentError('Unknown privilege string: $privilegeString');
  }
}