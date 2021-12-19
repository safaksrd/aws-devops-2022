OZET: 2020-09-02
Yeni repoya uygun sekilde wget adresleri guncellendi!!

- Part-2: Alttaki komutlari EC2 instance uzerinde calistir.
- ssh -i leon.pem ec2-user@52.23.205.60
- sudo yum update -y
- sudo yum install python3 -y
- python3 --version
- sudo pip3 install flask
- pip3 list

- Part-3: Github repona lokalde olusturdugun app.py belgesini ekle (git add/comment/push) ve Github repona gonderdigin app.py belgesinin raw adresini kopyala
- wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/class-notes/_Safak_AWS_Python_Handson/20200902-flask-02-handling-routes-and-templates-on-ec2-linux2/EC2/app.py
- ls komutu ile EC2 instance a app.py nin gelip gelmedigini kontrol et
- mkdir templates
- cd templates
- templates klasoru altina tek tek evens.html, list100.html ve greet.html raw uzantilarini wget ile aliyoruz.
- wget https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/class-notes/_Safak_AWS_Python_Handson/20200902-flask-02-handling-routes-and-templates-on-ec2-linux2/EC2/templates/evens.html
- https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/class-notes/_Safak_AWS_Python_Handson/20200902-flask-02-handling-routes-and-templates-on-ec2-linux2/EC2/templates/greet.html
- https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/class-notes/_Safak_AWS_Python_Handson/20200902-flask-02-handling-routes-and-templates-on-ec2-linux2/EC2/templates/list100.html
- Bir ust klasore cik.
- sudo python3 app.py
- EC2 adresine webpage uzerinden baglan ve gor.

# Hands-on Flask-02 : Handling Routes and Templates with Flask Web Application

Purpose of the this hands-on training is to give the students introductory knowledge of how to handle routes and use html templates within a Flask web application on Amazon Linux 2 EC2 instance. 

## Learning Outcomes

At the end of the hands-on training, students will be able to;

- install Python and Flask framework on Amazon Linux 2 EC2 instance

- build a simple web application with Flask framework.

- understand the HTTP request-response cycle and structure of URL.

- create routes (or views) with Flask.

- serve static content and files using Flask.

- serve dynamic content using the html templates.

- write html templates using Jinja Templating Engine.

## Outline

- Part 1 - Getting to know routing and HTTP URLs.

- Part 2 - Install Python and Flask framework Amazon Linux 2 EC2 Instance 

- Part 3 - Write a Web Application with Sample Routings and Templating on GitHub Repo

- Part 4 - Run the Web App on EC2 Instance

## Part 1 - Getting to know routing and HTTP URLs.

HTTP (Hypertext Transfer Protocol) is a request-response protocol. A client on one side (web browser) asks or requests something from a server and the server on the other side sends a response to that client. When we open our browser and write down the URL (Uniform Resource Locator), we are requesting a resource from a server and the URL is the address of that resource. The structure of typical URL is as the following.

![URL anatomy](./url-structure.png)

The server responds to that request with an HTTP response message. Within the response, a status code element is a 3-digit integer defines the category of response as shown below.

- 1xx -> Informational

- 2xx -> Success

- 3xx -> Redirection

- 4xx -> Client Error

- 5xx -> Server Error

## Part 2 - Install Python and Flask framework Amazon Linux 2 EC2 Instance 

- Launch an Amazon EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH (Port 22) and HTTP (Port 80) connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-15-183-78.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install `Python 3` packages.

```bash
sudo yum install python3 -y
```

- Check the python3 version

```bash
python3 --version
```

- Install `Python 3 Flask` framework.

```bash
sudo pip3 install flask
```

- Check the versions of Flask framework packages (flask, click, itsdangerous, jinja2, markupSafe, werkzeug)

```bash
pip3 list
```

## Part 3 - Write a Web Application with Sample Routings and Templating on GitHub Repo

- Create folder named `flask-02-handling-routes-and-templates-on-ec2-linux2` within `clarusway-python-workshop` repo

- Create python file named `app.py`

- Write an application with routing and templating samples and save the complete code under `hands-on/flask-02-handling-routes-and-templates-on-ec2-linux2` folder.

