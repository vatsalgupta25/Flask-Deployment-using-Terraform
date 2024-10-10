from flask import Flask, render_template, request, render_template_string
from logic import data
import re
from tabulate import tabulate

app = Flask(__name__)

def dict_to_html_table(data):
    headers = data.keys()
    rows = [list(data.values())]
    table_html = tabulate(rows, headers, tablefmt='html')
    return table_html

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process_input', methods=['POST'])
def process_input():
    user_input = request.form.get('user_input')
    email_pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    if re.match(email_pattern, user_input):
        a = render_template('Details.html')
        return a
    else:
        a = render_template('index.html')
        return a
    return 0

@app.route('/logic', methods = ['POST'])
def logic():
    param1 = int(request.form['age'])
    param2 = str(request.form['name'])
    param3 = int(request.form['income'])
    a = data(param1,100)
    b = param2
    c = 0.7*param3
    d = param1
    html_table = dict_to_html_table(a)
    return render_template('logic.html', a=html_table, b=b, c=c, d=d)

if __name__ == '__main__':
    app.run(debug=True)
