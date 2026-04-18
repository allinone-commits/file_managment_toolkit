import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { Button, Card, Col, Container, ListGroup, Row, Spinner } from "react-bootstrap";
import api from "./api";

export default function Dashboard({ user }) {
  const [dashboard, setDashboard] = useState({ user: null, bookings: [] });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadDashboard = async () => {
      try {
        const response = await api.get("/user/dashboard");
        setDashboard(response.data);
      } catch (error) {
        setDashboard({ user, bookings: [] });
      } finally {
        setLoading(false);
      }
    };
    loadDashboard();
  }, [user]);

  if (loading) {
    return (
      <Container className="py-5 text-center">
        <Spinner animation="border" />
      </Container>
    );
  }

  return (
    <Container className="py-4">
      <div className="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h1>Dashboard</h1>
          <p>Welcome back, {dashboard.user?.username || user?.username}.</p>
        </div>
        <Button as={Link} to="/">Browse Destinations</Button>
      </div>
      <Row className="g-4">
        <Col lg={6}>
          <Card>
            <Card.Body>
              <Card.Title>My Trips</Card.Title>
              <ListGroup variant="flush">
                {dashboard.bookings.length > 0 ? (
                  dashboard.bookings.map((booking) => (
                    <ListGroup.Item key={booking._id}>
                      <strong>{booking.destination.name}</strong> | {new Date(booking.startDate).toLocaleDateString()} - {new Date(booking.endDate).toLocaleDateString()} | Guests: {booking.guests}
                    </ListGroup.Item>
                  ))
                ) : (
                  <ListGroup.Item>No booked trips yet.</ListGroup.Item>
                )}
              </ListGroup>
            </Card.Body>
          </Card>
        </Col>
        <Col lg={6}>
          <Card>
            <Card.Body>
              <Card.Title>Saved Favorites</Card.Title>
              <ListGroup variant="flush">
                {dashboard.user?.favorites?.length > 0 ? (
                  dashboard.user.favorites.map((item) => (
                    <ListGroup.Item key={item._id}>
                      <Link to={`/destinations/${item._id}`}>{item.name}</Link>
                      <div className="text-muted">{item.location}</div>
                    </ListGroup.Item>
                  ))
                ) : (
                  <ListGroup.Item>No favorites saved.</ListGroup.Item>
                )}
              </ListGroup>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
}
