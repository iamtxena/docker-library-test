from flask import Flask, make_response
from src.qibo_test import TestQibo
app = Flask(__name__)


@app.route('/')
def hello():
    return 'Hello World'


@app.route('/qibo')
def test_qibo():
    tqibo = TestQibo()
    return make_response(tqibo.execute_circuit(), 200)


@app.route('/qili')
def test_qili():
    tqibo = TestQibo()
    return make_response(tqibo.execute_qili_circuit(), 200)


if __name__ == '__main__':
    app.run()
