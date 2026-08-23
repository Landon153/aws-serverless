import {
  ValuesChangePasswordForm,
  ValuesLoginForm,
} from "@modules/Authentication/interfaces";

import BaseService from "@core/class/BaseService";

class AuthService extends BaseService {
  public login = (body: ValuesLoginForm) => {
    return this.post("/login", body);
  };

  public changePassword = (values: ValuesChangePasswordForm) => {
    return this.post("/change-password", values);
  };
}

export default new AuthService("", false);
