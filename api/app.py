import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

# Tokens vindos do .env
token_cofiex = os.getenv('TOKEN_COFIEX')
token_cgu = os.getenv('TOKEN_CGU')  # agora carregado logo no início

# Substituir TOKEN_PORTAL pelo valor fixo
TOKEN_PORTAL = 'd1b5fac8951a331b63047753f1eaa2fb'

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

# Remover o endpoint de CPF, adicionar o de deputados
@app.route('/deputados')
def buscar_deputados():
    nome = request.args.get('nome', '')
    url = f'https://dadosabertos.camara.leg.br/api/v2/deputados?nome={nome}'
    headers = {
        'Accept': 'application/json'
    }
    resposta = requests.get(url, headers=headers)
    if resposta.status_code == 200:
        dados = resposta.json()
        # O resultado está em dados['dados']
        return jsonify(dados['dados'])
    else:
        return jsonify({'erro': 'Erro ao consultar deputados', 'status': resposta.status_code, 'detalhe': resposta.text}), resposta.status_code

@app.route('/servidores')
def buscar_servidores():
    nome = request.args.get('nome', '')
    url = f'https://api.portaldatransparencia.gov.br/api-de-dados/pessoas-fisicas?nome={nome}&pagina=1'
    headers = {
        'Accept': 'application/json',
        'chave-api-dados': TOKEN_PORTAL
    }
    resposta = requests.get(url, headers=headers)
    if resposta.status_code == 200:
        dados = resposta.json()
        servidores = [p for p in dados if 'Servidor' in (p.get('vinculo', '') or '')]
        return jsonify(servidores)
    else:
        return jsonify({'erro': 'Erro ao consultar servidores', 'status': resposta.status_code}), resposta.status_code

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
