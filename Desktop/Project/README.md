# Tourism Booking Platform

A full-stack MERN application for booking travel destinations with user authentication, favorites, and admin features.

## Features

- **User Authentication**: Signup, login, email verification with secure password hashing
- **Destinations**: Browse and view travel destinations from database
- **Booking System**: Book trips with date selection and guest count
- **Favorites/Wishlist**: Save and manage favorite destinations
- **Dashboard**: View booked trips and saved favorites
- **Admin Panel**: Add new destinations (admin only)
- **Security**: Rate limiting, input sanitization, CORS, JWT tokens

## Tech Stack

- **Backend**: Node.js, Express, MongoDB, Mongoose
- **Frontend**: React, React Router, Bootstrap
- **Security**: bcrypt, JWT, express-validator, helmet, express-rate-limit

## Setup Instructions

### Prerequisites
- Node.js (v16+)
- MongoDB (local or cloud instance)
- Git

### Backend Setup
1. Navigate to Back-End directory:
   ```bash
   cd Back-End
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Update the following variables:
     ```
     MONGO_URI=mongodb://localhost:27017/travel-platform
     JWT_SECRET=your_secure_jwt_secret_here
     CLIENT_URL=http://localhost:5173
     ADMIN_CODE=your_admin_code
     PORT=5000
     ```

4. Start MongoDB service (if using local MongoDB)

5. Start the backend server:
   ```bash
   npm start
   ```

### Frontend Setup
1. Open a new terminal and navigate to Front-End directory:
   ```bash
   cd Front-End
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

### Usage

1. **Signup**: Create a new account with username, email, phone, and strong password
2. **Verify Email**: Check console for verification code and verify email
3. **Login**: Login with email/username/phone and password
4. **Browse Destinations**: View available travel destinations on home page
5. **Book Trip**: Select destination, choose dates and guest count
6. **Save Favorites**: Add destinations to favorites from detail page
7. **Dashboard**: View your bookings and favorites
8. **Admin Features**: Use admin code during signup to add destinations

## API Endpoints

### Authentication
- `POST /api/auth/signup` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/verify-email` - Email verification
- `GET /api/auth/verify-token` - Token verification

### Destinations
- `GET /api/destinations` - Get all destinations
- `GET /api/destinations/:id` - Get destination by ID
- `POST /api/destinations` - Add destination (admin only)

### Bookings
- `POST /api/bookings` - Create booking
- `GET /api/bookings/mine` - Get user bookings

### Favorites
- `GET /api/favorites` - Get user favorites
- `POST /api/favorites/:id` - Add to favorites
- `DELETE /api/favorites/:id` - Remove from favorites

### User
- `GET /api/user/dashboard` - Get user dashboard data

## Security Features

- Password hashing with bcrypt
- JWT token authentication
- Input validation and sanitization
- Rate limiting (120 requests per 15 minutes)
- CORS protection
- Helmet security headers
- Email verification required

## Project Structure

```
Project/
├── Back-End/
│   ├── models/          # MongoDB models
│   ├── routes/          # API routes
│   ├── middleware/      # Authentication middleware
│   ├── server.js        # Main server file
│   └── package.json
└── Front-End/
    ├── src/
    │   ├── components/  # Reusable components
    │   ├── pages/       # Page components
    │   ├── api.js       # API client
    │   └── App.jsx      # Main app component
    └── package.json
```

## Development

- Backend runs on `http://localhost:5000`
- Frontend runs on `http://localhost:5173`
- MongoDB connection required for data persistence

## Deployment

1. Build frontend: `npm run build` in Front-End directory
2. Deploy backend to server with MongoDB
3. Serve frontend static files or deploy to CDN
4. Update environment variables for production

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and test
4. Submit a pull request

## License

ISC License
</content>
<parameter name="filePath">c:\Users\user\Desktop\Project\README.md