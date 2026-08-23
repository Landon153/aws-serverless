import { UploadFile } from "antd/lib/upload/interface";

export interface Book {
  id: string;
  name: string;
  author: string;
  image: string;
}

export interface BookCreate {
  id: string;
  name: string;
  author: string;
  upload: UploadFile[];
}
