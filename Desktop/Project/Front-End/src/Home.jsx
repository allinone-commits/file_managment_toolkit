import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { Button, Card, Col, Container, Row, Spinner } from "react-bootstrap";
import api from "./api";

export default function Home({ user }) {
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadDestinations = async () => {
      try {
        const response = await api.get("/destinations");
        setDestinations(response.data);
      } catch (error) {
        setDestinations([]);
      } finally {
        setLoading(false);
      }
    };
    loadDestinations();
  }, []);

  return (
    <Container className="py-4">
      <div className="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h1>Explore Travel Destinations</h1>
          <p>Browse trips, book your stay, and save favorites.</p>
        </div>
        <div>
          {user ? (
            <Button as={Link} to="/dashboard" variant="primary">
              Go to Dashboard
            </Button>
          ) : (
            <Button as={Link} to="/login" variant="outline-primary">
              Login to Book
            </Button>
          )}
        </div>
      </div>
      {loading ? (
        <div className="text-center py-5">
          <Spinner animation="border" />
        </div>
      ) : (
        <Row xs={1} md={2} lg={3} className="g-4">
          {destinations.map((item) => (
            <Col key={item._id}>
              <Card>
                <Card.Img variant="top" src={item.image} />
                <Card.Body>
                  <Card.Title>{item.name}</Card.Title>
                  <Card.Subtitle className="mb-2 text-muted">{item.location}</Card.Subtitle>
                  <Card.Text>{item.description.slice(0, 100)}...</Card.Text>
                  <div className="d-flex justify-content-between align-items-center">
                    <span>${item.price}</span>
                    <Button as={Link} to={`/destinations/${item._id}`} variant="primary" size="sm">
                      View
                    </Button>
                  </div>
                </Card.Body>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </Container>
  );
}
