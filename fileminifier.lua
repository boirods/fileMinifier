----------------------------------------
-- Script feito em linguagem lua para realizar a redução de arquivos de código fonte de linguagens variadas.
-- @module fileminifier
-- @author Rodrigo Régio de Araújo
-- @license MIT
-- @copyright boirods

local io = require('io')

---Função exibeMensagemInicial
-- Função para exibição da mensagem inicial
-- @param arquivo string com o nome e caminho do arquivo a ser reduzido (este parâmetro pode ser nil, e se for será solicitado)
-- @return nome do arquivo (ou informado ou passado como parâmetro)
function exibeMensagemInicial(arquivo)
	print("---------------------------")
	print("- Minimizador de arquivos -")
	print("---------------------------")
	if arquivo == nil then
		print('Digite o caminho completo do arquivo que você deseja minimizar:')
		arquivo=io.read()
	end
	return arquivo
end

---Função removeHtmlComments
-- Função que remove comentários de códigos html
-- @param textoDoArquivoMinificado é o texto do arquivo já reduzido
-- @return textoDoArquivoMinificado é o texto do arquivo já reduzido
function removeHtmlComments(textoDoArquivoMinificado)
	local padrao = {"<!--", "%-%->"} --se a string desejada der errado tente colocando o caractere % na frente dos caracteres ignorados
	local possuiComentarios = true
	while possuiComentarios do
		local inicioComentario = {}
		inicioComentario = string.find(textoDoArquivoMinificado, padrao[1])
		local fimComentario = {}
		fimComentario = string.find(textoDoArquivoMinificado, padrao[2])
		if inicioComentario ~= nil and fimComentario ~= nil then
			possuiComentarios = true
		else
			return textoDoArquivoMinificado
		end
		local inicioComentario, teste = string.find(textoDoArquivoMinificado, padrao[1]) -- saber onde inicia o comentário
		local teste, fimComentario = string.find(textoDoArquivoMinificado, padrao[2])    -- saber onde termina o comentário

		local inicioTexto = string.sub(textoDoArquivoMinificado, 1, inicioComentario - 1)                            -- pega o inicio do texto até antes de iniciar o comentário
		local fimTexto = string.sub(textoDoArquivoMinificado, fimComentario + 1, string.len(textoDoArquivoMinificado)) -- pega o fim do texto de onde termina o comentário até o fim do código

		textoDoArquivoMinificado = inicioTexto.. fimTexto
	end
end

---Função removeJavaMultipleLineComments
-- Remove comentários de multiplas linhas baseado na linguagem java (que começam e terminam com  /* e */)
-- @param textoDoArquivoMinificado é o texto do arquivo já reduzido
-- @return textoDoArquivoMinificado é o texto do arquivo já reduzido
function removeJavaMultipleLineComments(textoDoArquivoMinificado)
	local padrao = {"/%*", "%*/"}
	local possuiComentarios = true
	while possuiComentarios do
		local inicioComentario = {}
		inicioComentario = string.find(textoDoArquivoMinificado, padrao[1])
		local fimComentario = {}
		fimComentario = string.find(textoDoArquivoMinificado, padrao[2])
		if inicioComentario ~= nil and fimComentario ~= nil then
			possuiComentarios = true
		else
			return textoDoArquivoMinificado
		end
		local inicioComentario, teste = string.find(textoDoArquivoMinificado, padrao[1])
		local teste, fimComentario = string.find(textoDoArquivoMinificado, padrao[2])

		local inicioTexto = string.sub(textoDoArquivoMinificado, 1, inicioComentario -1)
		local fimTexto = string.sub(textoDoArquivoMinificado, fimComentario + 1, string.len(textoDoArquivoMinificado))

		textoDoArquivoMinificado = inicioTexto.. fimTexto
	end
end

---Função removeSingleLineComments
-- Função que remove comentários de linha unica
-- @param linha é a linha que poderá ter comentários de linha unica como // ou #
-- return linha já com os comentários removidos
function removeSingleLineComments(linha)
	local padrao = {"//", "#"}
	local posicaoBarraBarra=0
	if string.find(linha, padrao[1]) then
		posicaoBarraBarra = string.find(linha, padrao[1])

		if temDoisPontosAntesBarraBarra(linha, posicaoBarraBarra) then
			return linha
		else 
			--testa //
			local inicio, fim = string.find(linha, padrao[1])
			linha = string.sub(linha, 1, inicio - 1)
			return linha
		end
	elseif string.find(linha, padrao[2]) ~= nil then
		--testa #
		local inicio, fim = string.find(linha, padrao[2])
		linha = string.sub(linha, 1, inicio - 1)
		return linha
	else
		return linha
	end
end

---Função temDoisPontosAntesBarraBarra
-- Função que checa se o comentário // não é de um link (se for de um link não deve ser removido)
-- @param linha a linha a ser verificada se possui o caractere : antes do //
-- @param posicaoBarraBarra é a posição do //
-- @return true ou false
function temDoisPontosAntesBarraBarra(linha, posicaoBarraBarra)
	local posicaoDoisPontos = string.find(linha, ':')
	if posicaoDoisPontos == (posicaoBarraBarra - 1) then
		return true
	end
end

---
-- Função "principal" pois é ela que chama algumas das outras funções e inicia a remoção de tabulações e quebras de linha
-- @param arquivo é o caminho e nome do arquivo a ser reduzido
-- @return primeiraLinha que é o arquivo reduzido e em somente uma linha
function minificaArquivo(arquivo)
	local primeiraLinha = ''
	for linha in io.lines(arquivo) do
		--remove \t (tabulações na linha)
		linha = string.gsub(linha, "\t+","")
		--[[ Colocar abaixo removedores de comentários que devem ser feitos durante a remoção de tabulações (\t) --]]
		linha = removeSingleLineComments(linha)
		--[[ Fim de removedores de comentários]]
		primeiraLinha = primeiraLinha .. linha
	end
	--[[ Colocar abaixo removedores de comentários que possuem caracteres que iniciam e terminam de modos diferentes, como comentários de html e de java com multiplas linhas --]]
	primeiraLinha = removeHtmlComments(primeiraLinha)
	primeiraLinha = removeJavaMultipleLineComments(primeiraLinha)
	--[[ fim de removedores de comentários]]
	return primeiraLinha
end

---
-- Função que gera um novo arquivo com a extensão .min
-- @param primeiraLinha que é o arquivo já minificado e em somente uma linha
-- @return novoArquivo é o nome do novo arquivo com a extensão .min, e primeiraLinha já explicado anteriormente
function geraESalvaArquivoMinificado(primeiraLinha)
	local novoArquivo = arquivo..'.min'
	print("\n\nO arquivo foi salvo em: ".. novoArquivo)
	return novoArquivo, primeiraLinha
end

---
-- Função que salva o arquivo gerado no caminho e nome informados
-- @param caminho é o caminho e nome do arquivo já com a extensão .min
-- @param primeiraLinha a ser salva no arquivo
function salvaArquivo(caminho, primeiraLinha)
	arquivo = io.open(caminho, 'w+')
	arquivo:write(primeiraLinha)
	arquivo:flush()
	arquivo:close()
end

arquivo = exibeMensagemInicial()
minificado = minificaArquivo(arquivo) --chamar para minificar os comentários de html nesta função
salvaArquivo(geraESalvaArquivoMinificado(minificado))