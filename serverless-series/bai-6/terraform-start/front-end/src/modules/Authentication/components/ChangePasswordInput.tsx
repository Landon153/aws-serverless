import { Form, Input } from "antd";

import useTranslate from "@core/hooks/useTranslate";

const ChangePasswordInput = () => {
  const [t] = useTranslate();

  return (
    <>
      <Form.Item
        name="username"
        label={t("common:email")}
        validateTrigger="onBlur"
        rules={[
          {
            type: "email",
            message: t("validate:input-not-valid", undefined, {
              value: t("common:email"),
            }),
          },
          {
            required: true,
            message: t("validate:required", undefined, {
              value: t("common:email"),
            }),
          },
        ]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="old_password"
        label={t("common:old-password")}
        extra={t("authentication:password-help")}
        hasFeedback
        validateTrigger="onBlur"
        rules={[
          {
            required: true,
            message: t("validate:required", undefined, {
              value: t("common:old-password"),
            }),
          },
          {
            min: 8,
            message: t("validate:field-gte", undefined, { length: 8 }),
          },
        ]}
      >
        <Input.Password />
      </Form.Item>
      <Form.Item
        name="new_password"
        label={t("common:new-password")}
        dependencies={["password"]}
        hasFeedback
        validateTrigger="onBlur"
        rules={[
          {
            required: true,
            message: t("validate:required", undefined, {
              value: t("common:new-password"),
            }),
          },
        ]}
      >
        <Input.Password />
      </Form.Item>
    </>
  );
};

export default ChangePasswordInput;
