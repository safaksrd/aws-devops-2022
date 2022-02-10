# Import Flask modules
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy

# Create an object named app
app = Flask(__name__) # Burada object olarak tanimlanan app asagida SQLAlcemy ile birlesiyor

# Configure sqlite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./email.db' # burada olusturulan ne varsa email.db ye yaz. baslangicta email.db yok, program calistirilinca otomatik olusturacak. Bulundugum directory i . ile ifade ediyoruz.
app.config['SQLALCHEMY_TRACK_MODIFICATIONS']= False # Tüm modifikasyonlari takip ediyor, bize lazim degil. False dedik
db = SQLAlchemy(app) # SQLAlcemy ile app i birlestiriyoruz. Python tarafi ile SQLAlchemy tarafi birlesiyor. app icindeki degisiklikleri db ye atiyor

# Execute the code below only once. 
# Write sql code for initializing users table. 
# Bu kod bir defa calistirilacak, cünkü her calistirildiginda sistem resetleniyor. SQL query lerini python kodunun icine gömüyoruz. 
# Ilk once mevcut tablolari siliyoruz, sonra yeni tablo yaratiyoruz, tablonun sütunlarini belirliyoruz
# ilk kolon username, ikinci kolon email, sonra bu tabloya data kaydediyoruz

drop_table= """
DROP TABLE IF EXISTS users;
"""
users_table = """    
CREATE TABLE users(
username VARCHAR NOT NULL PRIMARY KEY, 
email VARCHAR);
"""
data = """
INSERT INTO users
VALUES
    ("Levent Akyuz", "levent.akyuz@gmail.com"),
    ("Abdullah Kanat", "abdullah.kanat@yahoo.com"),
    ("Hakan Sule", "hakan.sule@clarusway.com");
"""

# yukaridaki degisiklikleri SQLite cevrime soksun diye alttaki komutlar calistirilir.
db.session.execute(drop_table) # yukarida calisan statement ler cevrime sokuluyor. drop_table ile mevcut user varsa siliniyor
db.session.execute(users_table) # users_table ile users isimli 2 sütunlu tablo yaratiyoruz
db.session.execute(data) # data ile yeni olusturulan users isimli tabloya veri giriyoruz.
db.session.commit()

# Write a function named `find_emails` which find emails using keyword from the users table in the db,
# and returns result as tuples `(name, email)`.

# keyword un sag ve solundaki % isaretleri sayesinde Hakan yerine aka bile yazsak Hakan i bulur. 
# asagidaki query, tablodan icerisinde keyword u barindiran username i buluyor ve bunu query e atiyor
def find_emails(keyword):
    query=f"""
    SELECT * FROM users WHERE username like '%{keyword}%'; 
    """
    result = db.session.execute(query) # query i execute ederek result isimli bir variable haline getiriyoruz. 
                                       # bu variable icerisinde iki row barindiran (username, email) bir list olarak geri dönecek. 
                                       # Bu listi asagida parcalara ayiracagiz
    user_emails = [(row[0], row[1]) for row in result] # Username:row[0] Email:row[1] parcalarini ayirdik
    if not any(user_emails):           # eger girilen keyword tabloda yoksa Username:Not Found , Email:Not Found yazacak
        user_emails = [('Not Found', 'Not Found')]
    return user_emails                 # keyword bulunmussa ornegin Username:Levent Akyuz Email:levent.akyuz@gmail.com olarak ekrana yazacak

# Write a function named `insert_email` which adds new email to users table the db.
# Database icine yeni Username ve Email atmamizi saglayacak

