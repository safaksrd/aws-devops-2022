# Import Flask modules
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy

# Create an object named app
app = Flask(__name__) # Burada object olarak tanimlanan app asagida SQLAlcemy ile birlesiyor

# Configure sqlite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./email.db' # burada olusturulan ne varsa email.db ye yaz. baslangicta email.db yok, program calistirilinca otomatik olusturacak. Bulundugum directory i . ile ifade ediyoruz.
app.config['SQLALCHEMY_TRACK_MODIFICATIONS']= False # Tüm modifikasyonlari takip ediyor, bize lazim degil. False dedik
db = SQLAlchemy(app) # SQLAlcemy ile app i birlestiriyoruz. Python tarafi ile SQLAlchemy tarafi birlesiyor. app icindeki degisiklikleri db ye atiyor

# Execute the code below only once. Bu kod bir defa calistirilacak, cünkü her calistirildiginda sistem resetleniyor
# Write sql code for initializing users table. SQL query lerini python kodunun icine gömüyoruz. 
# Ilk once mevcut tablolari siliyoruz, sonra yeni tablo yaratiyoruz, tablonun sütunlarini belirliyoruz
# ilk kolon username, ikinci kolon email

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
    ("Ahmet Kanat", "ahmet.kanat@yahoo.com"),
    ("Hakan Sule", "hakan.sule@clarusway.com");
"""
db.session.execute(drop_table) # yukarida calisan statement ler cevrime sokuluyor. drop_table ile mevcut user varsa siliniyor
db.session.execute(users_table) # users_table ile users isimli 2 sütunlu tablo yaratiyoruz
db.session.execute(data) # data ile yeni olusturulan users isimli tabloya veri giriyoruz.
db.session.commit()

# Write a function named `find_emails` which find emails using keyword from the users table in the db,
# and returns result as tuples `(name, email)`.

# keyword un sag ve solundaki % isaretleri sayesinde Hakan yerine aka bile yazsak Hakan i bulur. 

def find_emails(keyword):
    query=f"""
    SELECT * FROM users WHERE username like '%{keyword}%'; 
    """
    result = db.session.execute(query)
    user_emails = [(row[0], row[1]) for row in result]
    if not any(user_emails):
        user_emails = [('Not Found', 'Not Found')]
    return user_emails

# Write a function named `insert_email` which adds new email to users table the db.
def insert_email(name, email):
    query = f"""
    SELECT * FROM users WHERE username LIKE '{name}';
    """
    result = db.session.execute(query)
    if name == None or email == None: # name yada mail girilmemis ise bos olamaz diyecek
        response = 'Username or email can not be empty'
    elif not any(result): # girilen name-email ikilisi database de yoksa users tablosuna eklenecek
        insert = f"""
        INSERT INTO users 
        VALUES ('{name}', '{email}');
        """
        result = db.session.execute(insert)
        db.session.commit()
        response =f'User {name} added successfully'
    else:
        response = f'User {name} already exist.' # girilen name-email ikilisi database de zaten varsa bu uyari gelecek
    return response 

# Write a function named `emails` which finds email addresses by keyword using `GET` and `POST` methods,
# using template files named `emails.html` given under `templates` folder
# and assign to the static route of ('/')

# keyword olarak girilen user_name veritabaninda var ise find_emails function calisiyor ve user_emails i buluyor
@app.route('/', methods =['GET','POST']) # kök rout a gelen bir istek
def emails():
    if request.method == 'POST':
        user_name = request.form['username']
        user_emails = find_emails(user_name) # yukariki satirda elde edilen user_name i degisken olarak iki onceki bölumde tanimlanan find_emails fonksiyonuna sokariz
        return render_template('emails.html', name_emails=user_emails, keyword=user_name, show_result=True) # burada elde edilen parametreler emails.html e gonderiliyor
    else: 
        return render_template('emails.html', show_result = False)

#Write a function named `add_email` which inserts new email to the database using `GET` and `POST` methods,
# using template files named `add-email.html` given under `templates` folder
# and assign to the static route of ('add')

# girilen name-email ikilisi database de yoksa insert_email function calisiyor ve yeni bilgiyi database ekliyor

@app.route('/add', methods =['GET','POST'])
def add_email():
    if request.method == 'POST':
        user_name =request.form['username']
        user_email = request.form['useremail']
        result = insert_email(user_name, user_email) # yukariki satirda elde edilen user_name ve user_email i degisken olarak iki onceki bölumde tanimlanan insert_email fonksiyonuna sokariz
        return render_template('add-email.html', result_html=result, show_result=True) # yeni eklenen name-email ikilisi result degiskenine atanmisti. Bu degisken add-email.html sayfasina gonderiliyor.  
                                                                                    # showresult=True "successfully added" yada "already exist" vb sonucu verecegin sayfa olacak. showresult=False kullanicidan degerleri alacagin sayfa olacak
    else:   

        return render_template('add-email.html', show_result=False)                 

# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ =='__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=80)