```python
#Import Flask modules
from flask import Flask, redirect, url_for, render_template

#Create an object named app 
app = Flask(__name__)

# Create a function named home which returns a string 'This is home page for no path, <h1> Welcome Home</h1>' 
# and assign route of no path ('/')
@app.route('/')
def home():
    return 'This is home page for no path, <h1> Welcome Home</h1>'

# Create a function named about which returns a formatted string '<h1>This is my about page </h1>' 
# and assign to the static route of ('about')
@app.route('/about')
def about():
    return '<h1>This is my about page</h1>'

# Create a function named error which returns a formatted string '<h1>Either you encountered an error or you are not authorized.</h1>' 
# and assign to the static route of ('error')
@app.route('/error')
def error():
    return '<h1>Either you encountered an error or you are not authorized.</h1>'

# Create a function named hello which returns a string of '<h1>Hello, World! </h1>' 
# and assign to the static route of ('/hello')
@app.route('/hello')
def hello():
    return '<h1>Hello,World!</h1>'

# Create a function named admin which redirect the request to the error path 
# and assign to the route of ('/admin')
# Not: admin sayfasini talep edince error fonksiyonuna yonlendiriliyor
@app.route('/admin')
def admin():
    return redirect(url_for('error'))

# Create a function named greet which return formatted inline html string 
# and assign to the dynamic route of ('/<name>')
# Not: Dinamik websayfalarinda en onemli kural tanimladigimiz stringi fonksiyondaki parantezin icine yazariz.

# 1.yol : Basit bir string olarak gorunmesini istiyorsak;

# @app.route('/<name>')
# def greet(name):
#    return f'Hello, { name }'

# 2.yol : Inline bir web sayfasi olarak gorunmesini istiyorsak; 
# once html sayfasinin tanimlanacagi bir degisken tanimliyoruz. bu ornekte greet_format degiskeni olusturuldu
# Sonra son satirda return ile bu degiskene donus yapiyoruz.

# @app.route('/<name>')
# def greet(name):
#    greet_format=f"""
# <!DOCTYPE html>
# <html>
# <head>
#    <title>Greeting Page</title>
# </head>
# <body>
#    <h1>Hello, { name }!</h1>
#    <h1>Welcome to my Greeting Page</h1>
# </body>
# </html>
#    """
#    return greet_format

# Create a function named greet_admin which redirect the request to the hello path with parameter of 
# 'Master Admin!!!!' and assign to the route of ('/greet-admin')
# Not: greet-admin talep edilince greet fonksiyonuna yönlendir ve 
# greet fonksiyonundaki name degiskenini de Master Admin!!! yap
@app.route('/greet-admin')
def greet_admin():
    return redirect(url_for('greet', name = 'Master Admin!!!!'))


# Rewrite a function named greet which which uses template file named `greet.html` under `templates` folder 
# and assign to the dynamic route of ('/<name>')
# Not: Alttaki greet fonksiyonu html sayfasina yonlendirecek.
# Bunun calismasi icin daha once yazilan iki adet greet fonksiyonu yoruma cevir ve 
# giriste render_template import edilir
# greet.html deki isim degiskeni app.py deki name degiskenine esit.
@app.route('/<name>')
def greet(name):
    return render_template('greet.html', isim = name)
# Not: Dilersek render_template parantezinde isim degiskeninden sonra number1, number2 degiskeni de tanimlar
# ve sonra greet.html body sinde bunlari isim degiskeni gibi yazdirtabiliriz.
# Ancak parantez icinde toplam=number1+number2 yazarsak ayni parantez icinde oldugu için bunu hesaplayamaz.
# nmber1, number2 degiskenlerini return den once tanimlarsak sorun olmaz.

# Create a function named list100 which creates a list counting from 1 to 100 within `list100.html` 
# and assign to the route of ('/list100')
# Not: list100.html e gidecek ve orada for dongusu calistirip sonuclari yazdiracak
@app.route('/list100')
def list100():
    return render_template('list100.html')


# Create a function named evens which show the even numbers from 1 to 10 within `evens.html` 
# and assign to the route of ('/evens')
# Not: evens.html e gidecek ve orada for dongusu icinde if kullanarak cift sayilari yazdiracak
@app.route('/evens')
def evens():
    return render_template('evens.html')


# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ == '__main__':
    #app.run(debug = True)
    app.run(host='0.0.0.0', port=80)

```

- Write a template html file named `greet.html` which takes `name` as parameter under `templates` folder 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>Hello, {{ isim }}</h1> 
    <h1>Welcome to my Greeting Page</h1>
</body>
</html>

- Write a template html file named `list100.html` which shows a list counting from 1 to 100 under `templates` folder 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List100</title>
</head>
<body>
    <h1>Created 100 List Items</h1>
    <ul>
    {% for x in range(1,101) %}
    <li>List item {{ x }}</li>
    {% endfor %}
    </ul>
</body>
</html>

- Write a template html file named `evens.html` which shows a list of even numbers from 1 to 10 under `templates` folder 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List Evens</title>
</head>
<body>
    <h1>Showing Even Number from 1 to 10</h1>
    <ul>
        {% for x in range(1,11) %}
            {% if x%2==0 %}
            <li>Number {{ x }} is even</li>
            {% endif %}
        {% endfor %}

    </ul>
    
</body>
</html>

- Create a folder named `static` under `hands-on/flask-02-handling-routes-and-templates-on-ec2-linux2` folder and create a text file named `mytext.txt` with *This is a text file in static folder* content.

- Add and commit all changes on local repo

- Push `app.py`, `greet.html`, `list10.html`, `evens.html`, and `mytext.txt` to remote repo `clarusway-python-workshop` on GitHub.

## Part 4 - Run the Hello World App on EC2 Instance

- Download the web application file from GitHub repo.
wget

- Run the web application


- Connect the route handling and templating web application from the web browser and try every routes configured


- Open the static file `mytext.txt` context from the web browser


- Connect the route handling and templating web application from the terminal with `curl` command.

