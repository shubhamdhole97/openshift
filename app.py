from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def home():
    return "Shubham Dhole is heree 👋", 200

@app.get("/health")
def health():
    return jsonify(status="ok"), 200

if __name__ == "__main__":
    # For local testing only; OpenShift will use gunicorn via the Dockerfile CMD
    import os
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 8080)))
