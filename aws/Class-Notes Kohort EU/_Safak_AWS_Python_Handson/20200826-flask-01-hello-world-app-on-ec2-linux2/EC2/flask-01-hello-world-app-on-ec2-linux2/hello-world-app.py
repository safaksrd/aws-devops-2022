from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Das ist mein erste Webseite auf EC2 Instance. LG Safak'

if __name__=="__main__":
   app.run(host='0.0.0.0', port=80) # herhangi bir adresten 80 portundan gelen istegi calistirir 