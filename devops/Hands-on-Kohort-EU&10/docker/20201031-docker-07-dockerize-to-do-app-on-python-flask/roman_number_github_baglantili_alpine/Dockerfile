FROM python:alpine
# RUN yum update -y && \
#     yum install -y git
WORKDIR /app/templates
ADD https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/templates/index.html .
ADD https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/templates/result.html .
WORKDIR /app
COPY requirements.txt .
RUN pip3 install -r requirements.txt
ADD https://raw.githubusercontent.com/safaksrd/aws-devops-2022/main/aws/Class-Notes-Kohort-EU/Safak_Notes/20200930-001-roman-numerals-converter/app.py .
EXPOSE 80
CMD python3 ./app.py