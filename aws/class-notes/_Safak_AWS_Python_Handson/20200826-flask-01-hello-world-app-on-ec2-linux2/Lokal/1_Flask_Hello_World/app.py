# alttaki belgeyi olustur, 
# git add . ve git commit -m 'deneme' ve git push ile github repona gonder
# github repondan wget ile EC2 instance a cek, 
# run et ve ardindan connection to webpage


# Import Flask modules, kutuphaneden flaski cekiyoruz
from flask import Flask 

# Create an object named app , nesneyi olusturuyoruz
app = Flask(__name__)

# Decorators

# Create a function `hello` which returns a string `Hello World`, and
# Assign a URL route the `hello` function with decorator `@app.route('/')`.
@app.route("/") # kok dizine ulasilinca akttaki fonksiyon doner
def hello():
    return "Hello World-lokal denemeler"


@app.route("/second")
def second():
    return "This is second page"


@app.route("/third/subthird")
def third():
    return"This is subthird page"


# Dinamik ID yapilari
@app.route("/forth/<string:id>") 
def forth(id):
    return f"Id of this page is {id}"


# Enable the web application to be run in main, so that it can be reached from anywhere from port 80.
if __name__ == "__main__": # dogru yerde calisiyormuyuz diye kontrol ediyoruz. 
                            # app.py nin kendisinde calisip calismadigimizi kontrol ediyor.
    app.run(debug = True)               # lokalde debug modunda hazırladiktan sonra 80 portundan dis dunyaya yayinliyoruz.