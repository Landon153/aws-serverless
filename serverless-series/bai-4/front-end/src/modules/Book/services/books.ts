import BaseService from "@core/class/BaseService";
import { Book } from "@core/interfaces";

class BookService extends BaseService {
  public create = (data: FormData): Promise<Book> => {
    return this.post("", data, {
      headers: { "Content-Type": "multipart/form-data" },
    });
  };
}

export default new BookService("/books", false);
