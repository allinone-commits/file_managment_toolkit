import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Button, Container, Form, Alert } from "react-bootstrap";
import api from "./api";

export default function Login({ onLogin }) {
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const response = await api.post("/auth/login", { identifier, password });
      localStorage.setItem("token", response.data.token);
      onLogin(response.data.user);
      navigate("/dashboard");
    } catch (err) {
      setError(err?.response?.data?.error || "Login failed.");
    }
  };

  return (
    <Container className="py-4" style={{ maxWidth: 420 }}>
      <h2>Login</h2>
      {error && <Alert variant="danger">{error}</Alert>}
      <Form>
        <Form.Group className="mb-3">
          <Form.Label>Email, username, or phone</Form.Label>
          <Form.Control value={identifier} onChange={(e) => setIdentifier(e.target.value)} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Password</Form.Label>
          <Form.Control type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        </Form.Group>
        <Button onClick={handleLogin}>Login</Button>
      </Form>
      <div className="mt-3">
        New user? <Link to="/signup">Create account</Link>
      </div>
    </Container>
  );
}
