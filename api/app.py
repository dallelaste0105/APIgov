from flask import Flask, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

# Tokens vindos do .env
token_cofiex = os.getenv('TOKEN_COFIEX')
token_cgu = os.getenv('TOKEN_CGU')  # agora carregado logo no início

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

@app.route('/cep/<cep>')
def consultar_cep(cep):
    url = f'https://brasilapi.com.br/api/cep/v1/{cep}'
    try:
        resposta = requests.get(url, timeout=10)
        if resposta.status_code == 200:
            return jsonify(resposta.json())
        elif resposta.status_code == 404:
            return jsonify({"erro": "CEP não encontrado."}), 404
        else:
            return jsonify({"erro": "Erro ao consultar o CEP", "status": resposta.status_code}), resposta.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({"erro": "Erro ao acessar a API", "detalhes": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
