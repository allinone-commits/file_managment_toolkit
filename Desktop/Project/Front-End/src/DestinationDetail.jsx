import { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { Alert, Button, Card, Col, Container, Form, Row, Spinner } from "react-bootstrap";
import api from "./api";

export default function DestinationDetail({ user }) {
  const { id } = useParams();
  const navigate = useNavigate();
  const [destination, setDestination] = useState(null);
  const [form, setForm] = useState({ startDate: "", endDate: "", guests: 1 });
  const [message, setMessage] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadDestination = async () => {
      try {
        const response = await api.get(`/destinations/${id}`);
        setDestination(response.data);
      } catch (error) {
        setMessage({ type: "danger", text: "Could not load destination." });
      } finally {
        setLoading(false);
      }
    };
    loadDestination();
  }, [id]);

  const handleBook = async () => {
    if (!user) {
      navigate("/login");
      return;
    }
    try {
      await api.post("/bookings", { destinationId: id, ...form });
      setMessage({ type: "success", text: "Booking saved in your dashboard." });
    } catch (error) {
      setMessage({ type: "danger", text: error?.response?.data?.error || "Booking failed." });
    }
  };

  const handleFavorite = async () => {
    if (!user) {
      navigate("/login");
      return;
    }
    try {
      await api.post(`/favorites/${id}`);
      setMessage({ type: "success", text: "Added to favorites." });
    } catch (error) {
      setMessage({ type: "danger", text: "Could not save favorite." });
    }
  };

  if (loading) {
    return (
      <Container className="py-4 text-center">
        <Spinner animation="border" />
      </Container>
    );
  }

  if (!destination) {
    return (
      <Container className="py-4">
        <Alert variant="danger">Destination not found</Alert>
      </Container>
    );
  }

  return (
    <Container className="py-4">
      {message && <Alert variant={message.type}>{message.text}</Alert>}
      <Row>
        <Col lg={7}>
          <Card>
            <Card.Img variant="top" src={destination.image} alt={destination.name} />
            <Card.Body>
              <Card.Title>{destination.name}</Card.Title>
              <Card.Subtitle className="mb-2 text-muted">
                {destination.location}
              </Card.Subtitle>
              <Card.Text>{destination.description}</Card.Text>
              <Card.Text>
                <strong>Price:</strong> ${destination.price}
              </Card.Text>
              <Card.Text>
                <strong>Duration:</strong> {destination.duration}
              </Card.Text>
              <Button variant="primary" onClick={handleFavorite}>
                Save Favorite
              </Button>
            </Card.Body>
          </Card>
        </Col>
        <Col lg={5}>
          <Card className="mt-3 mt-lg-0">
            <Card.Body>
              <Card.Title>Book this trip</Card.Title>
              <Form>
                <Form.Group className="mb-2">
                  <Form.Label>Start Date</Form.Label>
                  <Form.Control
                    type="date"
                    value={form.startDate}
                    onChange={(e) => setForm({ ...form, startDate: e.target.value })}
                  />
                </Form.Group>
                <Form.Group className="mb-2">
                  <Form.Label>End Date</Form.Label>
                  <Form.Control
                    type="date"
                    value={form.endDate}
                    onChange={(e) => setForm({ ...form, endDate: e.target.value })}
                  />
                </Form.Group>
                <Form.Group className="mb-3">
                  <Form.Label>Guests</Form.Label>
                  <Form.Control
                    type="number"
                    min="1"
                    value={form.guests}
                    onChange={(e) => setForm({ ...form, guests: Number(e.target.value) })}
                  />
                </Form.Group>
                <Button variant="success" onClick={handleBook}>
                  Book Trip
                </Button>
              </Form>
            </Card.Body>
          </Card>
        </Col>
      </Row>
      <Link className="btn btn-link mt-3" to="/">
        Back to list
      </Link>
    </Container>
  );
}
