import { Routes, Route, Navigate, Link, useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";
import { Container, Navbar, Nav, Button, Spinner } from "react-bootstrap";
import api from "./api";
import Login from "./Login.jsx";
import Signup from "./signup.jsx";
import Dashboard from "./Dashboard.jsx";
import Home from "./Home.jsx";
import DestinationDetail from "./DestinationDetail.jsx";
import AddDestination from "./AddDestination.jsx";
import ProtectedRoute from "./components/ProtectedRoute.jsx";

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const verifySession = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setLoading(false);
        return;
      }
      try {
        const response = await api.get("/auth/verify-token");
        setUser(response.data.user);
      } catch (error) {
        localStorage.removeItem("token");
        setUser(null);
      } finally {
        setLoading(false);
      }
    };
    verifySession();
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("token");
    setUser(null);
    navigate("/login");
  };

  if (loading) {
    return (
      <Container className="py-5 text-center">
        <Spinner animation="border" />
      </Container>
    );
  }

  return (
    <>
      <Navbar bg="dark" variant="dark" expand="lg">
        <Container>
          <Navbar.Brand as={Link} to="/">
            Travel Booking
          </Navbar.Brand>
          <Navbar.Toggle />
          <Navbar.Collapse>
            <Nav className="me-auto">
              <Nav.Link as={Link} to="/">
                Home
              </Nav.Link>
              {user && (
                <Nav.Link as={Link} to="/dashboard">
                  Dashboard
                </Nav.Link>
              )}
              {user?.isAdmin && (
                <Nav.Link as={Link} to="/add-destination">
                  Add Destination
                </Nav.Link>
              )}
            </Nav>
            <Nav>
              {user ? (
                <>
                  <Navbar.Text className="me-3">Hello, {user.username}</Navbar.Text>
                  <Button variant="outline-light" size="sm" onClick={handleLogout}>
                    Logout
                  </Button>
                </>
              ) : (
                <>
                  <Nav.Link as={Link} to="/login">
                    Login
                  </Nav.Link>
                  <Nav.Link as={Link} to="/signup">
                    Signup
                  </Nav.Link>
                </>
              )}
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      <Routes>
        <Route path="/" element={<Home user={user} />} />
        <Route
          path="/login"
          element={user ? <Navigate to="/dashboard" /> : <Login onLogin={setUser} />}
        />
        <Route
          path="/signup"
          element={user ? <Navigate to="/dashboard" /> : <Signup />}
        />
        <Route path="/destinations/:id" element={<DestinationDetail user={user} />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute user={user}>
              <Dashboard user={user} />
            </ProtectedRoute>
          }
        />
        <Route
          path="/add-destination"
          element={
            <ProtectedRoute user={user}>
              {user?.isAdmin ? <AddDestination /> : <Navigate to="/dashboard" />}
            </ProtectedRoute>
          }
        />
      </Routes>
    </>
  );
}

export default App;