def insert_email(name, email): # kullanicidan iki deger alinacak, ve database e kaydedip added successfully donecek. Varolan bir username ve email girersek already exist dönecek
    query = f"""
    SELECT * FROM users WHERE username LIKE '{name}';
    """
    result = db.session.execute(query) # query i execute ederek result isimli bir variable haline getiriyoruz. 
    if name == None or email == None: # Kullanici bos giris yapabilir ihtimaline karsi asagidaki onlem alinir. name yada mail girilmemis ise bos olamaz diyecek
        response = 'Username or email can not be empty'
    elif not any(result):       # girilen name-email ikilisi database de yoksa users tablosuna eklenecek
        insert = f"""
        INSERT INTO users 
        VALUES ('{name}', '{email}');
        """
        result = db.session.execute(insert)
        db.session.commit()
        response =f'User {name} added successfully'
    else:                       # girilen name-email ikilisi database de varsa already exist dönecek
        response = f'User {name} already exist.' # girilen name-email ikilisi database de zaten varsa bu uyari gelecek
    return response 

# Write a function named `emails` which finds email addresses by keyword using `GET` and `POST` methods,
# using template files named `emails.html` given under `templates` folder
# and assign to the static route of ('/')

# simdi decoratorleri ayalayalim
# ilk olarak kok dizine yapilan talepleri ayarlayalim
# find_emails function icin keyword lazimdi. 
# HTML sayfasindan request edilen username -> user_name e ataniyor. Bunu keyword olarak kullaniyoruz.
# Girilen user_name veritabaninda var ise function calisiyor ve user_emails i buluyor
@app.route('/', methods =['GET','POST'])        # kök root a gelen bir istek metot GET yada POST olabilir
def emails():
    if request.method == 'POST':                # metot POST ise yani kaydedilecek bir durum varsa bu donguye girer
        user_name = request.form['username']    # HTML sayfasina girilen username i oradan request eder aliriz ve bunu program icindeki user_name e atar
        user_emails = find_emails(user_name)    # yukariki satirda elde edilen user_name i degisken olarak find_emails fonksiyonuna sokar, email ini buluruz.
        return render_template('emails.html', name_emails=user_emails, keyword=user_name, show_result=True) # Elde edilen user_emails -> emails.html deki name_emails degiskenine, user_name -> emails.html deki keyword degiskenine geri gondeririz. show_result=True demek kutucuga birseyler girdik ve SHOW butonuna bastik anlamina geliyor.
    else: 
        return render_template('emails.html', show_result = False)  # metot GET ise yani sayfaya ilk tiklandiginda default olarak show_result=False dur dolayisiyla emails.html sayfasindaki -> if show_result dongusune girmeyecek, yani kutucuga birseyler girmedik ve SHOW butonuna basmadik anlamina geliyor.

# Write a function named `add_email` which inserts new email to the database using `GET` and `POST` methods,
# using template files named `add-email.html` given under `templates` folder
# and assign to the static route of ('add')

# ikinci olarak /add dizinine yapilan talepleri ayarlayalim
# girilen name-email ikilisi database de yoksa insert_email function calisiyor ve yeni bilgiyi database ekliyor
@app.route('/add', methods =['GET','POST'])
def add_email():
    if request.method == 'POST':                # metot POST ise yani kaydedilecek bir durum varsa bu donguye girer
        user_name =request.form['username']     # HTML sayfasina girilen username i oradan request eder aliriz ve bunu program icindeki user_name e atar
        user_email = request.form['useremail']  # HTML sayfasina girilen useremail i oradan request eder aliriz ve bunu program icindeki user_email e atar
        result = insert_email(user_name, user_email) # yukariki satirda elde edilen user_name ve user_email i degisken olarak insert_email fonksiyonuna sokar, fonksiyon sonucunu result a atariz
        return render_template('add-email.html', result_html=result, show_result=True) # Elde edilen result -> add-email.html deki result_html degiskenine gondeririz.                                                                            # showresult=True ise yeni bir kayit girdigimiz anlamina gelir ve "successfully added" donecek
    else:   

        return render_template('add-email.html', show_result=False)     # Kullanicidan degerleri aldigin sayfada showresult=False ise varolan bir kayit girildigi anlamina gelir ve  "already exist" donecek.        

# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ =='__main__':
    app.run(debug=True)
    #app.run(host='0.0.0.0', port=80)