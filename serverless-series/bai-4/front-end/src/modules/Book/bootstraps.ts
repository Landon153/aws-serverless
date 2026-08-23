import { ModuleConfig } from "@core/interfaces";

const config: ModuleConfig = {
  name: "Book",
  baseUrl: "/books",
  routes: [
    {
      path: "create",
      page: "Create",
      title: "Create a new book",
      exact: true,
    },
  ],
  requireAuthenticated: "any",
};

export default config;
