from flask import Flask, render_template, request

app = Flask(__name__)

def convert(decimal_num): # ornegin decimal_num 3999 girelim
    roman = {1000:'M', 900:'CM', 500:'D', 400:'CD', 100:'C', 90:'XC', 50:'L', 40:'XL', 10:'X', 9:'IX', 5:'V', 4:'IV', 1:'I'}
    num_to_roman = ''
    for i in roman.keys():
        num_to_roman += roman[i]*(decimal_num//i) # decimal_num u i ye bölecek. i roman listesinin keys degerleridir. 
                                                # listeler key, value yapisindaydi. Dolayisiyla i aslinda 1000, 9000 vs sayilardir.
                                                # döngüye girdi ve 3999 u 1000 e böldü. Bölüm 3. Buldugu sonucu roman[i] ile carpar. 
                                                # Kalan 999, bunu decimal_num %= i ile decimal_nun a tekrar atadik. Dongu bu sekilde devam eder.
                                                # roman[i] listenin value degerleridir, yani 1000 icin M, 900 icin CM vs. dolayisiyla 3 tane M koyar.
                                                # Elde kalan 999. Bunu 900 e bölünce, 1 tane CM gelir, 
                                                # Elde kalan 99. Bunu 90 e bölünce, 1 tane XC gelir, 
                                                # Elde kalan 9. Bunu 9 e bölünce, 1 tane IX gelir, 
                                                # Hepsini yanyana num_to_roman stringine yazinca MMMCMXCIX olusur.
        decimal_num %= i                        # decimal_num un i ye bölündügünde kalani decimal_num a atadim.
    return num_to_roman



@app.route('/', methods=['GET']) # Root da GET metodu ile ilk talep edildiginde not_valid=False oldugu icin "Please enter a number between 1 and 3999, inclusively." mesaji gelmeyecek. not_valid=False girilmese de default olarak false dur.
def main_get():
    return render_template('index.html', developer_name='Safak', not_valid=False) # index.html den beklenen developer_name degiskenini gonderiyoruz.

@app.route('/', methods=['POST']) # Root da POST metodu ile veri girisi olursa asagidakiler gerceklesir
def main_post():
    alpha = request.form['number'] # index.html sayfasinda girilen number degiskenini alpha degiskenine atadi ve flaskin icinde kullaniyor
    if not alpha.isdecimal(): # hepsi rakamsa alpha.isdecimal True gelir. not True = False olur, alttaki ifade gelmez. hepsi rakam degilse alpha.decimal False gelir. not False=True olur, alttaki ifade gelir.
        return render_template('index.html', developer_name='Safak', not_valid=True) # not_valid=True olunca "Please enter a number between 1 and 3999, inclusively. mesaji cikacak

    number = int(alpha) # alpha degiskenini integer a cevirip number degiskenine atadi
    
    if not 0 < number < 4000: # girilen rakam 1 ile 3999 arasinda degilse alttaki mesaj doner.
        return render_template('index.html', developer_name='Safak', not_valid=True) # not_valid=True olunca "Please enter a number between 1 and 3999, inclusively." mesaji cikacak
    
    # yukaridaki sartlar saglanmazsa asagidakini donecek.
    #
    return render_template('result.html', number_decimal = number , number_roman= convert(number), developer_name='Safak') # result.html sayfasinin bizden beklediklerini gonderiyoruz.

if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=80)







