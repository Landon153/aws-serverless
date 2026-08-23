import BaseService from "@core/class/BaseService";
import { Book } from "@core/interfaces";

class BookService extends BaseService {
  public list = (): Promise<Book[]> => {
    return this.get("");
  };
}

export default new BookService("/books", false);
