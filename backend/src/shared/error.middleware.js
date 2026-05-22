function errorMiddleware(err, req, res, next) {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  console.error('[ERROR]', {
    message: err.message,
    stack: err.stack,
    statusCode
  });

  res.status(statusCode).json({
    status: statusCode >= 500 ? 'error' : 'fail',
    success: false,
    message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
}

export default errorMiddleware;
