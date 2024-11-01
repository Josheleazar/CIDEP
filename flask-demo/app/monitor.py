from flask import Flask, jsonify, request
from prometheus_flask_exporter import PrometheusMetrics
import time
import psutil  # For system utilization metrics

from app import app

# Initialize Prometheus metrics for the Flask app
metrics = PrometheusMetrics(app)

# Track request latency for all endpoints
metrics.register_default(
    metrics.counter(
        'app_request_operations_total', 'Total number of requests for the application',
        labels={'status': lambda resp: resp.status_code}
    )
)

# Track latency for each endpoint
endpoint_latency = metrics.histogram(
    'app_request_latency_seconds', 'Latency of HTTP requests for each endpoint',
    labels={'endpoint': lambda: request.path}
)

# Custom error counter
error_counter = metrics.counter(
    'app_errors_total', 'Total number of errors for the application',
    labels={'error': lambda: getattr(request, 'error', None)}
)

# Track request traffic (requests per second)
request_traffic = metrics.counter(
    'app_request_traffic_total', 'Total request traffic in bytes',
    labels={'method': lambda: request.method}
)

# Function to capture CPU and memory utilization
@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    latency = time.time() - request.start_time
    endpoint_latency.labels(endpoint=request.path).observe(latency)
    
    # Track traffic (in bytes) per request
    request_traffic.labels(method=request.method).inc(len(response.data))

    # Log errors if status code >= 400
    if response.status_code >= 400:
        error_counter.labels(error=response.status_code).inc()

    return response

# Health check route for readiness/liveness probes
@app.route('/healthz')
def health():
    return jsonify(status="Healthy")

# Custom metrics endpoint for CPU and memory utilization
@app.route('/metrics')
def utilization_metrics():
    cpu_usage = psutil.cpu_percent()
    memory_info = psutil.virtual_memory()
    return jsonify(
        cpu_usage=cpu_usage,
        memory_used=memory_info.used,
        memory_available=memory_info.available,
        memory_percent=memory_info.percent
    )


