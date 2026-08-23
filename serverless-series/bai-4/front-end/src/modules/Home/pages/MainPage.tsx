import { Avatar, Card, Col, Row } from "antd";
import { useEffect, useState } from "react";

import { Book } from "@core/interfaces";
import bookApi from "@modules/Home/services/books";

const { Meta } = Card;

interface Props {}

const MainPage = (props: Props) => {
  /* State */
  const [books, setBooks] = useState<Book[]>([]);

  useEffect(() => {
    bookApi.list().then((res) => {
      setBooks(res);
    });
  }, []);

  return (
    <div className="container home">
      <Row className="books" gutter={16}>
        {books.map((book) => (
          <Col key={book.id} lg={6}>
            <Card
              hoverable
              style={{ width: "100%" }}
              cover={
                <Avatar
                  shape="square"
                  alt={book.name}
                  src={book.image}
                />
              }
            >
              <Meta
                title={book.name}
                description={book.author}
              />
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default MainPage;
