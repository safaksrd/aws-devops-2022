from flask import Flask, render_template


app = Flask(__name__) #degiskeni tanimladik

@app.route("/")
def head():
    return render_template("index.html", serdar = True) # True parametresini
                                                    # index.html dosyasina gonderirken serdar degiskenine atiyorum
# render_template icerisindeki atama html sayfasi icinde kullanilir.

@app.route("/for")
def for_example():
    names = ['Selcuk', 'Ihsan', 'Sedat', 'Ahmet']
    return render_template("deneme.html", isimler = names) # names parametresini
                                                    # deneme.html dosyasina gonderirken isimler degiskenine atiyorum
# render_template icerisindeki atama html sayfasi icinde kullanilir.



if __name__ == "__main__": 
    app.run(debug = True) 