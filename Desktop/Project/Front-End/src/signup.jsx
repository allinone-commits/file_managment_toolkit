import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button, Container, Form, Alert } from "react-bootstrap";
import api from "./api";

export default function Signup() {
  const [form, setForm] = useState({ username: "", email: "", phone: "", password: "", adminCode: "" });
  const [message, setMessage] = useState(null);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleSignup = async () => {
    try {
      const response = await api.post("/auth/signup", form);
      setMessage(response.data.message);
      setError(null);
      setTimeout(() => navigate("/verify-email"), 1200);
    } catch (err) {
      setError(err?.response?.data?.error || "Signup failed.");
      setMessage(null);
    }
  };

  return (
    <Container className="py-4" style={{ maxWidth: 520 }}>
      <h2>Create Account</h2>
      {message && <Alert variant="success">{message}</Alert>}
      {error && <Alert variant="danger">{error}</Alert>}
      <Form>
        <Form.Group className="mb-3">
          <Form.Label>Username</Form.Label>
          <Form.Control value={form.username} onChange={(e) => setForm({ ...form, username: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Email</Form.Label>
          <Form.Control value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Phone</Form.Label>
          <Form.Control value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Password</Form.Label>
          <Form.Control type="password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Admin Code (optional)</Form.Label>
          <Form.Control value={form.adminCode} onChange={(e) => setForm({ ...form, adminCode: e.target.value })} />
        </Form.Group>
        <Button onClick={handleSignup}>Sign up</Button>
      </Form>
    </Container>
  );
}
