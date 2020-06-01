import dotenv from 'dotenv';
dotenv.config();

export default {
  port: process.env.PORT || 9000,
  dbUser: process.env.DB_USER,
  dbPassword: process.env.DB_PASSWORD,
  authSaltRounds: 8,
  jwtSecret: process.env.JWT_SECRET,
}
