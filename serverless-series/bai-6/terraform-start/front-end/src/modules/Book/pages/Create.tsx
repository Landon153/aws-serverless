import { Button, Card, Form, Input, Upload } from "antd";

import { BookCreate } from "@core/interfaces";
import { UploadOutlined } from "@ant-design/icons";
import { UploadRequestOption } from "rc-upload/lib/interface";
import bookApi from "@modules/Book/services/books";
import { useHistory } from "react-router";
import { useState } from "react";

interface Props {}

const MainPage = (props: Props) => {
  const [form] = Form.useForm();
  const history = useHistory();

  /* State */
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: BookCreate) => {
    setLoading(true);

    const { id, name, author, upload } = values;
    const file: any = upload[0];
    const formData = new FormData();
    formData.append("file", file.originFileObj);
    formData.append("id", id);
    formData.append("name", name);
    formData.append("author", author);

    try {
      await bookApi.create(formData);
      history.push("/");
    } catch (error) {
      console.log(error);
    }

    setLoading(false);
  };

  const customRequest = async (options: UploadRequestOption) => {
    const { file, onSuccess } = options;
    onSuccess!(file, options.file as unknown as XMLHttpRequest);
  };

  const normFile = (e: any) => {
    if (Array.isArray(e)) {
      return e;
    }
    return e && e.fileList;
  };

  return (
    <div className="container book">
      <Card>
        <Form form={form} onFinish={onFinish} layout="vertical">
          <Form.Item label="ID" name="id" required={true}>
            <Input />
          </Form.Item>
          <Form.Item label="Name" name="name" required={true}>
            <Input />
          </Form.Item>
          <Form.Item label="Author" name="author" required={true}>
            <Input />
          </Form.Item>
          <Form.Item
            label="File"
            name="upload"
            valuePropName="fileList"
            getValueFromEvent={normFile}
            required={true}
          >
            <Upload
              accept=".jpg, .jpeg, .png"
              customRequest={customRequest}
              maxCount={1}
            >
              <Button icon={<UploadOutlined />}>Click to Upload</Button>
            </Upload>
          </Form.Item>
          <Form.Item>
            <Button
              type="primary"
              htmlType="submit"
              loading={loading}
              block={true}
            >
              Create
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
};

export default MainPage;
