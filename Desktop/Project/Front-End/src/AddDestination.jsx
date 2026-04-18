import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button, Container, Form, Alert } from "react-bootstrap";
import api from "./api";

export default function AddDestination() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    name: "",
    location: "",
    description: "",
    price: "",
    duration: "",
    image: "",
  });
  const [message, setMessage] = useState(null);

  const handleSave = async () => {
    try {
      await api.post("/destinations", {
        ...form,
        price: Number(form.price),
      });
      setMessage({ type: "success", text: "Destination added." });
      setTimeout(() => navigate("/"), 1000);
    } catch (error) {
      setMessage({ type: "danger", text: error?.response?.data?.error || "Save failed." });
    }
  };

  return (
    <Container className="py-4">
      {message && <Alert variant={message.type}>{message.text}</Alert>}
      <h2>Add Destination</h2>
      <Form>
        <Form.Group className="mb-2">
          <Form.Label>Name</Form.Label>
          <Form.Control value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Location</Form.Label>
          <Form.Control value={form.location} onChange={(e) => setForm({ ...form, location: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Description</Form.Label>
          <Form.Control
            as="textarea"
            rows={4}
            value={form.description}
            onChange={(e) => setForm({ ...form, description: e.target.value })}
          />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Price</Form.Label>
          <Form.Control value={form.price} onChange={(e) => setForm({ ...form, price: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-2">
          <Form.Label>Duration</Form.Label>
          <Form.Control value={form.duration} onChange={(e) => setForm({ ...form, duration: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Image URL</Form.Label>
          <Form.Control value={form.image} onChange={(e) => setForm({ ...form, image: e.target.value })} />
        </Form.Group>
        <Button variant="primary" onClick={handleSave}>
          Save Destination
        </Button>
      </Form>
    </Container>
  );
}
