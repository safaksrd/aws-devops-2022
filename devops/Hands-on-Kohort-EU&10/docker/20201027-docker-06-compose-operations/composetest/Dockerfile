FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 80
COPY . .
CMD ["flask", "run"]

# EXPOSE 80 neyin portu? host mu konteynir mi? 
# Bu degeri 80 de yapsam 5000 de yapsam lokalhost dan baglandim