import { ModuleConfig } from "@core/interfaces";

const config: ModuleConfig = {
  name: "Authentication",
  baseUrl: "",
  routes: [
    {
      path: "/login",
      page: "Login",
      title: "Login",
      exact: true,
    },
    {
      path: "/change-password",
      page: "ChangePassword",
      title: "Change Password",
      exact: true,
    },
  ],
  requireAuthenticated: false,
};

export default config;
