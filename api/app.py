from flask import Flask, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

@app.route('/cnpj/<cnpj>')
def consultar_cnpj(cnpj):
    url = f'https://www.receitaws.com.br/v1/cnpj/{cnpj}'
    resposta = requests.get(url)
    dados = resposta.json()
    return jsonify(dados)

@app.route('/servicos/<codSiorg>')
def consultar_servico(codSiorg):
    url = f'https://www.servicos.gov.br/api/v1/orgao/codSiorg/{codSiorg}'
    resposta = requests.get(url)
    dados = resposta.json()
    return jsonify(dados)

if __name__ == '__main__':
    app.run(debug=True)