# Template for Machine Learning projects

## Run locally on Windows

Install dependencies:

`pip install -r src/requirements.txt`

Run Flask directly:

`python src/app.py`

Or run with Waitress:

`python -m waitress --listen=0.0.0.0:5000 app:app`

## Run on Render (Linux)

Use Gunicorn as start command:

`gunicorn src.app:app`
