from fastapi import FastAPI
import socket

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "version": "v1",
        "hostname": socket.gethostname()
    }

@app.get("/health")
def health():
    return {
        "status": "ok"
    }