from flask import Flask, render_template, request

app = Flask(__name__)


def convert(millisecond):
    hour_in_millisecond = 60*60*1000                        # 1 saat = 60 dakika * 60 saniye * 1000 milisaniye
    hours = millisecond // hour_in_millisecond              # milisaniye cinsinden girilen milisecond degiskeninde ne kadar saat oldugunu buluruz
    millisecond_left = millisecond % hour_in_millisecond    # bölümden kalani baska bir degiskene atiyoruz

    minute_in_millisecond = 60*1000                         # 1 dakika = 60 saniye * 1000 milisaniye
    minutes = millisecond_left // minute_in_millisecond     # milisaniye cinsinden girilen milisecond degiskeninde ne kadar dakika oldugunu buluruz
    millisecond_left %= minute_in_millisecond               # bölümden kalani baska bir degiskene atiyoruz

    seconds = millisecond_left // 1000                      # milisaniye cinsinden girilen milisecond degiskeninde ne kadar saniye oldugunu buluruz

    return f'{hours} hour/s '*(hours!=0) + f'{minutes} minute/s '*(minutes!=0) + f'{seconds} second/s '*(seconds!=0) or f'just {millisecond} millisecond/s' # or koymamizin sebebi girdigimiz degiskende saat, dakika ve saniye yoksa milisaniye cinsinden sonucu verecek

@app.route('/', methods=['GET']) # Root da GET metodu ile ilk talep edildiginde not_valid=False oldugu icin "Please enter a number greater than zero." mesaji gelmeyecek. not_valid=False girilmese de default olarak false dur.
def main_get():
        return render_template('index.html', developer_name ='Safak', not_valid = False) # index.html den beklenen developer_name degiskenini gonderiyoruz.

@app.route('/', methods=['POST'])
def main_post():
    alpha = request.form['number'] # index.html sayfasinda girilen number degiskenini alpha degiskenine atadi ve flaskin icinde kullaniyor
    if not alpha.isdecimal(): # hepsi rakamsa alpha.isdecimal True gelir. not True = False olur, alttaki ifade gelmez. hepsi rakam degilse alpha.isdecimal False gelir. not False=True olur, alttaki ifade gelir.
        return render_template('index.html', developer_name = 'Safak', not_valid = True) # not_valid=True olunca "Please enter a number greater than zero." mesaji cikacak
    if not (0 < int(alpha)): # girilen rakam 0 dan büyükse not True = False olur, alttaki ifade gelir.
        return render_template('index.html', developer_name = 'Safak', not_valid = True) # not_valid=True olunca "Please enter a number greater than zero." mesaji cikacak
    
    # yukaridaki sartlar saglanmazsa asagidakini donecek.
    return render_template('result.html', developer_name=' Safak', milliseconds = alpha, result = convert(int(alpha))) # result.html sayfasinin bizden beklediklerini gonderiyoruz. result.html de miliseconds olarak beklenen degere alpha yi, result olarak beklenen degere ise alpha nin convert fonksiyonundan elde edilen cevabini gondeririz.

if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=80)