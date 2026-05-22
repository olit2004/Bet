import 'dotenv/config';
import app from './app.js';

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT} in ${process.env.NODE_ENV || 'development'} mode`);
});

process.on('unhandledRejection', (err) => {
  console.error('Unhandled Promise Rejection:', err);
});

process.on('SIGTERM', () => {
  server.close(() => {
    console.log('HTTP server closed');
  });
});

process.on('SIGINT', () => {
  server.close(() => {
    console.log('HTTP server closed');
  });
});
