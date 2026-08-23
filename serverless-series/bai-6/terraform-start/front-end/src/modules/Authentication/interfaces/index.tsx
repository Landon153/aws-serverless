export interface ValuesSignupForm {
  email: string;
  password: string;
  confirm_password: string;
  full_name: string;
  accepted_terms: string[];
}

export interface ValuesChangePasswordForm {
  email: string;
  old_password: string;
  new_password: string;
}

export type ValuesLoginForm = Pick<ValuesSignupForm, "email" | "password">;
