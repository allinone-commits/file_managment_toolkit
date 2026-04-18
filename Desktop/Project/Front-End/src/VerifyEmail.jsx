import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button, Container, Form, Alert } from "react-bootstrap";
import api from "./api";

export default function VerifyEmail() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [message, setMessage] = useState(null);

  const handleVerify = async () => {
    try {
      await api.post("/auth/verify-email", { email, code });
      setMessage({ type: "success", text: "Email verified. You can login now." });
      setTimeout(() => navigate("/login"), 1000);
    } catch (error) {
      setMessage({ type: "danger", text: error?.response?.data?.error || "Verification failed." });
    }
  };

  return (
    <Container className="py-4">
      {message && <Alert variant={message.type}>{message.text}</Alert>}
      <h2>Verify Email</h2>
      <Form>
        <Form.Group className="mb-2">
          <Form.Label>Email</Form.Label>
          <Form.Control value={email} onChange={(e) => setEmail(e.target.value)} />
        </Form.Group>
        <Form.Group className="mb-3">
          <Form.Label>Verification Code</Form.Label>
          <Form.Control value={code} onChange={(e) => setCode(e.target.value)} />
        </Form.Group>
        <Button onClick={handleVerify}>Verify Email</Button>
      </Form>
    </Container>
  );
}
