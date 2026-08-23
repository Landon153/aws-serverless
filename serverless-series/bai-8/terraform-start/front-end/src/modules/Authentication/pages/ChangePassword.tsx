interface Props {}

import { Button, Col, Form, Row, Typography, message } from "antd";
import { useContext, useState } from "react";

import Auth from "@utils/helpers/auth";
import ChangePasswordInput from "@root/modules/Authentication/components/ChangePasswordInput";
import ResourceContext from "@utils/contexts/Resource";
import { ValuesChangePasswordForm } from "@modules/Authentication/interfaces";
import authApi from "@modules/Authentication/services/auth";
import { useHistory } from "react-router-dom";
import useTranslate from "@core/hooks/useTranslate";

const { Title } = Typography;

const ChangePassword = (props: Props) => {
  const [t] = useTranslate();
  const [form] = Form.useForm();
  const history = useHistory();
  const { setResourceContext } = useContext(ResourceContext);

  /* State */
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: ValuesChangePasswordForm) => {
    setLoading(true);

    try {
      const { AuthenticationResult: { AccessToken } } = await authApi.changePassword(values);

      Auth.setToken(AccessToken);
      setResourceContext().then(() => {
        message.success("Change password success");
        history.push("/");
      });
    } catch (error: any) {
      const { response } = error;

      if (response && response.data) {
        const { data } = response.data;

        if (!Array.isArray(data)) {
          message.error(data);
        }
      }
    }

    setLoading(false);
  };

  return (
    <div className="container">
      <Title level={3}>{t("authentication:join-the-membership")}</Title>
      <div className="signup">
        <Form layout="vertical" form={form} name="register" onFinish={onFinish}>
          <Row gutter={32}>
            <Col lg={12} offset={6}>
              <ChangePasswordInput />
              <Button
                htmlType="submit"
                style={{ marginTop: 20 }}
                type="primary"
                block={true}
                loading={loading}
              >
                {t("common:save")}
              </Button>
            </Col>
          </Row>
        </Form>
      </div>
    </div>
  );
};

export default ChangePassword;
